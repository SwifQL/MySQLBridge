import NIO
import MySQLNIO
import AsyncKit
import Bridges
import Logging

public final class MySQLBridge: Bridgeable {
    public typealias Source = MySQLConnectionSource
    public typealias Database = MySQLDatabase
    public typealias Connection = MySQLConnection
    
    public static var dialect: SQLDialect { .mysql }
    
    public var pools: [String: GroupPool] = [:]
    
    public let logger: Logger
    public let eventLoopGroup: EventLoopGroup
    
    required public init (eventLoopGroup: EventLoopGroup, logger: Logger) {
        self.eventLoopGroup = eventLoopGroup
        self.logger = logger
    }
    
    /// Gives a connection to the database and closes it automatically in both success and error cases
    public func connection<T>(to db: DatabaseIdentifier,
                                           _ closure: @escaping (MySQLConnection) -> EventLoopFuture<T>) -> EventLoopFuture<T> {
        self.db(db).withConnection { conn in
            closure(conn).flatMap { result in
                if conn.isClosed {
                    return conn.eventLoop.future(result)
                } else {
                    return conn.close().transform(to: result)
                }
            }.flatMapError { error in
                if conn.isClosed {
                    return conn.close().flatMapThrowing {
                        throw error
                    }
                } else {
                    return conn.eventLoop.makeFailedFuture(error)
                }
            }
        }
    }
    
    public func db(_ db: DatabaseIdentifier) -> MySQLDatabase {
        _ConnectionPoolMySQLDatabase(pool: pool(db), logger: logger)
    }
    
    deinit {
        shutdown()
    }
}

// MARK: Database on pool

extension EventLoopConnectionPool where Source == MySQLConnectionSource {
    public func database(logger: Logger) -> MySQLDatabase {
        _ConnectionPoolMySQLDatabase(pool: self, logger: logger)
    }
}

private struct _ConnectionPoolMySQLDatabase {
    let pool: EventLoopConnectionPool<MySQLConnectionSource>
    let logger: Logger
}

extension _ConnectionPoolMySQLDatabase: MySQLDatabase {
    var eventLoop: EventLoop {
        self.pool.eventLoop
    }
    
    func send(_ command: MySQLCommand, logger: Logger) -> EventLoopFuture<Void> {
        self.pool.withConnection(logger: logger) {
            $0.send(command, logger: logger)
        }
    }
    
    func withConnection<T>(_ closure: @escaping (MySQLConnection) -> EventLoopFuture<T>) -> EventLoopFuture<T> {
        self.pool.withConnection(logger: self.logger, closure)
    }
}
