//
//  PublicationMigration.swift
//
//
//  Created by Lidiane Gomes Barbosa on 31/10/23.
//

import Fluent

struct PublicationMigration: AsyncMigration {
    let schema = Publication.schema.self
    let keys = Publication.FieldKeys.self
    
    func prepare(on database: Database) async throws {
        try await database.schema(schema)
            .id()
            .field(keys.title, .string, .required)
            .field(keys.text, .string)
            .field(keys.videos, .array(of: .string))
            .field(keys.images, .array(of: .string))
            .field(keys.createdAt, .datetime)
            .field(keys.updatedAt, .datetime)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(schema).delete()
    }
}
