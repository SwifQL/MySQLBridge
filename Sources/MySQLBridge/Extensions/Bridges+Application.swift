//
//  Bridges+Application.swift
//  PostgresBridge
//
//  Created by Mihael Isaev on 30.01.2020.
//

import Bridges

extension BridgesApplication {
    public var mysql: MySQLBridge {
        bridges.bridge(to: MySQLBridge.self)
    }
}

import NIO
import Logging

extension MySQLBridge {
    public static func create(eventLoopGroup: EventLoopGroup, logger: Logger) -> AnyBridge {
        MySQLBridge(eventLoopGroup: eventLoopGroup, logger: logger)
    }
}
