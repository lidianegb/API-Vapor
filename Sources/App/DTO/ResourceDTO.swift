//
//  ResourceDTO.swift
//  
//
//  Created by Lidiane Gomes Barbosa on 07/11/23.
//

import Foundation
import Vapor
import Fluent

struct CreateResourceDTO: Content {
    let type: ResourceType.RawValue
    let content: String?
}

struct UpdateResourceDTO: Content {
    let type: ResourceType.RawValue?
    let content: String?
}
