//
//  Bridges+Application.swift
//  PostgresBridge
//
//  Created by Mihael Isaev on 30.01.2020.
//

import Bridges

extension BridgesApplication {
    public var mysql: MySQLBridge {
        .init(bridges.bridge(to: _MySQLBridge.self, on: eventLoopGroup.next()))
    }
}

extension BridgesRequest {
    public var mysql: MySQLBridge {
        .init(bridgesApplication.bridges.bridge(to: _MySQLBridge.self, on: eventLoop))
    }
}

import NIO
import Logging

extension _MySQLBridge {
    public static func create(eventLoopGroup: EventLoopGroup, logger: Logger) -> AnyBridge {
        _MySQLBridge(eventLoopGroup: eventLoopGroup, logger: logger)
    }
}
