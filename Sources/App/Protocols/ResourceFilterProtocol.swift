//
//  ResourceFilterProtocol.swift
//
//
//  Created by Lidiane Gomes Barbosa on 08/11/23.
//

import Foundation
import Vapor
import Fluent

protocol ResourceFilterProtocol {
    associatedtype request
    associatedtype answer
    associatedtype model
    associatedtype status
    
    static func getByType(_ req: request, type: ResourceType.RawValue?) async throws -> [answer]
}

protocol ResourceFilterHandlerProtocol {
    associatedtype answer
    associatedtype request
    
    func getByType(_ req: request) async throws -> [answer]
}
