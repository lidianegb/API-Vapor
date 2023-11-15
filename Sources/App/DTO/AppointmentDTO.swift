//
//  AppointmentDTO.swift
//
//
//  Created by Lidiane Gomes Barbosa on 06/11/23.
//

import Foundation
import Vapor
import Fluent

struct CreateAppointmentDTO: Content {
    let date: Date?
    let monitor: User.IDValue?
}

struct UpdateAppointmentDTO: Content {
    let date: Date?
    let monitor: User.IDValue?
    let monitorName: String?
    let status: StatusEnum.RawValue?
}
