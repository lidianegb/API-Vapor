//
//  AppointmentFilterProtocol.swift
//
//
//  Created by Lidiane Gomes Barbosa on 06/11/23.
//

import Foundation
import Vapor
import Fluent

protocol BackendAppointmentFilterProtocol {
    associatedtype request
    associatedtype answer
    associatedtype model
    associatedtype status
    
    static func getByStatus(_ req: request, status: StatusEnum.RawValue?, user: User) async throws -> [answer]
}

protocol AppointmentFilterHandlerProtocol {
    associatedtype answer
    associatedtype request
    
    func getByStatus(_ req: request) async throws -> [answer]
}
