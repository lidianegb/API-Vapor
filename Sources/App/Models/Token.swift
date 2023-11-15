//
//  Token.swift
//  
//
//  Created by Lidiane Gomes Barbosa on 07/11/23.
//

import Foundation
import Fluent
import Vapor

final class Token: Model {
    static var schema = SchemaEnum.tokens.rawValue
    
    @ID
    var id: UUID?
    
    @Field(key: FieldKeys.value)
    var value: String
    
    @Parent(key: FieldKeys.userID)
    var userID: User
    
    init() { }
    
    init(id: UUID? = nil, value: String, userID: User.IDValue) {
        self.id = id
        self.value = value
        self.$userID.id = userID
    }
}
extension Token: Content { }

extension Token: ModelTokenAuthenticatable {
    typealias User = App.User
    
    static var valueKey: KeyPath<Token, Field<String>> {
        \Token.$value
    }
    
    static var userKey: KeyPath<Token, Parent<User>> {
        \Token.$userID
    }
    
    var isValid: Bool {
        true
    }
}

extension Token {
    static func generate(of user: User) throws -> Token {
        let random = [UInt8].random(count: 16).base64
        return try Token(value: random, userID: user.requireID())
    }
}
