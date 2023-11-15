//
//  PublicationController.swift
//
//
//  Created by Lidiane Gomes Barbosa on 31/10/23.
//

import Fluent
import Vapor

struct PublicationController: PublicationHandlerProtocol {
    typealias answer = Publication.Public
    typealias request = Request
    typealias status = HTTPStatus
    
    func create(_ req: Vapor.Request) async throws -> Publication.Public {
        let publication = try req.content.decode(CreatePublicationDTO.self)
        return try await PublicationService.create(req, publication)
    }
    
    func get(_ req: Vapor.Request) async throws -> Publication.Public {
        let id = req.parameters.get("id", as: UUID.self)
        return try await PublicationService.get(req, object: id)
    }
    
    func getAll(_ req: Vapor.Request) async throws -> [Publication.Public] {
        return try await PublicationService.getAll(req)
    }
    
    func update(_ req: Vapor.Request) async throws -> Publication.Public {
        let id = req.parameters.get("id", as: UUID.self)
        let updatedPublication = try req.content.decode(UpdatePublicationDTO.self)
        return try await PublicationService.update(req, object: id, updateDTO: updatedPublication)
    }
    
    func delete(_ req: Vapor.Request) async throws -> Vapor.HTTPStatus {
        let id = req.parameters.get("id", as: UUID.self)
        return try await PublicationService.delete(req, object: id)
    }
}

extension PublicationController: PublicationFilterHandlerProtocol {
    func search(_ req: Vapor.Request) async throws -> [Publication.Public] {
        let term = req.parameters.get("termo")
        return try await PublicationService.search(req, term: term ?? "")
    }
}
