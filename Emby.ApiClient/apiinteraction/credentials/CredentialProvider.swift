//
//  CredentialProvider.swift
//  Emby.ApiClient
//
//  Created by Vedran Ozir on 02/11/15.
//  Copyright © 2015 Vedran Ozir. All rights reserved.
//

import Foundation

/**
* Created by Luke on 4/5/2015.
*/
public class CredentialProvider: CredentialProviderProtocol { // ICredentialProvider {
    
    private let jsonSerializer: IJsonSerializer
    private let filePath: String
    
    public init( jsonSerializer: IJsonSerializer, filePath: String) {
        self.jsonSerializer = jsonSerializer
        self.filePath = filePath
    }
    
    public func getCredentials() -> ServerCredentials {
    
        if  let data = UserDefaults.standard.object(forKey: "Emby Server Credentials") as? NSData,
            let credentials = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as? ServerCredentials
        {
            return credentials
        }
        
        return ServerCredentials(connectAccessToken: "", connectUserId: "")
    }

    public func saveCredentials(credentials: ServerCredentials) {
        
        let data = NSKeyedArchiver.archivedData(withRootObject: credentials)
        UserDefaults.standard.set(data, forKey: "Emby Server Credentials")

    }
    
}
