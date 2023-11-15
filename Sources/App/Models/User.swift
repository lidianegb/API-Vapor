//
//  User.swift
//  
//
//  Created by Lidiane Gomes Barbosa on 30/10/23.
//

import Fluent
import Vapor

final class User: Model {
    static let schema = SchemaEnum.users.rawValue
    
    @ID(key: .id)
    var id: UUID?

    @OptionalField(key: FieldKeys.name)
    var name: String?
    
    @Field(key: FieldKeys.userName)
    var userName: String
    
    @OptionalField(key: FieldKeys.registration)
    var registration: String?
    
    @Field(key: FieldKeys.password)
    var password: String
    
    @OptionalField(key: FieldKeys.schedule)
    var schedule: [Date]?
    
    @OptionalField(key: FieldKeys.appointments)
    var appointments: [UUID]?
    
    @Field(key: FieldKeys.role)
    var role: RoleEnum.RawValue
    
    @Timestamp(key: FieldKeys.createdAt, on: .create)
    var createdAt: Date?
    
    @Timestamp(key: FieldKeys.updatedAt, on: .update)
    var updatedAt: Date?

    init() { }

    // create a new user
    init(name: String?, userName: String, registration: String?, password: String, role: RoleEnum.RawValue, createdAt: Date?, updatedAt: Date?) {
        self.name = name
        self.userName = userName
        self.registration = registration
        self.password = password
        self.role = role
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    // update a user
    init(name: String?, userName: String, password: String, registration: String?, updatedAt: Date?) {
        self.name = name
        self.userName = userName
        self.password = password
        self.registration = registration
        self.updatedAt = updatedAt
    }
    
    // update schedule
    init(schedule: [Date]?) {
        self.schedule = schedule
    }
    
    // create appointments
    init(appointments: [UUID]?) {
        self.appointments = appointments
    }
    
    // update role
    init(role: RoleEnum.RawValue) {
        self.role = role
    }
    
    final class Public: Content {
        var id: UUID?
        var name: String?
        var registration: String?
        
        init(id: UUID?,name: String?, registration: String?) {
            self.id = id
            self.name = name
            self.registration = registration
        }
    }
}

extension User: Content { }

extension User {
    func convertToPublic() -> User.Public {
        return User.Public(id: id, name: name, registration: registration)
    }
}

extension Collection where Element: User {
    func convertToPublic() -> [User.Public] {
        return self.map { $0.convertToPublic() } 
    }
}

extension User: Authenticatable { }
extension User: ModelAuthenticatable {
    static var usernameKey: KeyPath<User, Field<String>> {
        \User.$userName
    }
    
    static var passwordHashKey: KeyPath<User, Field<String>> {
        \User.$password
    }
    
    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.password)
    }
}

extension User: ModelSessionAuthenticatable { }
extension User: ModelCredentialsAuthenticatable { }
