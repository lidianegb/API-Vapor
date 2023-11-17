//
//  PublicationService.swift
//  
//
//  Created by Lidiane Gomes Barbosa on 06/11/23.
//

import Foundation
import Vapor
import Fluent

struct PublicationService: PublicationProtocol {
    
    typealias model = Publication
    typealias answer = Publication.Public
    typealias request = Request
    typealias createDTO = CreatePublicationDTO
    typealias updateDTO = UpdatePublicationDTO
    typealias status = HTTPStatus
    
    static func create(_ req: Vapor.Request, _ createDTO: CreatePublicationDTO) async throws -> Publication.Public {
        var resultImages: [String] = []
        var resultVideos: [String] = []
        if let images = createDTO.images, let videos = createDTO.videos {
            let serverConfig = req.application.http.server.configuration
            let hostname = serverConfig.hostname
            let port = serverConfig.port
             _ = images.map { file in
                _ = req.fileio.writeFile(file.data, at: file.filename)
                 resultImages.append("\(hostname):\(port)/\(file.filename)")
            }
            _ = videos.map { file  in
               _ = req.fileio.writeFile(file.data, at: file.filename)
               resultVideos.append("\(hostname):\(port)/\(file.filename)")
           }
        }
        
        let publication = Publication(
            title: createDTO.title,
            text: createDTO.text,
            videos: resultVideos,
            images: resultImages,
            createdAt: Date(),
            updatedAt: Date()
        )
        try await publication.save(on: req.db)
        return publication.convertToPublic()
    }
    
    static func get(_ req: Vapor.Request, object: UUID?) async throws -> Publication.Public {
        guard let publication = try await Publication.find(object, on: req.db) else {
            throw Abort(.notFound, reason: "The publication with ID of \(String(describing: object)) could not be found!")
        }
        return publication.convertToPublic()
    }
    
    static func getAll(_ req: Vapor.Request) async throws -> [Publication.Public] {
        return try await Publication.query(on: req.db)
            .all()
            .map { $0.convertToPublic() }
    }
    
    static func update(_ req: Vapor.Request, object: UUID?, updateDTO: UpdatePublicationDTO) async throws -> Publication.Public {
        guard let publication = try await Publication.find(object, on: req.db) else {
            throw Abort(.notFound, reason: "The publication with ID of \(String(describing: object)) could not be found!")
        }
        
        var resultImages: [String] = publication.images ?? []
        var resultVideos: [String] = publication.videos ?? []
        if let images = updateDTO.images, let videos = updateDTO.videos {
            let serverConfig = req.application.http.server.configuration
            let hostname = serverConfig.hostname
            let port = serverConfig.port
             _ = images.map { file in
                _ = req.fileio.writeFile(file.data, at: file.filename)
                 resultImages.append("\(hostname):\(port)/\(file.filename)")
            }
            
            _ = videos.map { file in
               _ = req.fileio.writeFile(file.data, at: file.filename)
                resultVideos.append("\(hostname):\(port)/\(file.filename)")
           }
        }
    
        publication.title = updateDTO.title ?? publication.title
        publication.text = updateDTO.text ?? publication.text
        publication.images = resultImages
        publication.videos = resultVideos
        publication.updatedAt = Date()
        
        try await publication.save(on: req.db)
        return publication.convertToPublic()
    }
    
    static func delete(_ req: Vapor.Request, object: UUID?) async throws -> Vapor.HTTPStatus {
        guard let publication = try await Publication.find(object, on: req.db) else {
            throw Abort(.notFound, reason: "The publication with ID of \(String(describing: object)) could not be found!")
        }
        try await publication.delete(on: req.db)
        return .ok
    }
    
}

extension PublicationService: PublicationFilterProtocol {
    static func search(_ req: Vapor.Request, term: String) async throws -> [Publication.Public] {
        return try await Publication.query(on: req.db)
            .group(.or) { or in
                or.filter(\.$title =~ term)
                or.filter(\.$text =~ term)
            }.all().convertToPublic()
    }
}
