//
//  StringRequest.swift
//  Emby.ApiClient
//
//  Created by Vedran Ozir on 07/10/15.
//  Copyright © 2015 Vedran Ozir. All rights reserved.
//

import Foundation
//package com.android.volley.toolbox;
//import com.android.volley.NetworkResponse;
//import com.android.volley.Request;
//import com.android.volley.Response;
//import com.android.volley.Response.ErrorListener;
//import com.android.volley.Response.Listener;
//import java.io.UnsupportedEncodingException;

/**
* A canned request for retrieving the response body at a given URL as a String.
*/

public class StringRequest: Request<String> {
    private final let mListener: Response_Listener
//    /**
//    * Creates a new request with the given method.
//    *
//    * @param method the request {@link Method} to use
//    * @param url URL to fetch the string at
//    * @param listener Listener to receive the String response
//    * @param errorListener Error listener, or null to ignore errors
//    */
    /*public*/ init(method: String, url: String, listener: Response_Listener, errorListener: Response_ErrorListener/*Listener<String>,
        errorListener: ErrorListener*/) {
        mListener = listener;
        super.init(method: method, url: url, listener: errorListener);
    }
//    /**
//    * Creates a new GET request.
//    *
//    * @param url URL to fetch the string at
//    * @param listener Listener to receive the String response
//    * @param errorListener Error listener, or null to ignore errors
//    */
//    public StringRequest(String url, Listener<String> listener, ErrorListener errorListener) {
//        this(Method.GET, url, listener, errorListener);
//    }
//    @Override
    internal func deliverResponse(response: String) {
        mListener.onResponse(response);
    }
//    @Override
//    protected Response<String> parseNetworkResponse(NetworkResponse response) {
//        String parsed;
//        try {
//            parsed = new String(response.data, HttpHeaderParser.parseCharset(response.headers));
//        } catch (UnsupportedEncodingException e) {
//            parsed = new String(response.data);
//        }
//        return Response.success(parsed, HttpHeaderParser.parseCacheHeaders(response));
//    }
}