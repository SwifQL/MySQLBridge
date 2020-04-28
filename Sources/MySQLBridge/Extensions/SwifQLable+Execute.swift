//
//  SwifQLable+Execute.swift
//  MySQLBridge
//
//  Created by Mihael Isaev on 30.01.2020.
//

import SwifQL

extension SwifQLable {
    @discardableResult
    public func execute(on conn: MySQLConnection) -> EventLoopFuture<[MySQLRow]> {
        let prepared = prepare(.mysql).splitted
        let binds: [MySQLData]
        do {
            binds = try prepared.values.map { try MySQLDataEncoder().encode($0) }
        } catch {
            return conn.eventLoop.makeFailedFuture(error)
        }
        return conn.query(prepared.query, binds)
    }
}
