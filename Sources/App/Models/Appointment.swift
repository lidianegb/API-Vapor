//
//  Appointment.swift
//
//
//  Created by Lidiane Gomes Barbosa on 31/10/23.
//

import Fluent
import Vapor

final class Appointment: Model {
    static let schema = SchemaEnum.appointment.rawValue
    
    @ID(key: .id)
    var id: UUID?

    @OptionalField(key: FieldKeys.date)
    var date: Date?
    
    @OptionalField(key: FieldKeys.monitorName)
    var monitorName: String?
    
    @OptionalField(key: FieldKeys.monitorId)
    var monitorId: UUID?
    
    @OptionalField(key: FieldKeys.user)
    var user: UUID?
    
    @Timestamp(key: FieldKeys.createdAt, on: .create)
    var createdAt: Date?
    
    @Timestamp(key: FieldKeys.updatedAt, on: .update)
    var updatedAt: Date?
    
    @OptionalField(key: FieldKeys.status)
    var status: StatusEnum.RawValue?

    init() { }

    // create
    init(date: Date?, monitorId: UUID?, monitorName: String?, user: UUID?, createdAt: Date?, updatedAt: Date?, status: StatusEnum.RawValue) {
        self.date = date
        self.monitorId = monitorId
        self.monitorName = monitorName
        self.user = user
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.status = status
    }
    
    // update
    init(date: Date?, monitorId: UUID?, monitorName: String?, updatedAt: Date?, status: StatusEnum.RawValue) {
        self.date = date
        self.monitorId = monitorId ?? self.monitorId
        self.monitorName = monitorName ?? self.monitorName
        self.updatedAt = updatedAt
        self.status = status
    }
    
    // update status
    init(status: StatusEnum.RawValue?) {
        self.status = status
    }
    
    final class Public: Content {
        let id: UUID?
        let date: Date?
        let status: StatusEnum.RawValue
        let monitorName: String?
        let updatedAt: Date?
        
        init(id: UUID?, date: Date?, status: StatusEnum.RawValue, monitorName: String?, updatedAt: Date?) {
            self.id = id
            self.date = date
            self.status = status
            self.monitorName = monitorName
            self.updatedAt = updatedAt
        }
    }
}

extension Appointment: Content { }

extension Appointment {
    func convertToPublic() -> Appointment.Public {
        return Appointment.Public(id: id, date: date, status: status ?? StatusEnum.scheduled.rawValue, monitorName: monitorName, updatedAt: updatedAt)
    }
}

extension Collection where Element: Appointment {
    func convertToPublic() -> [Appointment.Public] {
        return self.map { $0.convertToPublic() }
    }
}
