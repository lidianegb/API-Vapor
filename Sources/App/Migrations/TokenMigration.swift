//
//  TokenMigration.swift
//
//
//  Created by Lidiane Gomes Barbosa on 07/11/23.
//

import Foundation
import Fluent
import Vapor

struct TokenMigration: AsyncMigration {
    
    let keys = Token.FieldKeys.self
    let schema = Token.schema.self
    
    func prepare(on database: Database) async throws {
        try await database.schema(schema)
            .id()
            .field(keys.value, .string)
            .field(keys.userID, .uuid)
            .create()
    }
    func revert(on database: Database) async throws {
        try await database.schema(schema).delete()
    }
}
