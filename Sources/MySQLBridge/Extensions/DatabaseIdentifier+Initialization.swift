//
//  DatabaseIdentifier+Initialization.swift
//  MySQLBridge
//
//  Created by Mihael Isaev on 30.01.2020.
//

import Foundation
import Bridges

extension DatabaseIdentifier {
    /// Initialize identifier based on `MYSQL_DB` environment variable
    public static var mysqlEnvironment: DatabaseIdentifier {
        MySQLDatabaseIdentifier(name: ProcessInfo.processInfo.environment["MYSQL_DB"], host: .mysqlEnvironment, maxConnectionsPerEventLoop: 1)
    }
    
    public static func mysql(name: String? = ProcessInfo.processInfo.environment["MYSQL_DB"], host: DatabaseHost, maxConnectionsPerEventLoop: Int = 1) -> DatabaseIdentifier {
        MySQLDatabaseIdentifier(name: name, host: host, maxConnectionsPerEventLoop: maxConnectionsPerEventLoop)
    }
}

public class MySQLDatabaseIdentifier: DatabaseIdentifier, MySQLDatabaseIdentifiable {
    public  typealias B = MBR
    
    public convenience init?(url: URL, maxConnectionsPerEventLoop: Int = 1) {
        guard let host = DatabaseHost(url: url) else {
            return nil
        }
        self.init(name: url.path.split(separator: "/").last.flatMap(String.init), host: host, maxConnectionsPerEventLoop: maxConnectionsPerEventLoop)
    }
    
    public func all<T>(_ table: T.Type, on bridges: AnyBridgesObject) -> EventLoopFuture<[T]> where T : Table {
        MySQLBridge(bridges.bridges.bridge(to: B.self, on: bridges.eventLoop)).connection(to: self) { conn in
            T.select.execute(on: conn).all(decoding: T.self)
        }
    }
    
    public func first<T>(_ table: T.Type, on bridges: AnyBridgesObject) -> EventLoopFuture<T?> where T : Table {
        MySQLBridge(bridges.bridges.bridge(to: B.self, on: bridges.eventLoop)).connection(to: self) { conn in
            T.select.execute(on: conn).first(decoding: T.self)
        }
    }
    
    public func query(_ query: SwifQLable, on bridges: AnyBridgesObject) -> EventLoopFuture<[BridgesRow]> {
        MySQLBridge(bridges.bridges.bridge(to: B.self, on: bridges.eventLoop)).connection(to: self) { conn in
            query.execute(on: conn).map { $0 as [BridgesRow] }
        }
    }
}
