//
//  UserDTO.swift
//
//
//  Created by Lidiane Gomes Barbosa on 06/11/23.
//

import Foundation
import Fluent
import Vapor

struct CreateUserDTO: Content {
    let name: String?
    let userName: String
    let password: String
    let registration: String?
    let role: RoleEnum.RawValue?
}

struct UpdateUserDTO: Content {
    let name: String?
    let userName: String?
    let registration: String?
    let password: String?
    let schedule: [Date]?
}
