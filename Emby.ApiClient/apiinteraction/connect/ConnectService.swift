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
    
//    public func ConnectService(IJsonSerializer jsonSerializer, ILogger logger, IAsyncHttpClient httpClient, String appName, String appVersion) {
//    JsonSerializer = jsonSerializer;
//    _logger = logger;
//    _httpClient = httpClient;
//    this.appName = appName;
//    this.appVersion = appVersion;
//    }

    public func Authenticate(username: String, password: String
        
//        , final Response<ConnectAuthenticationResult> response
        
        ) throws { // UnsupportedEncodingException, NoSuchAlgorithmException {
        
        let args = QueryStringDictionary()
        
        args.Add("nameOrEmail", value: username);
        args.Add("password", value: Md5.getHash(ConnectPassword.PerformPreHashFilter(password)));
        
        let url = GetConnectUrl("user/authenticate");
        
        let request = HttpRequest();
        
        request.setMethod("POST");
        request.setUrl(url);
        request.setPostData(args);
        
        AddXApplicationName(request);
        
        _httpClient.Send(request, new SerializedResponse<ConnectAuthenticationResult>(response, JsonSerializer, ConnectAuthenticationResult.class));
    }
    
//    public void CreatePin(String deviceId, final Response<PinCreationResult> response)
//    {
//    QueryStringDictionary args = new QueryStringDictionary();
//    
//    args.Add("deviceId", deviceId);
//    
//    String url = GetConnectUrl("pin") + "?" + args.GetQueryString();
//    
//    HttpRequest request = new HttpRequest();
//    
//    request.setMethod("POST");
//    request.setUrl(url);
//    request.setPostData(args);
//    
//    AddXApplicationName(request);
//    
//    _httpClient.Send(request, new SerializedResponse<PinCreationResult>(response, JsonSerializer, PinCreationResult.class));
//    }
//    
//    public void GetPinStatus(PinCreationResult pin, final Response<PinStatusResult> response)
//    {
//    QueryStringDictionary dict = new QueryStringDictionary();
//    
//    dict.Add("deviceId", pin.getDeviceId());
//    dict.Add("pin", pin.getPin());
//    
//    String url = GetConnectUrl("pin") + "?" + dict.GetQueryString();
//    
//    HttpRequest request = new HttpRequest();
//    
//    request.setMethod("GET");
//    request.setUrl(url);
//    
//    AddXApplicationName(request);
//    
//    _httpClient.Send(request, new SerializedResponse<PinStatusResult>(response, JsonSerializer, PinStatusResult.class));
//    }
//    
//    public void ExchangePin(PinCreationResult pin, final Response<PinExchangeResult> response)
//    {
//    QueryStringDictionary args = new QueryStringDictionary();
//    
//    args.Add("deviceId", pin.getDeviceId());
//    args.Add("pin", pin.getPin());
//    
//    String url = GetConnectUrl("pin/authenticate");
//    
//    HttpRequest request = new HttpRequest();
//    
//    request.setMethod("POST");
//    request.setUrl(url);
//    request.setPostData(args);
//    
//    AddXApplicationName(request);
//    
//    _httpClient.Send(request, new SerializedResponse<PinExchangeResult>(response, JsonSerializer, PinExchangeResult.class));
//    }
//    
//    public void GetConnectUser(ConnectUserQuery query, String connectAccessToken, final Response<ConnectUser> response)
//    {
//    QueryStringDictionary dict = new QueryStringDictionary();
//    
//    if (!tangible.DotNetToJavaStringHelper.isNullOrEmpty(query.getId()))
//    {
//    dict.Add("id", query.getId());
//    }
//    else if (!tangible.DotNetToJavaStringHelper.isNullOrEmpty(query.getName()))
//    {
//    dict.Add("name", query.getName());
//    }
//    else if (!tangible.DotNetToJavaStringHelper.isNullOrEmpty(query.getEmail()))
//    {
//    dict.Add("email", query.getEmail());
//    }
//    else if (!tangible.DotNetToJavaStringHelper.isNullOrEmpty(query.getNameOrEmail()))
//    {
//    dict.Add("nameOrEmail", query.getNameOrEmail());
//    }
//    else
//    {
//    throw new IllegalArgumentException("Empty ConnectUserQuery");
//    }
//    
//    String url = GetConnectUrl("user") + "?" + dict.GetQueryString();
//    
//    HttpRequest request = new HttpRequest();
//    
//    request.setMethod("GET");
//    request.setUrl(url);
//    
//    AddUserAccessToken(request, connectAccessToken);
//    AddXApplicationName(request);
//    
//    _httpClient.Send(request, new SerializedResponse<ConnectUser>(response, JsonSerializer, ConnectUser.class));
//    }
//    
//    public void GetServers(String userId, String connectAccessToken, final Response<ConnectUserServer[]> response)
//    {
//    QueryStringDictionary dict = new QueryStringDictionary();
//    
//    dict.Add("userId", userId);
//    
//    String url = GetConnectUrl("servers") + "?" + dict.GetQueryString();
//    
//    HttpRequest request = new HttpRequest();
//    
//    request.setMethod("GET");
//    request.setUrl(url);
//    
//    AddUserAccessToken(request, connectAccessToken);
//    AddXApplicationName(request);
//    
//    _httpClient.Send(request, new SerializedResponse<ConnectUserServer[]>(response, JsonSerializer, new ConnectUserServer[]{}.getClass()));
//    }
//    
//    public void Logout(String connectAccessToken, final EmptyResponse response)
//    {
//    String url = GetConnectUrl("user/logout");
//    
//    HttpRequest request = new HttpRequest();
//    
//    request.setMethod("POST");
//    request.setUrl(url);
//    
//    AddUserAccessToken(request, connectAccessToken);
//    AddXApplicationName(request);
//    
//    _httpClient.Send(request, new Response<String>(response));
//    }
    
    private func GetConnectUrl(handler: String) -> String
    {
        return "https://connect.mediabrowser.tv/service/" + handler;
    }
    
//    private void AddUserAccessToken(HttpRequest request, String accessToken)
//    {
//    if (tangible.DotNetToJavaStringHelper.isNullOrEmpty(accessToken))
//    {
//    throw new IllegalArgumentException("accessToken");
//    }
//    
//    request.getRequestHeaders().put("X-Connect-UserToken", accessToken);
//    }
    
    private func AddXApplicationName(HttpRequest request)
    {
        request.getRequestHeaders().put("X-Application", appName + "/" + appVersion);
    }
    
//    public void GetRegistrationInfo(String userId, String feature, String connectAccessToken, final Response<RegistrationInfo> response)
//    {
//    QueryStringDictionary dict = new QueryStringDictionary();
//    
//    dict.Add("userId", userId);
//    dict.Add("feature", feature);
//    
//    String url = GetConnectUrl("registrationInfo") + "?" + dict.GetQueryString();
//    
//    HttpRequest request = new HttpRequest();
//    
//    request.setMethod("GET");
//    request.setUrl(url);
//    
//    AddUserAccessToken(request, connectAccessToken);
//    AddXApplicationName(request);
//    
//    _httpClient.Send(request, new SerializedResponse<RegistrationInfo>(response, JsonSerializer, new RegistrationInfo().getClass()));
//    }
}