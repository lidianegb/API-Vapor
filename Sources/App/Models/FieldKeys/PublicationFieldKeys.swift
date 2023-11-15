//
//  PublicationFieldKeys.swift
//  
//
//  Created by Lidiane Gomes Barbosa on 03/11/23.
//

import Foundation
import Vapor
import Fluent

extension Publication {
    struct FieldKeys {
        static var title: FieldKey { "titulo" }
        static var text: FieldKey { "texto" }
        static var videos: FieldKey { "videos" }
        static var images: FieldKey { "imagens" }
        static var createdAt: FieldKey { "data_criacao" }
        static var updatedAt: FieldKey { "data_atualizao" }
    }
}
