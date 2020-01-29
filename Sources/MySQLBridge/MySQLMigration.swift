//
//  MySQLMigration.swift
//  MySQLBridge
//
//  Created by Mihael Isaev on 30.01.2020.
//

import Bridges
import MySQLNIO

public protocol MySQLMigration: Migration {
    associatedtype Connection = MySQLConnection
}
