//
//  MySQLConnection+Bridge.swift
//  MySQLBridge
//
//  Created by Mihael Isaev on 30.01.2020.
//

import Bridges
import NIO

extension MySQLConnection: BridgeConnection {
    public var dialect: SQLDialect { .mysql }
    
    public func query(raw: String) -> EventLoopFuture<Void> {
        query(raw).transform(to: ())
    }
    
    public func query<V: Decodable>(raw: String, decoding type: V.Type) -> EventLoopFuture<[V]> {
        query(raw).all(decoding: type)
    }
}
