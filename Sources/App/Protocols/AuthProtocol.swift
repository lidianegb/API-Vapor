//
//  AuthProtocol.swift
//
//
//  Created by Lidiane Gomes Barbosa on 06/11/23.
//

import Foundation
import Fluent
import Vapor

protocol AuthProtocol {
    func loginHandler(_ req: Request) throws -> EventLoopFuture<Token>
}
