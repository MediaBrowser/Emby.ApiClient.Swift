//
//  AccessSchedule.swift
//  Emby.ApiClient
//

import Foundation

public struct AccessSchedule {
    var dayOfWeek = DynamicDayOfWeek.Sunday
    var startHour: Int?
    var endHour: Int?
}