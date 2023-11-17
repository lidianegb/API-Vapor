//
//  RoutesEnum.swift
//
//
//  Created by Lidiane Gomes Barbosa on 08/11/23.
//

import Foundation

enum RoutesEnum: String {
    case login
    case register = "cadastrar"
    case profile = "perfil"
    case update = "atualizar"
    case delete = "remover"
    case monitors = "monitores"
    case users = "usuarios"
    case list = "listar"
    case filter = "filtrar"
    case schedule = "agenda"
    case upload
    
    case appointments = "agendamentos"
    case publications = "publicacoes"
    case resources = "recursos"
    case search = "buscar"
}
