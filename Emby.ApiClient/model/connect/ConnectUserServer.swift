//
//  ConnectUserServer.swift
//  Emby.ApiClient
//
//  Created by Vedran Ozir on 08/10/15.
//  Copyright © 2015 Vedran Ozir. All rights reserved.
//

import Foundation

public struct ConnectUserServer: JSONSerializable
{
    public let id: String
    public let url: String
    public let name: String
    public let accessKey: String
    public let systemId: String
    public let localAddress: String
    public let userType: String
    public let supporterKey: String?
    
    
    public init?(jSON: JSON_Object) {
        if  let id = jSON["Id"] as? String,
            let url = jSON["Url"] as? String,
            let name = jSON["Name"] as? String,
            let systemId = jSON["SystemId"] as? String,
            let accessKey = jSON["AccessKey"] as? String,
            let localAddress = jSON["LocalAddress"] as? String,
            let userType = jSON["UserType"] as? String
        {
            self.id = id
            self.url = url
            self.name = name
            self.accessKey = accessKey
            self.systemId = systemId
            self.localAddress = localAddress
            self.userType = userType
            
            self.supporterKey = jSON["SupporterKey"] as? String
        }
        else {
            return nil
        }
    }
}