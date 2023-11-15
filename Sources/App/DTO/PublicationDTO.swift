//
//  PublicationDTO.swift
//  
//
//  Created by Lidiane Gomes Barbosa on 07/11/23.
//

import Foundation
import Vapor
import Fluent

struct CreatePublicationDTO: Content {
    let title: String?
    let text: String?
    let videos: [String]?
    let images: [String]?
}

struct UpdatePublicationDTO: Content {
    let title: String?
    let text: String?
    let videos: [String]?
    let images: [String]?
}
