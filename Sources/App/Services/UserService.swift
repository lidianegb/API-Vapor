//
//  UserService.swift
//
//
//  Created by Lidiane Gomes Barbosa on 06/11/23.
//

import Foundation
import Fluent
import Vapor

struct UserService: UserProtocol {
    typealias model = User
    typealias answer = User.Public
    typealias request = Request
    typealias createDTO = CreateUserDTO
    typealias updateDTO = UpdateUserDTO
    typealias status = HTTPStatus
    
    static func create(_ req: Vapor.Request, _ createDTO: CreateUserDTO) async throws -> User {
        let user = User(
            name: createDTO.name,
            userName: createDTO.userName,
            registration: createDTO.registration,
            password: try Bcrypt.hash(createDTO.password),
            role: createDTO.role ?? RoleEnum.registered.rawValue,
            createdAt: Date(),
            updatedAt: Date()
        )
        try await user.save(on: req.db)
        return user
    }
    
    static func get(_ req: Vapor.Request, object: UUID?) async throws -> User {
        guard let user = try await User.find(object, on: req.db) else {
            throw Abort(.notFound, reason: "The user with ID of \(String(describing: object)) could not be found!")
        }
        return user
    }
    
    static func getMonitors(_ req: Request) async throws -> [User.Public] {
        return try await User.query(on: req.db)
            .filter(\.$role == RoleEnum.admin.rawValue)
            .all()
            .map { $0.convertToPublic() }
    }
    
    static func getAll(_ req: Vapor.Request) async throws -> [User.Public] {
        return try await User.query(on: req.db)
            .filter(\.$role == RoleEnum.registered.rawValue)
            .all()
            .map { $0.convertToPublic() }
    }
    
    static func update(_ req: Vapor.Request, object: UUID?, updateDTO: UpdateUserDTO) async throws -> User {
        guard let user = try await User.find(object, on: req.db) else {
            throw Abort(.notFound, reason: "The user with ID of \(String(describing: object)) could not be found!")
        }
        user.name = updateDTO.name ?? user.name
        user.userName = updateDTO.userName ?? user.userName
        user.registration = updateDTO.registration ?? user.registration
        user.password = updateDTO.password ?? user.password
        user.updatedAt = Date()
        
        try await user.save(on: req.db)
        return user
    }
    
    static func updateSchedule(_ req: Request, object: UUID?, updatedDTO: UpdateUserDTO) async throws -> User {
        guard let user = try await User.find(object, on: req.db) else {
            throw Abort(.notFound, reason: "The user with ID of \(String(describing: object)) could not be found!")
        }
        user.schedule = updatedDTO.schedule
        user.updatedAt = Date()
        
        try await user.save(on: req.db)
        return user
    }
    
    static func delete(_ req: Vapor.Request, object: UUID?) async throws -> Vapor.HTTPStatus {
        guard let user = try await User.find(object, on: req.db) else {
            throw Abort(.notFound, reason: "The user with ID of \(String(describing: object)) could not be found!")
        }
        
        try await user.delete(on: req.db)
        return .ok
    }
    
    static func getMonitorSchedule(_ req: Request, object: UUID?) async throws -> [Date] {
        guard let user = try await User.find(object, on: req.db) else {
            throw Abort(.notFound, reason: "The monitor with ID of \(String(describing: object)) could not be found!")
        }
        
        return user.schedule?.map { $0 } ?? []
    }
}

extension UserService: SearchUserProtocol {
    static func search(_ req: Vapor.Request, term: String) async throws -> [User.Public] {
        return try await User.query(on: req.db)
            .group(.or) { or in
                or.filter(\.$name =~ term)
                or.filter(\.$userName =~ term)
                or.filter(\.$registration =~ term)
            }.all().convertToPublic()
    }
}
