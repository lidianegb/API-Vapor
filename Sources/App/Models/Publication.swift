//
//  Publication.swift
//
//
//  Created by Lidiane Gomes Barbosa on 31/10/23.
//

import Vapor
import Fluent

final class Publication: Model {
    static let schema: String = SchemaEnum.publication.rawValue
    
    @ID(key: .id)
    var id: UUID?
    
    @OptionalField(key: FieldKeys.title)
    var title: String?
    
    @OptionalField(key: FieldKeys.text)
    var text: String?
    
    @OptionalField(key: FieldKeys.videos)
    var videos: [String]?
    
    @OptionalField(key: FieldKeys.images)
    var images: [String]?
    
    @Timestamp(key: FieldKeys.createdAt, on: .create)
    var createdAt: Date?
    
    @Timestamp(key: FieldKeys.updatedAt, on: .update)
    var updatedAt: Date?
    
    init() { }
    
    init(title: String?, text: String?, videos: [String]?, images: [String]?, createdAt: Date?, updatedAt: Date?) {
        self.title = title
        self.text = text
        self.videos = videos
        self.images = images
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    init(title: String?, text: String?, videos: [String]?, images: [String]?, updatedAt: Date?) {
        self.title = title
        self.text = text
        self.videos = videos
        self.images = images
        self.updatedAt = updatedAt
    }
    
    final class Public: Content {
        let id: UUID?
        let title: String?
        let text: String?
        let videos: [String]?
        let images: [String]?
        let updatedAt: Date?
        
        init(id: UUID?, title: String?, text: String?, videos: [String]?, images: [String]?, updatedAt: Date?) {
            self.id = id
            self.title = title
            self.text = text
            self.videos = videos
            self.images = images
            self.updatedAt = updatedAt
        }
    }
}

extension Publication: Content { }

extension Publication {
    func convertToPublic() -> Publication.Public {
        return Publication.Public(id: id, title: title, text: text, videos: videos, images: images, updatedAt: updatedAt)
    }
}

extension Collection where Element: Publication {
    func convertToPublic() -> [Publication.Public] {
        return self.map { $0.convertToPublic() }
    }
}
