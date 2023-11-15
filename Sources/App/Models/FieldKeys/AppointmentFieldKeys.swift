//
//  AppointmentFieldKeys.swift
//  
//
//  Created by Lidiane Gomes Barbosa on 03/11/23.
//

import Foundation
import Fluent
import Vapor

extension Appointment {
    struct FieldKeys {
        static var date: FieldKey { "data" }
        static var monitorName: FieldKey { "monitor_name" }
        static var monitorId: FieldKey { "monitor_id" }
        static var user: FieldKey { "usuario" }
        static var createdAt: FieldKey { "data_criacao"}
        static var updatedAt: FieldKey { "data_atualizacao"}
        static var status: FieldKey { "status" }
    }
}
