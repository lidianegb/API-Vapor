//
//  UserProtocol.swift
//
//
//  Created by Lidiane Gomes Barbosa on 06/11/23.
//

import Foundation
import Vapor
import Fluent

protocol UserProtocol {
    associatedtype model
    associatedtype answer
    associatedtype request
    associatedtype createDTO
    associatedtype updateDTO
    associatedtype status
    
    static func create(_ req: request, _ createDTO: createDTO) async throws -> model
    static func get(_ req: request, object: UUID?) async throws -> model
    static func getAll(_ req: request) async throws -> [answer]
    static func getMonitors(_ req: request) async throws -> [answer]
    static func update(_ req: request, object: UUID?, updateDTO: updateDTO)  async throws -> model
    static func updateSchedule(_ req: request, object: UUID?, updatedDTO: updateDTO) async throws -> model
    static func delete(_ req: request, object: UUID?) async throws -> status
}

protocol UserHandlerProtocol {
    associatedtype answer
    associatedtype request
    associatedtype status
    associatedtype model
    
    func create(_ req: request) async throws -> model
    func get(_ req: request) async throws -> model
    func getAll(_ req: request) async throws -> [answer]
    func getMonitors(_ req: request) async throws -> [answer]
    func update(_ req: request) async throws -> model
    func delete(_ req: request) async throws -> status
    func updateSchedule(_ req: request) async throws -> model
}
