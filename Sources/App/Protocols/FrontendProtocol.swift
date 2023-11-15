//
//  FrontendProtocol.swift
//
//
//  Created by Lidiane Gomes Barbosa on 10/11/23.
//

import Foundation
import Vapor
import Fluent

protocol FrontendProtocol {
    associatedtype model
    associatedtype answer
    associatedtype status
    associatedtype request
    associatedtype context
    
    static func getObject(_ req: request, object: String) async throws -> answer?
    static func getAllObjects(_ req: request) async throws -> [answer]
}

protocol ChangeUserInformationProtocol {
    associatedtype model
    associatedtype status
    associatedtype request
    
    static func addAppointmentsToMyAppointments(_ req: request, object: UUID) async throws -> status
   
}

struct AppointmentContext {
    let appointment: UUID
    let user: UUID
}
