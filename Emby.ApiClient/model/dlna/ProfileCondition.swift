//
//  ProfileCondition.swift
//  EmbyApiClient
//

import Foundation

public struct ProfileCondition {
    var condition = ProfileConditionType.Equals
    var property = ProfileConditionValue.AudioChannels
    let value: String
    var isRequired = true
    
    init(condition: ProfileConditionType, property: ProfileConditionValue, value: String) {
        self.init(condition: condition, property: property, value: value, isRequired: false)
    }
    
    init(condition: ProfileConditionType, property: ProfileConditionValue, value: String, isRequired: Bool) {
        self.condition = condition
        self.property = property
        self.value = value
        self.isRequired = isRequired
    }
}