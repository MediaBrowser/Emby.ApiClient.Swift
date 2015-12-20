//
//  ConnectUserQuery.swift
//  Emby.ApiClient
//
//  Created by Vedran Ozir on 08/10/15.
//  Copyright © 2015 Vedran Ozir. All rights reserved.
//

import Foundation

public struct ConnectUserQuery: JSONSerializable
{
    public var id: String?
    public var name: String?
    public var email: String?
    public var nameOrEmail: String?
    
    public init() {
    }
    
    public init?(jSON: JSON_Object) {
        self.id = jSON["Id"] as? String
        self.name = jSON["Name"] as? String
        self.email = jSON["Email"] as? String
        self.nameOrEmail = jSON["NameOrEmail"] as? String
    }
}