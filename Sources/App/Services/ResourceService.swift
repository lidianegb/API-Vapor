//
//  ResourceService.swift
//  
//
//  Created by Lidiane Gomes Barbosa on 06/11/23.
//

import Foundation
import Fluent
import Vapor

struct ResourceService: ResourceProtocol {
   
    typealias answer = Resource.Public
    typealias request = Request
    typealias model = Resource
    typealias status = HTTPStatus
    typealias createDTO = CreateResourceDTO
    typealias updateDTO = UpdateResourceDTO
    
    static func create(_ req: Vapor.Request, _ createDTO: CreateResourceDTO) async throws -> Resource.Public {
        let resource = Resource(
            type: createDTO.type,
            content: createDTO.content,
            createdAt: Date(),
            updatedAt: Date()
        )
        try await resource.save(on: req.db)
        return resource.convertToPublic()
    }
    
    static func get(_ req: Vapor.Request, object: UUID?) async throws -> Resource.Public {
        guard let resource = try await Resource.find(object, on: req.db) else {
            throw Abort(.notFound, reason: "The resource with ID of \(String(describing: object)) could not be found!")
        }
        return resource.convertToPublic()
    }
    
    static func getAll(_ req: Vapor.Request) async throws -> [Resource.Public] {
        return try await Resource.query(on: req.db)
            .all()
            .map { $0.convertToPublic() }
    }
    
    static func update(_ req: Vapor.Request, object: UUID?, updateDTO: UpdateResourceDTO) async throws -> Resource.Public {
        guard let resource = try await Resource.find(object, on: req.db) else {
            throw Abort(.notFound, reason: "The resource with ID of \(String(describing: object)) could not be found!")
        }
        resource.type = updateDTO.type ?? resource.type
        resource.content = updateDTO.content ?? resource.content
        resource.updatedAt = Date()
        
        try await resource.save(on: req.db)
        return resource.convertToPublic()
    }
    
    static func delete(_ req: Vapor.Request, object: UUID?) async throws -> Vapor.HTTPStatus {
        guard let resource = try await Resource.find(object, on: req.db) else {
            throw Abort(.notFound, reason: "The resource with ID of \(String(describing: object)) could not be found!")
        }
        try await resource.delete(on: req.db)
        return .ok
    }
}

extension ResourceService: ResourceFilterProtocol {
    static func getByType(_ req: Vapor.Request, type: ResourceType.RawValue?) async throws -> [Resource.Public] {
        let resources = try await Resource.query(on: req.db)
            .filter(\.$type == type ?? "").all()
        return resources.convertToPublic()
    }
}
