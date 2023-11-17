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
    let videos: [File]?
    let images: [File]?
}

struct UpdatePublicationDTO: Content {
    let title: String?
    let text: String?
    let videos: [File]?
    let images: [File]?
}
