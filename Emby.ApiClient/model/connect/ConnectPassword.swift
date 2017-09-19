//
//  ConnectPassword.swift
//  Emby.ApiClient
//
//  Created by Vedran Ozir on 07/10/15.
//  Copyright © 2015 Vedran Ozir. All rights reserved.
//

import Foundation

//package mediabrowser.model.connect;

extension String {
    
    func replace(what: String, with: String) -> String {
        //return self.stringByReplacingOccurrencesOfString(what, withString: with)
        return self.replacingOccurrences(of: what, with: with)
    }
}

public final class ConnectPassword
{
    public static func PerformPreHashFilter( password: String) -> String
    {
        return password.replace(what: "&", with: "&amp;").replace(what: "/", with: "&#092;").replace(what: "!", with: "&#33;").replace(what: "$", with: "&#036;").replace(what: "\"", with: "&quot;").replace(what: "<", with: "&lt;").replace(what: ">", with: "&gt;").replace(what: "'", with: "&#39;");
    }
    
}
