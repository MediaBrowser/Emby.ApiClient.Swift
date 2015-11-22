//
//  ConnectService.swift
//  Emby.ApiClient
//
//  Created by Vedran Ozir on 07/10/15.
//  Copyright © 2015 Vedran Ozir. All rights reserved.
//

import Foundation

//package mediabrowser.apiinteraction.connect;
//
//import mediabrowser.apiinteraction.EmptyResponse;
//import mediabrowser.apiinteraction.QueryStringDictionary;
//import mediabrowser.apiinteraction.Response;
//import mediabrowser.apiinteraction.SerializedResponse;
//import mediabrowser.apiinteraction.cryptography.Md5;
//import mediabrowser.apiinteraction.http.HttpRequest;
//import mediabrowser.apiinteraction.http.IAsyncHttpClient;
//import mediabrowser.model.connect.*;
//import mediabrowser.model.logging.ILogger;
//import mediabrowser.model.registration.RegistrationInfo;
//import mediabrowser.model.serialization.IJsonSerializer;
//
//import java.io.UnsupportedEncodingException;
//import java.security.NoSuchAlgorithmException;

enum Error:ErrorType {
    case IllegalArgumentException(String)
    case LowBridge
}

class Md5 {
    static func getHash(from: String) -> String! {
        let str = from.cStringUsingEncoding(NSUTF8StringEncoding)
        let strLen = CUnsignedInt(from.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.destroy()
        
        return String( hash)
    }
}

public class ConnectService {
    
    public let JsonSerializer: IJsonSerializer
    let logger: ILogger
    let httpClient: IAsyncHttpClient
    private let appName: String
    private let appVersion: String
    
    public init(jsonSerializer: IJsonSerializer, logger: ILogger, httpClient: IAsyncHttpClient, appName: String, appVersion: String) {
        self.JsonSerializer = jsonSerializer;
        self.logger = logger;
        self.httpClient = httpClient;
        self.appName = appName;
        self.appVersion = appVersion;
    }
    
    public func Authenticate<T:ConnectAuthenticationResult>(username: String, password: String, /*final*/ response: EmbyApiClient.Response<T>) {
        // UnsupportedEncodingException, NoSuchAlgorithmException {
        
        let args = QueryStringDictionary()
        
        args.Add("nameOrEmail", value: username);
        args.Add("password", value: Md5.getHash(ConnectPassword.PerformPreHashFilter(password)));
        
        let url = GetConnectUrl("user/authenticate");
        
        let request = HttpRequest();
        
        request.setMethod("POST");
        request.setUrl(url);
        request.setPostData(args);

        AddXApplicationName(request);
        
        httpClient.Send(request, response: SerializedResponse<T>(innerResponse: response, jsonSerializer: JsonSerializer, type: ConnectAuthenticationResult.self));
    }
    
    public func CreatePin<T:PinCreationResult>(deviceId: String, final response: EmbyApiClient.Response<T>)
    {
        let args = QueryStringDictionary()
        
        args.Add("deviceId", value: deviceId);
        
        let url = GetConnectUrl("pin") + "?" + args.GetQueryString();
        
        let request = HttpRequest();
        
        request.setMethod("POST");
        request.setUrl(url);
        request.setPostData(args);
        
        AddXApplicationName(request);
        
        httpClient.Send(request, response: SerializedResponse<T>(innerResponse: response, jsonSerializer: JsonSerializer, type: PinCreationResult.self));
    }
    
    public func GetPinStatus<T:PinStatusResult>(pin: PinCreationResult, final response: EmbyApiClient.Response<T>)
    {
        let dict = QueryStringDictionary();
        
        dict.Add("deviceId", value: pin.getDeviceId());
        dict.Add("pin", value: pin.getPin());
        
        let url = GetConnectUrl("pin") + "?" + dict.GetQueryString();
        
        let request = HttpRequest()
        
        request.setMethod("GET");
        request.setUrl(url);
        
        AddXApplicationName(request);
        
        httpClient.Send(request, response: SerializedResponse<T>(innerResponse: response, jsonSerializer: JsonSerializer, type: PinStatusResult.self));
    }
    
    public func ExchangePin<T:PinExchangeResult>(pin: PinCreationResult, final response: EmbyApiClient.Response<T>)
    {
        let args = QueryStringDictionary();
        
        args.Add("deviceId", value: pin.getDeviceId());
        args.Add("pin", value: pin.getPin());
        
        let url = GetConnectUrl("pin/authenticate");
        
        let request = HttpRequest()
        
        request.setMethod("POST");
        request.setUrl(url);
        request.setPostData(args);
        
        AddXApplicationName(request);
        
        httpClient.Send(request, response: SerializedResponse<T>(innerResponse: response, jsonSerializer: JsonSerializer, type: PinExchangeResult.self));
    }
    
    public func GetConnectUser<T:ConnectUser>(query: ConnectUserQuery, connectAccessToken: String?, final response: EmbyApiClient.Response<T>) throws
    {
        let dict = QueryStringDictionary();
        
        if let id = query.getId()
        {
            dict.Add("id", value: id);
        }
        else if let name = query.getName()
        {
            dict.Add("name", value: name);
        }
        else if let email = query.getEmail()
        {
            dict.Add("email", value: email);
        }
        else if let nameOrEmail = query.getNameOrEmail()
        {
            dict.Add("nameOrEmail", value: nameOrEmail);
        }
        else
        {
            throw Error.IllegalArgumentException("Empty ConnectUserQuery")
        }
        
        let url = GetConnectUrl("user") + "?" + dict.GetQueryString();
        
        let request = HttpRequest()
        
        request.setMethod("GET");
        request.setUrl(url);
        
        try AddUserAccessToken(request, accessToken: connectAccessToken)
        AddXApplicationName(request);
        
        httpClient.Send(request, response: SerializedResponse<T>(innerResponse: response, jsonSerializer: JsonSerializer, type: ConnectUser.self));
    }
    
    public func GetServers<T:ConnectUserServers>(userId: String, connectAccessToken: String, final response: EmbyApiClient.Response<T>) throws
    {
        let dict = QueryStringDictionary();
        
        dict.Add("userId", value: userId)
        
        let url = GetConnectUrl("servers") + "?" + dict.GetQueryString();
        
        let request = HttpRequest()
        
        request.setMethod("GET");
        request.setUrl(url);
        
        try AddUserAccessToken(request, accessToken: connectAccessToken)
        AddXApplicationName(request);
        
        httpClient.Send(request, response: SerializedResponse<T>(innerResponse: response, jsonSerializer: JsonSerializer, type: ConnectUserServers.self));
    }
    
    public func Logout<T:EmptyResponse>(connectAccessToken: String, final response: EmbyApiClient.Response<T>) throws
    {
        let url = GetConnectUrl("user/logout");
        
        let request = HttpRequest()
        
        request.setMethod("POST");
        request.setUrl(url);
        
        try AddUserAccessToken(request, accessToken: connectAccessToken)
        AddXApplicationName(request);
        
        httpClient.Send(request, response: SerializedResponse<T>(innerResponse: response, jsonSerializer: JsonSerializer, type: EmptyResponse.self));
    }
    
    private func GetConnectUrl(handler: String) -> String
    {
        return Configuration.mediaBrowserTV_APIServer + handler;
    }
    
    private func AddUserAccessToken(request: HttpRequest, accessToken: String?) throws
    {
        if let accessToken = accessToken
        {
            request.getRequestHeaders()?.put("X-Connect-UserToken", value: accessToken);
        } else {
            throw Error.IllegalArgumentException("accessToken")
        }
    }
    
    private func AddXApplicationName(request: HttpRequest)
    {
        request.getRequestHeaders()?.put("X-Application", value: appName + "/" + appVersion);
    }
    
    public func GetRegistrationInfo<T:RegistrationInfo>(userId: String, feature: String, connectAccessToken: String, final response: EmbyApiClient.Response<T>) throws
    {
        let dict = QueryStringDictionary();
        
        dict.Add("userId", value: userId)
        dict.Add("feature", value: feature);
        
        let url = GetConnectUrl("registrationInfo") + "?" + dict.GetQueryString();
        
        let request = HttpRequest()
        
        request.setMethod("GET");
        request.setUrl(url);
        
        try AddUserAccessToken(request, accessToken: connectAccessToken)
        
        AddXApplicationName(request);
        
        httpClient.Send(request, response: SerializedResponse<T>(innerResponse: response, jsonSerializer: JsonSerializer, type: RegistrationInfo.self));
    }
}