//
//  CredentialProvider.swift
//  Emby.ApiClient
//
//  Created by Vedran Ozir on 02/11/15.
//  Copyright © 2015 Vedran Ozir. All rights reserved.
//

import Foundation

//package mediabrowser.apiinteraction.credentials;
//
//import mediabrowser.apiinteraction.ICredentialProvider;
//import mediabrowser.model.apiclient.ServerCredentials;
//import mediabrowser.model.logging.ILogger;
//import mediabrowser.model.serialization.IJsonSerializer;

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
    
//    @Override
//    public ServerCredentials GetCredentials() {
    public func getCredentials() -> ServerCredentials {
    
//        return (ServerCredentials)jsonSerializer.DeserializeFromFile(ServerCredentials.class, filePath);
        
        return ServerCredentials(connectAccessToken: "", connectUserId: "")
    }

//    @Override
//    public void SaveCredentials(ServerCredentials credentials) {
    public func saveCredentials(credentials: ServerCredentials) {
    
//        jsonSerializer.SerializeToFile(credentials, filePath);
    }
    
}