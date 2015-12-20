//
//  ConnectUser.swift
//  Emby.ApiClient
//
//  Created by Vedran Ozir on 08/10/15.
//  Copyright © 2015 Vedran Ozir. All rights reserved.
//

import Foundation

public struct ConnectUser: JSONSerializable
{
    public let id: String
    public let name: String
    public let email: String
    public let active: Bool
    public let imageUrl: String?
    
    public init?(jSON: JSON_Object) {
        //{"Id":"79718","Name":"vedrano","DisplayName":"vedrano","Email":"vedran.ozir@gmail.com","IsActive":"true","ImageUrl":"http:\/\/www.gravatar.com\/avatar\/1231d710dfba30dd91868a20f737e0db?s=200&d=http%3A%2F%2Fmb3admin.com%2Fimages%2Fuser.png"}
        
        if  let id = jSON["Id"] as? String,
            let name = jSON["Name"] as? String,
            let email = jSON["Email"] as? String,
            let activeString = jSON["IsActive"] as? NSString
        {
            self.id = id
            self.name = name
            self.email = email
            self.active = activeString.boolValue
            
            self.imageUrl = jSON["ImageUrl"] as? String
        }
        else {
            return nil
        }
    }
}