//
//  PinCreationResult.swift
//  Emby.ApiClient
//
//  Created by Vedran Ozir on 08/10/15.
//  Copyright © 2015 Vedran Ozir. All rights reserved.
//

import Foundation
//package mediabrowser.model.connect;

public struct PinCreationResult: JSONSerializable
{
    public var pin: String?
    public var deviceId: String?
    public var expired: Bool?
    public var confirmed: Bool?
    
    public init() {
        
    }
    
    public init?(jSON: JSON_Object) {
        
        //{"Id":null,"Pin":"09751","DeviceId":"203AD7FD-333B-4926-A2EF-414748DF8FCF","IsExpired":false,"IsConfirmed":false,"AccessToken":null}
        
        //{"Id":"465875","Pin":"09751","DeviceId":"203AD7FD-333B-4926-A2EF-414748DF8FCF","IsExpired":false,"IsConfirmed":true,"AccessToken":"dd8a4f34dc2ed55765c21b217134f509"}
        
        self.deviceId = jSON["DeviceId"] as? String
        self.pin = jSON["Pin"] as? String
        self.expired = jSON["IsExpired"] as? Bool
        self.confirmed = jSON["IsConfirmed"] as? Bool
    }
}