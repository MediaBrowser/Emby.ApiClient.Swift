//
//  HttpRequest.swift
//  Emby.ApiClient
//
//  Created by Vedran Ozir on 07/10/15.
//  Copyright © 2015 Vedran Ozir. All rights reserved.
//

import Foundation

import Alamofire

public struct HttpRequest : URLRequestConvertible
{
    let method: HTTPMethod
    let url: String
    
    let postData: QueryStringDictionary?
    
    var requestContent: String?
    var requestContentType: String?
    
    var headers: HttpHeaders = HttpHeaders()
    
    init(url: String, method: HTTPMethod, postData: QueryStringDictionary? = nil) {
        self.url = url
        self.method = method
        self.postData = postData
    }
    
    public func asURLRequest() throws -> URLRequest {
        var encodedURL: URLRequest? = nil
        let url = URL(string: self.url)!
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        
        let encoding: ParameterEncoding = (postData != nil) ? Alamofire.JSONEncoding.default : Alamofire.URLEncoding.default
        
        do {
            encodedURL = try encoding.encode(request as URLRequestConvertible, with: postData?.data)
            
            if headers.data.count > 0 {
                for (key, value) in headers.data {
                    encodedURL!.setValue(value, forHTTPHeaderField: key)
                }
            }
            
        } catch let error {
            print(error)
        }
        
        return encodedURL!
    }
    
    mutating func addHeaders(newHeaders: HttpHeaders) {
        
        if let contentType = requestContentType {
            newHeaders["Content-Type"] = contentType
        } else {
            newHeaders["Content-Type"] = "application/json"
        }
        
        if let authParameter = newHeaders.authorizationParameter, let authScheme = newHeaders.authorizationScheme {
            let value = authScheme + " " + authParameter
            newHeaders["X-Emby-Authorization"] = value
        }
        
        headers = newHeaders
    }
    
    
}

