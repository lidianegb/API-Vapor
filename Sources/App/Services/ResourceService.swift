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
        var contentURL: String = ""
        if let file = createDTO.content {
            try await req.fileio
                .writeFile(file.data, at: file.filename)
            
            let serverConfig = req.application.http.server.configuration
            let hostname = serverConfig.hostname
            let port = serverConfig.port
            contentURL = "\(hostname):\(port)/\(file.filename)"
        }
        
        let resource = Resource(
            type: createDTO.type,
            content: contentURL,
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
        var contentURL = resource.content
        if let file = updateDTO.content {
            try await req.fileio
                .writeFile(file.data, at: file.filename)
            
            let serverConfig = req.application.http.server.configuration
            let hostname = serverConfig.hostname
            let port = serverConfig.port
            contentURL = "\(hostname):\(port)/\(file.filename)"
        }
        resource.type = updateDTO.type ?? resource.type
        resource.content = contentURL
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
