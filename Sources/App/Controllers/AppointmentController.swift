//
//  AppointmentController.swift
//
//
//  Created by Lidiane Gomes Barbosa on 31/10/23.
//

import Fluent
import Vapor

struct AppointmentController: AppointmentHandlerProtocol {
    typealias answer = Appointment.Public
    typealias request = Request
    typealias status = HTTPStatus
    
    func create(_ req: Vapor.Request) async throws -> Appointment.Public {
        let user = try req.auth.require(User.self)
        let appointment = try req.content.decode(CreateAppointmentDTO.self)
        return try await AppointmentService.create(req, appointment, user: user)
    }
    
    func get(_ req: Vapor.Request) async throws -> Appointment.Public {
        let id = req.parameters.get("id", as: UUID.self)
        return try await AppointmentService.get(req, object: id)
    }
    
    func getAll(_ req: Vapor.Request) async throws -> [Appointment.Public] {
        let user = try req.auth.require(User.self)
        return try await AppointmentService.getAll(req, user: user)
    }
    
    func update(_ req: Vapor.Request) async throws -> Appointment.Public {
        let id = req.parameters.get("id", as: UUID.self)
        let updatedAppointment = try req.content.decode(UpdateAppointmentDTO.self)
        return try await AppointmentService.update(req, object: id, updateDTO: updatedAppointment)
    }
    
    func delete(_ req: Vapor.Request) async throws -> Vapor.HTTPStatus {
        let id = req.parameters.get("id", as: UUID.self)
        return try await AppointmentService.delete(req, object: id)
    }
}

extension AppointmentController: AppointmentFilterHandlerProtocol {
    func getByStatus(_ req: Vapor.Request) async throws -> [Appointment.Public] {
        let status = req.parameters.get("status")
        let user = try req.auth.require(User.self)
        return try await AppointmentService.getByStatus(req, status: status, user: user)
    }
}
