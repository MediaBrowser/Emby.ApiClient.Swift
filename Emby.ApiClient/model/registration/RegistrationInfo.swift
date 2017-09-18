//
//  RegistrationInfo.swift
//  Emby.ApiClient
//
//  Created by Vedran Ozir on 09/10/15.
//  Copyright © 2015 Vedran Ozir. All rights reserved.
//

import Foundation

public struct RegistrationInfo: JSONSerializable
{
    let name: String
    let expirationDate: NSDate
    let trial: Bool
    let registered: Bool
    
    public init?(jSON: JSON_Object) {
 
        //{"Name":"TV","ExpirationDate":"2015-11-15","IsTrial":true,"IsRegistered":false}

        if  let name = jSON["Name"] as? String,
            let expirationString = jSON["ExpirationDate"] as? String,
            let trial = jSON["IsTrial"] as? Bool,
            let registered = jSON["IsRegistered"] as? Bool
        {
            self.name = name
            self.trial = trial
            self.registered = registered
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            self.expirationDate = formatter.date(from: expirationString)! as NSDate
        }
        else {
            return nil
        }
    }
}
