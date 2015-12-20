//
//  PinStatusResult.swift
//  Emby.ApiClient
//
//  Created by Vedran Ozir on 08/10/15.
//  Copyright © 2015 Vedran Ozir. All rights reserved.
//

import Foundation

public struct PinStatusResult: JSONSerializable
{
    public let pin: String
    public let confirmed: Bool
    public let expired: Bool
    
    public init?(jSON: JSON_Object) {
        if  let pin = jSON["Pin"] as? String,
            let expired = jSON["IsExpired"] as? Bool,
            let confirmed = jSON["IsConfirmed"] as? Bool
        {
            self.pin = pin
            self.expired = expired
            self.confirmed = confirmed
        }
        else {
            return nil
        }
    }
}