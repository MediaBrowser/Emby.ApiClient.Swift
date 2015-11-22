//
//  SerializedResponse.swift
//  Emby.ApiClient
//
//  Created by Vedran Ozir on 07/10/15.
//  Copyright © 2015 Vedran Ozir. All rights reserved.
//

import Foundation

//package mediabrowser.apiinteraction;
//
//import mediabrowser.apiinteraction.Response;
//import mediabrowser.model.logging.ILogger;
//import mediabrowser.model.serialization.IJsonSerializer;

//public class SerializedResponse: Emby_ApiClient.Response<Any> {
public class SerializedResponse<T: JSONSerializable>: EmbyApiClient.Response<T> {
//public class SerializedResponse: Emby.ResponseX<T> {

//    func onResponse(response: Any) {}
    
    private let jsonSerializer: IJsonSerializer
    private let type: Any
//    /*protected*/ let innerResponse: Emby.Response?
    private let url: String? = nil
//    private ILogger logger;
    
    public init(innerResponse: EmbyApiClient.Response<T>, jsonSerializer: IJsonSerializer, type: Any) {
        
        self.jsonSerializer = jsonSerializer;
        self.type = type;
//        self.innerResponse = innerResponse;
        
        super.init(innerResponse: innerResponse)
    }
    
//    public SerializedResponse(Emby_ApiClient.Response<T> innerResponse, IJsonSerializer jsonSerializer, String url, ILogger logger, Class type) {
//        super(innerResponse);
//        self.jsonSerializer = jsonSerializer;
//        self.type = type;
//        self.innerResponse = innerResponse;
//        self.url = url;
//        self.logger = logger;
//    }
//    
//    
//    @Override
//    override public func onResponse<T: JSONSerializable>(result: Any) throws -> T? {
    override public func onResponse(result: Any) throws -> T? {
    
//        if (url != nil){
//            logger.Debug("Received response from %s", url);
//        }
        
        var obj: T? = nil
        
        if let string = result as? NSString {
            obj = try jsonSerializer.DeserializeFromString(string as String, type: type)
        }
        
        try onSerializedResponse(obj);
        
        return obj
    }
    
    /*protected*/ func onSerializedResponse(obj: T?) throws -> T? {
        
        let result = try self.innerResponse?.onResponse(obj);
        
        return result
    }
    
}