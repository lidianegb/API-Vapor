//
//  AuthController.swift
//  
//
//  Created by Lidiane Gomes Barbosa on 07/11/23.
//

import Foundation
import Vapor

struct AuthController: AuthProtocol {
    func loginHandler(_ req: Vapor.Request) throws -> EventLoopFuture<Token> {
        let user = try req.auth.require(User.self)
        let token = try Token.generate(of: user)
        return token.save(on: req.db).map {
            token
        }
    }

}
