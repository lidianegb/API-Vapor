//
//  File.swift
//  
//
//  Created by Lidiane Gomes Barbosa on 08/11/23.
//

import Foundation
import Vapor

protocol SearchUserProtocol {
    static func search(_ req: Request, term: String) async throws -> [User.Public]
}

protocol SearchUserHandlerProtocol {
    associatedtype answer
    associatedtype request
    
    func search(_ req: request) async throws -> [answer]
}
