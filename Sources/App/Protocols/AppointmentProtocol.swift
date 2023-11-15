//
//  AppointmentProtocol.swift
//
//
//  Created by Lidiane Gomes Barbosa on 06/11/23.
//

import Foundation
import Fluent
import Vapor

protocol AppointmentProtocol {
    associatedtype answer
    associatedtype request
    associatedtype model
    associatedtype status
    associatedtype createDTO
    associatedtype updateDTO
    
    static func create(_ req: request, _ createDTO: createDTO, user: User) async throws -> answer
    static func get(_ req: request, object: UUID?) async throws -> answer
    static func getAll(_ req: request, user: User) async throws -> [answer]
    static func update(_ req: request, object: UUID?, updateDTO: updateDTO ) async throws -> answer
    static func delete(_ req: request, object: UUID?) async throws -> status
}

protocol AppointmentHandlerProtocol {
    associatedtype answer
    associatedtype request
    associatedtype status
    
    func create(_ req: request) async throws -> answer
    func get(_ req: request) async throws -> answer
    func getAll(_ req: request) async throws -> [answer]
    func update(_ req: request) async throws -> answer
    func delete(_ req: request) async throws -> status
}
