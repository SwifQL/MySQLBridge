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
        .init(name: ProcessInfo.processInfo.environment["MYSQL_DB"], host: .mysqlEnvironment, maxConnectionsPerEventLoop: 1)
    }

    public init?(url: URL, maxConnectionsPerEventLoop: Int = 1) {
        guard let host = DatabaseHost(url: url) else {
            return nil
        }
        self.init(name: url.path.split(separator: "/").last.flatMap(String.init), host: host, maxConnectionsPerEventLoop: maxConnectionsPerEventLoop)
    }
}
