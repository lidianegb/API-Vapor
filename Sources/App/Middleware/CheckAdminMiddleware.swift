//
//  CheckAdminMiddleware.swift
//
//
//  Created by Lidiane Gomes Barbosa on 07/11/23.
//

import Foundation
import Vapor

struct CheckAdminMiddleware: AsyncMiddleware {
    func respond(to request: Vapor.Request, chainingTo next: Vapor.AsyncResponder) async throws -> Vapor.Response {
        guard let user = request.auth.get(User.self), user.role == RoleEnum.admin.rawValue else {
            throw Abort(.forbidden, reason: "Sory, you need admin rights to access these resource. Please contact an admin.")
        }
        return try await next.respond(to: request)
    }
}
