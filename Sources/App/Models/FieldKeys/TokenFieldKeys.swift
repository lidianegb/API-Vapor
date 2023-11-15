//
//  TokenFieldKeys.swift
//  
//
//  Created by Lidiane Gomes Barbosa on 07/11/23.
//

import Foundation
import Vapor
import Fluent

extension Token {
    struct FieldKeys {
        static var value: FieldKey { "value" }
        static var userID: FieldKey { "userID" }
    }
}
