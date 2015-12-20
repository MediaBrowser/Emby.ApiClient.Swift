//
//  ConnectAuthenticationExchangeResult.swift
//  EmbyApiClient
//
//  Created by Kevin Sullivan on 12/14/15.
//
//

import Foundation

public struct ConnectAuthenticationExchangeResult: JSONSerializable
{
    public let localUserId: String
    public let accessToken: String
    
    public init?(jSON: JSON_Object) {
        if  let localUserId = jSON["LocalUserId"] as? String,
            let accessToken = jSON["AccessToken"] as? String
        {
            self.localUserId = localUserId
            self.accessToken = accessToken
        }
        else {
            return nil
        }
    }
}