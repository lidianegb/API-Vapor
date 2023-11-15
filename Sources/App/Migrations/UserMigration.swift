//
//  UserMigration.swift
//  
//
//  Created by Lidiane Gomes Barbosa on 30/10/23.
//

import Fluent

struct UserMigration: AsyncMigration {
    let schema = User.schema.self
    let keys = User.FieldKeys.self
    
    func prepare(on database: Database) async throws {
       
        try await database.schema(schema)
            .id()
            .field(keys.name, .string)
            .field(keys.userName, .string)
            .field(keys.registration, .string, .required)
            .field(keys.password, .string)
            .field(keys.schedule, .array(of: .datetime))
            .field(keys.appointments, .array(of: .uuid))
            .field(keys.role, .string)
            .field(keys.createdAt, .datetime)
            .field(keys.updatedAt, .datetime)
            .unique(on: keys.userName)
            .unique(on: keys.registration)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(schema).delete()
    }
}
