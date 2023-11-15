//
//  Resource.swift
//
//
//  Created by Lidiane Gomes Barbosa on 30/10/23.
//

import Fluent
import Vapor

final class Resource: Model {
    static let schema = SchemaEnum.resources.rawValue
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: FieldKeys.type)
    var type: ResourceType.RawValue
    
    @OptionalField(key: FieldKeys.content)
    var content: String?
    
    @Timestamp(key: FieldKeys.createdAt, on: .create)
    var createdAt: Date?
    
    @Timestamp(key: FieldKeys.updatedAt, on: .update)
    var updatedAt: Date?

    init() { }

    init(type: ResourceType.RawValue, content: String?, createdAt: Date?, updatedAt: Date?) {
        self.type = type
        self.content = content
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    init(content: String?, updatedAt: Date?) {
        self.content = content
        self.updatedAt = updatedAt
    }
    
    final class Public: Content {
        var id: UUID?
        var type: ResourceType.RawValue?
        var content: String?
        var updatedAt: Date?
        
        init(id: UUID?, type: ResourceType.RawValue?, content: String?, updatedAt: Date?) {
            self.id = id
            self.type = type
            self.content = content
            self.updatedAt = updatedAt
        }
    }
}

extension Resource: Content { }

extension Resource {
    func convertToPublic() -> Resource.Public {
        return Resource.Public(id: id, type: type, content: content, updatedAt: updatedAt)
    }
}

extension Collection where Element: Resource {
    func convertToPublic() -> [Resource.Public] {
        return self.map { $0.convertToPublic() }
    }
}
