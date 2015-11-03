//
//  ICredentialProvider.swift
//  Emby.ApiClient
//
//  Created by Vedran Ozir on 02/11/15.
//  Copyright © 2015 Vedran Ozir. All rights reserved.
//

import Foundation

//package mediabrowser.apiinteraction;
//
//import mediabrowser.model.apiclient.ServerCredentials;

public protocol ICredentialProvider {
    
    func GetCredentials() -> ServerCredentials
    
    func SaveCredentials(credentials: ServerCredentials)
}