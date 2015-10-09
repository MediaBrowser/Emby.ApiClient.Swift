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

public class Response<T>: Response_Listener {
    
//    /** Callback interface for delivering parsed responses. */
//    public interface Listener<T> {
//    /** Called when a response is received. */
//    public void onResponse(T response);
//    }
    func onResponse(response: Any) {}
    
//    /** Callback interface for delivering error responses. */
//    public interface ErrorListener {
//    /**
//    * Callback method that an error has been occurred with the
//    * provided error code and optional user-readable message.
//    */
//    public void onErrorResponse(VolleyError error);
//    }
//    /** Returns a successful response containing the parsed result. */
//    public static <T> Response<T> success(T result, Cache.Entry cacheEntry) {
//    return new Response<T>(result, cacheEntry);
//    }
//    /**
//    * Returns a failed response containing the given error code and an optional
//    * localized message displayed to the user.
//    */
//    public static <T> Response<T> error(VolleyError error) {
//    return new Response<T>(error);
//    }
//    /** Parsed response, or null in the case of error. */
//    public final T result;
//    /** Cache metadata for this response, or null in the case of error. */
//    public final Cache.Entry cacheEntry;
//    /** Detailed error information if <code>errorCode != OK</code>. */
//    public final VolleyError error;
//    /** True if this response was a soft-expired one and a second one MAY be coming. */
//    public boolean intermediate = false;
//    /**
//    * Returns whether this response is considered successful.
//    */
//    public boolean isSuccess() {
//    return error == null;
//    }
//    private func init(result: T, cacheEntry: Cache.Entry) {
//    this.result = result;
//    this.cacheEntry = cacheEntry;
//    this.error = null;
//    }
//    private Response(VolleyError error) {
//    this.result = null;
//    this.cacheEntry = null;
//    this.error = error;
//    }
}

protocol Response_Listener {
    
    func onResponse(response: Any)
}

public class Response_ErrorListener {
    
}

public enum Request_Method: Int {
    case OPTIONS, GET, HEAD, POST, PUT, PATCH, DELETE, TRACE, CONNECT
}
