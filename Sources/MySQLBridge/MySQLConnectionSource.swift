//
//  MySQLConnectionSource.swift
//  MySQLBridge
//
//  Created by Mihael Isaev on 30.01.2020.
//

import AsyncKit
import Bridges

public struct MySQLConnectionSource: BridgesPoolSource {
    public let db: DatabaseIdentifier

    public init(_ db: DatabaseIdentifier) {
        self.db = db
    }

    public func makeConnection(logger: Logger, on eventLoop: EventLoop) -> EventLoopFuture<MySQLConnection> {
        let address: SocketAddress
        do {
            address = try self.db.host.address()
        } catch {
            return eventLoop.makeFailedFuture(error)
        }
        return MySQLConnection.connect(
            to: address,
            username: self.db.host.username,
            database: self.db.name ?? self.db.host.username,
            password: self.db.host.password,
            tlsConfiguration: self.db.host.tlsConfiguration,
            logger: logger,
            on: eventLoop
        )
    }
}

extension MySQLConnection: ConnectionPoolItem {}

