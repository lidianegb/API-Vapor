//
//  ResourceFieldKeys.swift
//  
//
//  Created by Lidiane Gomes Barbosa on 03/11/23.
//

import Foundation
import Vapor
import Fluent

extension Resource {
    struct FieldKeys {
        static var type: FieldKey { "tipo" }
        static var content: FieldKey { "conteudo" }
        static var createdAt: FieldKey { "data_criacao" }
        static var updatedAt: FieldKey { "data_atualizacao" }
    }
}
