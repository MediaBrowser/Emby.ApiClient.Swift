//
//  SubtitleProfile.swift
//  EmbyApiClient
//

import Foundation

public struct SubtitleProfile {
    let format: String?
    let method: SubtitleDeliveryMethod?
    let didlMode: String?
    let language: String?
    var languages: [String] {
        get {
            return splitToArray(language, delimiter: ",")
        }
    }
    
    public func supportsLanguage(subLanguage: String) -> Bool {
        return language == nil || languages.contains({ $0.lowercaseString == subLanguage.lowercaseString})
    }
}