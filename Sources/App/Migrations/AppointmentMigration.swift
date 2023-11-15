//
//  AppointmentMigration.swift
//
//
//  Created by Lidiane Gomes Barbosa on 31/10/23.
//

import Fluent

struct AppointmentMigration: AsyncMigration {
    let schema = Appointment.schema.self
    let keys = Appointment.FieldKeys.self
    
    func prepare(on database: Database) async throws {
        try await database.schema(schema)
            .id()
            .field(keys.date, .date, .required)
            .field(keys.monitorId, .uuid, .required)
            .field(keys.monitorName, .string)
            .field(keys.user, .uuid, .required)
            .field(keys.createdAt, .datetime, .required)
            .field(keys.updatedAt, .datetime, .required)
            .field(keys.status, .string)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(schema).delete()
    }
}
