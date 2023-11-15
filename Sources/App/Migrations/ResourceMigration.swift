//
//  ResourceMigration.swift
//  
//
//  Created by Lidiane Gomes Barbosa on 30/10/23.
//

import Fluent

struct ResourceMigration: AsyncMigration {
    let schema = Resource.schema.self
    let keys = Resource.FieldKeys.self
    
    func prepare(on database: Database) async throws {
    
        try await database.schema(schema)
            .id()
            .field(keys.type, .string)
            .field(keys.content, .string)
            .field(keys.createdAt, .datetime)
            .field(keys.updatedAt, .datetime)
            .unique(on: keys.content)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(schema).delete()
    }
}
