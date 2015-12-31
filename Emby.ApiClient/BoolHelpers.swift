//
//  BoolHelpers.swift
//  EmbyApiClient
//

import Foundation

extension Bool {
    init(_ integer: Int){
        if integer > 1 || integer <= 0 {
            self.init(false)
        } else if integer == 1 {
            self.init(true)
        } else {
            self.init(false)
        }
    }
}