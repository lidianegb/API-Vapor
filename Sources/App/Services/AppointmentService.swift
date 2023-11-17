//
//  AppointmentService.swift
//  
//
//  Created by Lidiane Gomes Barbosa on 06/11/23.
//

import Foundation
import Vapor
import Fluent

struct AppointmentService: AppointmentProtocol {
    
    typealias answer = Appointment.Public
    typealias request = Request
    typealias model = Appointment
    typealias status = HTTPStatus
    typealias createDTO = CreateAppointmentDTO
    typealias updateDTO = UpdateAppointmentDTO
    
    static func create(_ req: Vapor.Request, _ createDTO: CreateAppointmentDTO, user: User) async throws -> Appointment.Public{
        let monitor = try await User.find(createDTO.monitor, on: req.db)
        guard let date = createDTO.date, let schedule = monitor?.schedule, schedule.contains(date) else {
            throw Abort(.notFound, reason: "the monitor \(String(describing: monitor?.name)) is not available for that date \(String(describing: createDTO.date))")
        }
        let appointment = Appointment(
            date: createDTO.date,
            monitorId: createDTO.monitor,
            monitorName: monitor?.name,
            user: user.id,
            createdAt: Date(),
            updatedAt: Date(),
            status: StatusEnum.scheduled.rawValue
        )
        monitor?.schedule = monitor?.schedule?.filter { $0 != createDTO.date }
       
        try await monitor?.save(on: req.db)
        try await appointment.save(on: req.db)
        
        return appointment.convertToPublic()
    }
    
    static func get(_ req: Vapor.Request, object: UUID?) async throws -> Appointment.Public {
        guard let appointment = try await Appointment.find(object, on: req.db) else {
            throw Abort(.notFound, reason: "The appointment with ID of \(String(describing: object)) could not be found!")
        }
        return appointment.convertToPublic()
    }
    
    static func getAll(_ req: Vapor.Request, user: User) async throws -> [Appointment.Public] {
        let appointmentsUser = try await Appointment.query(on: req.db)
            .filter(\.$user == user.id)
            .sort(\.$date)
            .all()
            .map { $0.convertToPublic() }
        let appointmentsMonitor = try await Appointment.query(on: req.db)
            .filter(\.$monitorId == user.id)
            .sort(\.$date)
            .all()
            .map { $0.convertToPublic() }
        
        return (user.role == RoleEnum.admin.rawValue) ? appointmentsMonitor : appointmentsUser
    }
    
    static func update(_ req: Vapor.Request, object: UUID?, updateDTO: UpdateAppointmentDTO) async throws -> Appointment.Public {
        guard let appointment = try await Appointment.find(object, on: req.db) else {
            throw Abort(.notFound, reason: "The appointment with ID of \(String(describing: object)) could not be found!")
        }
        appointment.date = updateDTO.date ?? appointment.date
        appointment.monitorId = updateDTO.monitor ?? appointment.monitorId
        appointment.monitorName = updateDTO.monitorName ?? appointment.monitorName
        appointment.status = updateDTO.status ?? appointment.status
        appointment.updatedAt = Date()
        
        try await appointment.save(on: req.db)
        return appointment.convertToPublic()
    }
    
    static func delete(_ req: Vapor.Request, object: UUID?) async throws -> Vapor.HTTPStatus {
        guard let appointment = try await Appointment.find(object, on: req.db) else {
            throw Abort(.notFound, reason: "The appointment with ID of \(String(describing: object)) could not be found!")
        }
        if let userId = appointment.user, let monitorId = appointment.monitorId {
            let user = try await User.find(userId, on: req.db)
            let monitor = try await User.find(monitorId, on: req.db)
            
            user?.appointments = user?.appointments?.filter { $0 != appointment.id }
            monitor?.appointments = monitor?.appointments?.filter { $0 != appointment.id }
            
            try await user?.save(on: req.db)
            try await monitor?.save(on: req.db)
        }
        
        try await appointment.delete(on: req.db)
        return .ok
    }
}

extension AppointmentService: BackendAppointmentFilterProtocol {
    static func getByStatus(_ req: Vapor.Request, status: StatusEnum.RawValue?, user: User) async throws -> [Appointment.Public] {
        guard let status else {
            throw Abort(.notFound, reason: "The parameter status is not found!")
        }
        
        let appointmentsUser = try await Appointment.query(on: req.db)
            .filter(\.$user == user.id)
            .filter(\.$status == status)
            .all()
            .map { $0.convertToPublic() }
        
        let appointmentsMonitor = try await Appointment.query(on: req.db)
            .filter(\.$monitorId == user.id)
            .filter(\.$status == status)
            .sort(\.$date)
            .all()
            .map { $0.convertToPublic() }
        
        return (user.role == RoleEnum.admin.rawValue) ? appointmentsMonitor : appointmentsUser
    }
}
