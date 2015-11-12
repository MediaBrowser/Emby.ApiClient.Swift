//
//  Response.swift
//  Emby.ApiClient
//
//  Created by Vedran Ozir on 07/10/15.
//  Copyright © 2015 Vedran Ozir. All rights reserved.
//

import Foundation

//package com.android.volley;
/**
* Encapsulates a parsed response for delivery.
*
* @param <T> Parsed type of this response
*/

//package mediabrowser.apiinteraction;

public class Response<T>: Response_Listener<T> {
    
    public var completion: ((object: T?) -> Void)?
    public var completionError: ((error: NSError?) -> Void)?
    
    public override init() {
    }
    
//    private var innerResponse: IResponse?
    internal var innerResponse: Response?

//    /*public*/ init(innerResponse: IResponse?){
    /*public*/ init(innerResponse: Response?){
        self.innerResponse = innerResponse;
    }

//    public Response(){
//
//    }
    public func onResponse(response: T?) throws -> T? {
        completion?(object: response)
        
        return response
    }
    
    public override func onResponse(response: Any) throws -> T? {
//        triggerInnerResponse();
        
        let result = try innerResponse?.onResponse(response);
        
        return result
    }

//    internal func triggerInnerResponse(){
//        if (innerResponse != null && innerResponse instanceof EmptyResponse){
//
//            let emptyResponse = innerResponse as EmptyResponse;
//            emptyResponse.onResponse();
//        }
//    }

//    @Override
    public func onError(error: NSError?)
    {
        innerResponse?.onError(error)
        completionError?(error: error)
    }
}

//public class Response<T>: Response_Listener {
//    
//    public init() {
//        
//    }
//    
////    /** Callback interface for delivering parsed responses. */
////    public interface Listener<T> {
////    /** Called when a response is received. */
////    public void onResponse(T response);
////    }
//    
////    func onResponse(response: Any) {}
//    func onResponse<T: JSONSerializable>(result: Any) throws -> T? {
//        print("onResponse 3")
//        
//        return nil
//    }
//    
////    /** Callback interface for delivering error responses. */
////    public interface ErrorListener {
////    /**
////    * Callback method that an error has been occurred with the
////    * provided error code and optional user-readable message.
////    */
////    public void onErrorResponse(VolleyError error);
////    }
////    /** Returns a successful response containing the parsed result. */
////    public static <T> Response<T> success(T result, Cache.Entry cacheEntry) {
////    return new Response<T>(result, cacheEntry);
////    }
////    /**
////    * Returns a failed response containing the given error code and an optional
////    * localized message displayed to the user.
////    */
////    public static <T> Response<T> error(VolleyError error) {
////    return new Response<T>(error);
////    }
////    /** Parsed response, or null in the case of error. */
////    public final T result;
////    /** Cache metadata for this response, or null in the case of error. */
////    public final Cache.Entry cacheEntry;
////    /** Detailed error information if <code>errorCode != OK</code>. */
////    public final VolleyError error;
////    /** True if this response was a soft-expired one and a second one MAY be coming. */
////    public boolean intermediate = false;
////    /**
////    * Returns whether this response is considered successful.
////    */
////    public boolean isSuccess() {
////    return error == null;
////    }
////    private func init(result: T, cacheEntry: Cache.Entry) {
////    this.result = result;
////    this.cacheEntry = cacheEntry;
////    this.error = null;
////    }
////    private Response(VolleyError error) {
////    this.result = null;
////    this.cacheEntry = null;
////    this.error = error;
////    }
//}

public class Response_Listener<T> {
    
//    func onResponse(response: Any)
    func onResponse(result: Any) throws -> T? {
        return nil
    }
}

public class Response_ErrorListener {
    
    public func onErrorResponse(error: VolleyError) {
        print("onErrorResponse")
    }
}

public enum Request_Method: Int {
    case OPTIONS, GET, HEAD, POST, PUT, PATCH, DELETE, TRACE, CONNECT
}
