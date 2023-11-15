//
//  ResourceController.swift
//  
//
//  Created by Lidiane Gomes Barbosa on 30/10/23.
//

import Fluent
import Vapor

struct ResourceController: ResourceHandlerProtocol {
    typealias answer = Resource.Public
    typealias request = Request
    typealias status = HTTPStatus
    
    func create(_ req: Vapor.Request) async throws -> Resource.Public {
        let resource = try req.content.decode(CreateResourceDTO.self)
        return try await ResourceService.create(req, resource)
    }
    
    func get(_ req: Vapor.Request) async throws -> Resource.Public {
        let id = req.parameters.get("id", as: UUID.self)
        return try await ResourceService.get(req, object: id)
    }
    
    func getAll(_ req: Vapor.Request) async throws -> [Resource.Public] {
        return try await ResourceService.getAll(req)
    }
    
    func update(_ req: Vapor.Request) async throws -> Resource.Public {
        let id = req.parameters.get("id", as: UUID.self)
        let updatedResource = try req.content.decode(UpdateResourceDTO.self)
        return try await ResourceService.update(req, object: id, updateDTO: updatedResource)
    }
    
    func delete(_ req: Vapor.Request) async throws -> Vapor.HTTPStatus {
        let id = req.parameters.get("id", as: UUID.self)
        return try await ResourceService.delete(req, object: id)
    }
}

extension ResourceController: ResourceFilterHandlerProtocol {
    func getByType(_ req: Vapor.Request) async throws -> [Resource.Public] {
        let type = req.parameters.get("tipo")
        return try await ResourceService.getByType(req, type: type)
    }
}
