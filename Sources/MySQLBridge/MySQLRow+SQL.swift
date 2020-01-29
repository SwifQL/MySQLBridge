//
//  MySQLRow+SQL.swift
//  MySQLBridge
//
//  Created by Mihael Isaev on 30.01.2020.
//

import Bridges
import MySQLNIO

struct MissingColumn: Error {
    let column: String
}

extension MySQLRow: SQLRow {
    public var allColumns: [String] {
        self.columnDefinitions.map { $0.name }
    }

    public func contains(column: String) -> Bool {
        self.columnDefinitions.contains { $0.name == column }
    }

    public func decodeNil(column: String) throws -> Bool {
        self.column(column) == nil
    }

    public func decode<D>(column: String, as type: D.Type) throws -> D where D : Decodable {
        guard let data = self.column(column) else {
            throw MissingColumn(column: column)
        }
        return try MySQLDataDecoder().decode(D.self, from: data)
    }
}
