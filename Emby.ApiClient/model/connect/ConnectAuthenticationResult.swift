//
//  ConnectAuthenticationResult.swift
//  Emby.ApiClient
//
//  Created by Vedran Ozir on 07/10/15.
//  Copyright © 2015 Vedran Ozir. All rights reserved.
//

import Foundation

public struct ConnectAuthenticationResult: JSONSerializable
{
    public let user: ConnectUser
    public let accessToken: String
    
    public init?(jSON: JSON_Object) {
        if  let accessToken = jSON["AccessToken"] as? String,
            let userJSON = jSON["User"] as? JSON_Object,
            let user = ConnectUser(jSON: userJSON)
        {
            self.user = user
            self.accessToken = accessToken
        }
        else {
            return nil
        }
    }
}