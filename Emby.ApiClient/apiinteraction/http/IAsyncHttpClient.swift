//
//  IAsyncHttpClient.swift
//  Emby.ApiClient
//
//  Created by Vedran Ozir on 07/10/15.
//  Copyright © 2015 Vedran Ozir. All rights reserved.
//

import Foundation

//package mediabrowser.apiinteraction.http;
//
//import mediabrowser.apiinteraction.Response;

protocol IAsyncHttpClient {
    
    public func Send(request: HttpRequest, response: Response<String>)
}