//
//  Bridges+Application.swift
//  PostgresBridge
//
//  Created by Mihael Isaev on 30.01.2020.
//

import Bridges

extension BridgesApplication {
    public var mysql: MySQLBridge {
        .init(bridges.bridge(to: MBR.self, on: eventLoopGroup.next()))
    }
}

extension BridgesRequest {
    public var mysql: MySQLBridge {
        .init(bridgesApplication.bridges.bridge(to: MBR.self, on: eventLoop))
    }
}

import NIO
import Logging

extension MBR {
    public static func create(eventLoopGroup: EventLoopGroup, logger: Logger) -> AnyBridge {
        MBR(eventLoopGroup: eventLoopGroup, logger: logger)
    }
}
