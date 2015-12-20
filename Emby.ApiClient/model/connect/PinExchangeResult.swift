//
//  PinExchangeResult.swift
//  Emby.ApiClient
//
//  Created by Vedran Ozir on 08/10/15.
//  Copyright © 2015 Vedran Ozir. All rights reserved.
//

import Foundation
//package mediabrowser.model.connect;

public struct PinExchangeResult: JSONSerializable
{
    
    public let userId: String
    public let accessToken: String
    
    public init?(jSON: JSON_Object) {
        
        if  let userId = jSON["UserId"] as? String,
            let accessToken = jSON["AccessToken"] as? String
        {
            self.userId = userId
            self.accessToken = accessToken
        }
        else {
            return nil
        }
    }
}