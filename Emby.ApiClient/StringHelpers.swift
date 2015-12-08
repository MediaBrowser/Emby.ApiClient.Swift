//
//  StringHelpers.swift
//  EmbyApiClient
//

import Foundation

internal func splitToArray(stringToSplit: String?, delimiter: Character) -> [String] {
    if let toBeSplit = stringToSplit {
        return toBeSplit.characters.split(isSeparator: { $0 == delimiter }).map(String.init).filter({!$0.isEmpty})
    } else {
        return [String]()
    }
}