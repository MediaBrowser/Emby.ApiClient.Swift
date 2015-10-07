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
        return self.stringByReplacingOccurrencesOfString(what, withString: with)
    }
}

public final class ConnectPassword
{
    public static func PerformPreHashFilter( password: String) -> String
    {
        return password.replace("&", with: "&amp;").replace("/", with: "&#092;").replace("!", with: "&#33;").replace("$", with: "&#036;").replace("\"", with: "&quot;").replace("<", with: "&lt;").replace(">", with: "&gt;").replace("'", with: "&#39;");
    }
    
}