//
//  ContainerProfile.swift
//  EmbyApiClient
//

import Foundation

public struct ContainerProfile {
    var type = DlnaProfileType.Audio
    var conditions = [ProfileCondition]()
    let container: String?
    var containers: [String] {
        get {
            return splitToArray(container, delimiter: ",")
        }
    }
}