import NIO
import MySQLNIO
import AsyncKit
import Bridges
import Logging

public struct MySQLBridge: ContextBridgeable {
    public let context: BridgeWithContext<MBR>
        
    init (_ context: BridgeWithContext<MBR>) {
        self.context = context
    }
    
    public func connection<T>(to db: DatabaseIdentifier,
                                            _ closure: @escaping (MySQLConnection) -> EventLoopFuture<T>) -> EventLoopFuture<T> {
        context.bridge.connection(to: db, on: context.eventLoop, closure)
    }
    
    public func transaction<T>(to db: DatabaseIdentifier,
                                            _ closure: @escaping (MySQLConnection) -> EventLoopFuture<T>) -> EventLoopFuture<T> {
        context.bridge.transaction(to: db, on: context.eventLoop, closure)
    }
    
    public func register(_ db: DatabaseIdentifier) {
        context.bridge.register(db)
    }
    
    public func migrator(for db: DatabaseIdentifier) -> Migrator {
        BridgeDatabaseMigrations<MBR>(context.bridge, db: db)
    }
}

public final class MBR: Bridgeable {
    public typealias Source = MySQLConnectionSource
    public typealias Database = MySQLDatabase
    public typealias Connection = MySQLConnection
    
    public static var dialect: SQLDialect { .mysql }
    
    public var pools: [String: GroupPool] = [:]
    
    public let logger: Logger
    public let eventLoopGroup: EventLoopGroup
    
    public required init (eventLoopGroup: EventLoopGroup, logger: Logger) {
        self.eventLoopGroup = eventLoopGroup
        self.logger = logger
    }
    
    /// Gives a connection to the database and closes it automatically in both success and error cases
    public func connection<T>(to db: DatabaseIdentifier,
                                  on eventLoop: EventLoop,
                                  _ closure: @escaping (MySQLConnection) -> EventLoopFuture<T>) -> EventLoopFuture<T> {
        self.db(db, on: eventLoop).withConnection { closure($0) }
    }
    
    public func db(_ db: DatabaseIdentifier, on eventLoop: EventLoop) -> MySQLDatabase {
        _ConnectionPoolMySQLDatabase(pool: pool(db, for: eventLoop), logger: logger, eventLoop: eventLoop)
    }
    
    deinit {
        shutdown()
    }
}

// MARK: Database on pool

extension EventLoopConnectionPool where Source == MySQLConnectionSource {
    public func database(logger: Logger, on eventLoop: EventLoop) -> MySQLDatabase {
        _ConnectionPoolMySQLDatabase(pool: self, logger: logger, eventLoop: eventLoop)
    }
}

private struct _ConnectionPoolMySQLDatabase {
    let pool: EventLoopConnectionPool<MySQLConnectionSource>
    let logger: Logger
    let eventLoop: EventLoop
}

extension _ConnectionPoolMySQLDatabase: MySQLDatabase {
    func send(_ command: MySQLCommand, logger: Logger) -> EventLoopFuture<Void> {
        self.pool.withConnection(logger: logger) {
            $0.send(command, logger: logger)
        }
    }
    
    func withConnection<T>(_ closure: @escaping (MySQLConnection) -> EventLoopFuture<T>) -> EventLoopFuture<T> {
        self.pool.withConnection(logger: self.logger, closure)
    }
}
