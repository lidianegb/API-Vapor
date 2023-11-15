//
//  ResourceProtocol.swift
//  
//
//  Created by Lidiane Gomes Barbosa on 07/11/23.
//

import Foundation
import Fluent
import Vapor

protocol ResourceProtocol {
    associatedtype answer
    associatedtype request
    associatedtype model
    associatedtype status
    associatedtype createDTO
    associatedtype updateDTO
    
    static func create(_ req: request, _ createDTO: createDTO) async throws -> answer
    static func get(_ req: request, object: UUID?) async throws -> answer
    static func getAll(_ req: request) async throws -> [answer]
    static func update(_ req: request, object: UUID?, updateDTO: updateDTO ) async throws -> answer
    static func delete(_ req: request, object: UUID?) async throws -> status
}

protocol ResourceHandlerProtocol {
    associatedtype answer
    associatedtype request
    associatedtype status
    
    func create(_ req: request) async throws -> answer
    func get(_ req: request) async throws -> answer
    func getAll(_ req: request) async throws -> [answer]
    func update(_ req: request) async throws -> answer
    func delete(_ req: request) async throws -> status
}
