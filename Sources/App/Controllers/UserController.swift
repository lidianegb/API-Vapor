//
//  UserController.swift
//
//
//  Created by Lidiane Gomes Barbosa on 30/10/23.
//

import Fluent
import Vapor

struct UserController: UserHandlerProtocol {
    typealias answer = User.Public
    typealias request = Request
    typealias status = HTTPStatus
    
    func create(_ req: Vapor.Request) async throws -> User {
        let user = try req.content.decode(CreateUserDTO.self)
        return try await UserService.create(req, user)
    }
    
    func get(_ req: Vapor.Request) async throws -> User {
        let user = try req.auth.require(User.self)
        return try await UserService.get(req, object: user.id)
    }
    
    func getAll(_ req: Vapor.Request) async throws -> [User.Public] {
        return try await UserService.getAll(req)
    }
    
    func getMonitors(_ req: Request) async throws -> [User.Public] {
        return try await UserService.getMonitors(req)
    }
    
    func update(_ req: Vapor.Request) async throws -> User {
        let user = try req.auth.require(User.self)
        let updatedUser = try req.content.decode(UpdateUserDTO.self)
        return try await UserService.update(req, object: user.id, updateDTO: updatedUser)
    }
    
    func updateSchedule(_ req: Request) async throws -> User {
        let user = try req.auth.require(User.self)
        let updatedUser = try req.content.decode(UpdateUserDTO.self)
        return try await UserService.updateSchedule(req, object: user.id, updatedDTO: updatedUser)
    }
    
    func delete(_ req: Vapor.Request) async throws -> Vapor.HTTPStatus {
        let userId = req.parameters.get("id", as: UUID.self)
        return try await UserService.delete(req, object: userId)
    }
}

extension UserController: SearchUserHandlerProtocol {
    func search(_ req: Vapor.Request) async throws -> [User.Public] {
        let term = req.parameters.get("termo")
        return try await UserService.search(req, term: term ?? "")
    }
}
