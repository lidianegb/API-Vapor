//
//  PublicationFilterProtocol.swift
//
//
//  Created by Lidiane Gomes Barbosa on 08/11/23.
//

import Foundation
import Vapor
import Fluent

protocol PublicationFilterProtocol {
    associatedtype request
    associatedtype answer
    associatedtype model
    associatedtype status
    
    static func search(_ req: request, term: String) async throws -> [answer]
}

protocol PublicationFilterHandlerProtocol {
    associatedtype answer
    associatedtype request
    
    func search(_ req: request) async throws -> [answer]
}
