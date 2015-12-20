//
//  ConnectService.swift
//  Emby.ApiClient
//
//  Created by Vedran Ozir on 07/10/15.
//  Copyright © 2015 Vedran Ozir. All rights reserved.
//

import Foundation

enum Error:ErrorType {
    case IllegalArgumentException(String)
    case LowBridge
}

public class ConnectService {
    
    public let JsonSerializer: IJsonSerializer
    let logger: ILogger
    let httpClient: IAsyncHttpClient
    private let appName: String
    private let appVersion: String
    
    public init(jsonSerializer: IJsonSerializer, logger: ILogger, httpClient: IAsyncHttpClient, appName: String, appVersion: String) {
        self.JsonSerializer = jsonSerializer
        self.logger = logger
        self.httpClient = httpClient
        self.appName = appName
        self.appVersion = appVersion
    }
    
    public func Authenticate(username: String, password: String, success: (ConnectAuthenticationResult) -> Void, failure: (EmbyError) -> Void) {
        // UnsupportedEncodingException, NoSuchAlgorithmException {
        
        let args = QueryStringDictionary()
        
        args.Add("nameOrEmail", value: username)
        args.Add("password", value: ConnectPassword.PerformPreHashFilter(password).md5())
        
        let url = GetConnectUrl("user/authenticate")
        
        let request = HttpRequest(url: url, method: .POST, postData: args)

        AddXApplicationName(request)
        
        httpClient.sendRequest(request, success: success, failure: failure)
    }
    
    public func CreatePin(deviceId: String, success: (PinCreationResult) -> Void, failure: (EmbyError) -> Void)
    {
        let args = QueryStringDictionary()
        
        args.Add("deviceId", value: deviceId)
        
        let url = GetConnectUrl("pin") + "?" + args.GetQueryString()
        
        let request = HttpRequest(url: url, method: .POST, postData: args)
        
        AddXApplicationName(request)
        
        httpClient.sendRequest(request, success: success, failure: failure)
    }
    
    public func GetPinStatus(pin: PinCreationResult, success: (PinStatusResult) -> Void, failure: (EmbyError) -> Void)
    {
        let dict = QueryStringDictionary()
        
        dict.Add("deviceId", value: pin.deviceId)
        dict.Add("pin", value: pin.pin)
        
        let url = GetConnectUrl("pin") + "?" + dict.GetQueryString()
        
        let request = HttpRequest(url: url, method: .GET)
        
        AddXApplicationName(request)
        
        httpClient.sendRequest(request, success: success, failure: failure)
    }
    
    public func ExchangePin(pin: PinCreationResult, success: (PinExchangeResult) -> Void, failure: (EmbyError) -> Void)
    {
        let args = QueryStringDictionary()
        
        args.Add("deviceId", value: pin.deviceId)
        args.Add("pin", value: pin.pin)
        
        let url = GetConnectUrl("pin/authenticate")
        
        let request = HttpRequest(url: url, method: .POST, postData: args)
        
        AddXApplicationName(request)
        
        httpClient.sendRequest(request, success: success, failure: failure)
    }
    
    public func GetConnectUser(query: ConnectUserQuery, connectAccessToken: String?, success: (ConnectUser) -> Void, failure: (EmbyError) -> Void) throws
    {
        let dict = QueryStringDictionary()
        
        
        if let id = query.id
        {
            dict.Add("id", value: id)
        }
        else if let name = query.name
        {
            dict.Add("name", value: name)
        }
        else if let email = query.email
        {
            dict.Add("email", value: email)
        }
        else if let nameOrEmail = query.nameOrEmail
        {
            dict.Add("nameOrEmail", value: nameOrEmail)
        }
        else
        {
            throw Error.IllegalArgumentException("Empty ConnectUserQuery")
        }
        
        let url = GetConnectUrl("user") + "?" + dict.GetQueryString()
        
        let request = HttpRequest(url: url, method: .GET)
        
        try AddUserAccessToken(request, accessToken: connectAccessToken)
        AddXApplicationName(request)
        
        httpClient.sendRequest(request, success: success, failure: failure)
    }
    
    public func GetServers(userId: String, connectAccessToken: String, success: ([ConnectUserServer]) -> Void, failure: (EmbyError) -> Void) throws
    {
        let dict = QueryStringDictionary()
        
        dict.Add("userId", value: userId)
        
        let url = GetConnectUrl("servers") + "?" + dict.GetQueryString()
        
        let request = HttpRequest(url: url, method: .GET)
        
        try AddUserAccessToken(request, accessToken: connectAccessToken)
        AddXApplicationName(request)
        
        httpClient.sendCollectionRequest(request, success: success, failure: failure)
    }
    
    public func Logout(connectAccessToken: String, success: (EmptyResponse) -> Void, failure: (EmbyError) -> Void) throws
    {
        let url = GetConnectUrl("user/logout")
        
        let request = HttpRequest(url: url, method: .POST)
        
        try AddUserAccessToken(request, accessToken: connectAccessToken)
        AddXApplicationName(request)
        
        httpClient.sendRequest(request, success: success, failure: failure)
    }
    
    private func GetConnectUrl(handler: String) -> String
    {
        return Configuration.mediaBrowserTV_APIServer + handler
    }
    
    private func AddUserAccessToken(request: HttpRequest, accessToken: String?) throws
    {
        if let accessToken = accessToken
        {
            request.headers["X-Connect-UserToken"] = accessToken
        } else {
            throw Error.IllegalArgumentException("accessToken")
        }
    }
    
    private func AddXApplicationName(request: HttpRequest)
    {
        request.headers["X-Application"] = appName + "/" + appVersion
    }
    
    public func GetRegistrationInfo(userId: String, feature: String, connectAccessToken: String, success: (RegistrationInfo) -> Void, failure: (EmbyError) -> Void) throws
    {
        let dict = QueryStringDictionary()
        
        dict.Add("userId", value: userId)
        dict.Add("feature", value: feature)
        
        let url = GetConnectUrl("registrationInfo") + "?" + dict.GetQueryString()
        
        let request = HttpRequest(url: url, method: .GET)
        
        try AddUserAccessToken(request, accessToken: connectAccessToken)
        
        AddXApplicationName(request)
        
        httpClient.sendRequest(request, success: success, failure: failure)
    }
}