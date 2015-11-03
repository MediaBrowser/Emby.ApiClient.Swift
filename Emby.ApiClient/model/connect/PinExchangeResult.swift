//
//  PinExchangeResult.swift
//  Emby.ApiClient
//
//  Created by Vedran Ozir on 08/10/15.
//  Copyright © 2015 Vedran Ozir. All rights reserved.
//

import Foundation
//package mediabrowser.model.connect;

public class PinExchangeResult: GenericResult
{
    public required init(jSON: JSON_Object) {
        super.init(jSON: jSON)
        
        if let Id = jSON["Id"] as? String {
            self.UserId = Id
        }
        
        if let AccessToken = jSON["AccessToken"] as? String {
            self.AccessToken = AccessToken
        }
    }
    private var UserId: String?
    public final func getUserId() -> String?
    {
    return UserId;
    }
    public final func setUserId(value: String)
    {
    UserId = value;
    }
    private var AccessToken: String?
    public final func getAccessToken() -> String?
    {
    return AccessToken;
    }
    public final func setAccessToken(value: String)
    {
    AccessToken = value;
    }
}