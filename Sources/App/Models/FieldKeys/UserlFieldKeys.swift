//
//  UserFieldKeys.swift
//
//
//  Created by Lidiane Gomes Barbosa on 02/11/23.
//

import Foundation
import Fluent

extension User {
    struct FieldKeys {
        static var name: FieldKey { "nome" }
        static var userName: FieldKey { "usuario" }
        static var registration: FieldKey { "matricula" }
        static var password: FieldKey { "senha" }
        static var appointments: FieldKey { "agendamentos" }
        static var schedule: FieldKey { "agenda" }
        static var role: FieldKey { "tipo_usuario" }
        static var createdAt: FieldKey { "data_criacao" }
        static var updatedAt: FieldKey { "data_atualizacao" }
    }
}
