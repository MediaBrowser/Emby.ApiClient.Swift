//
//  HttpClient.swift
//  Emby.ApiClient
//
//  Created by Vedran Ozir on 07/10/15.
//  Copyright © 2015 Vedran Ozir. All rights reserved.
//

import Foundation
import Alamofire

public class HttpClient : IAsyncHttpClient {
    
    private let logger: ILogger
    private let context: Context
    
    public init(logger: ILogger, context: Context) {
        self.logger = logger;
        self.context = context;
    }
    
    public func sendRequest<T : JSONSerializable>(request: HttpRequest, success: @escaping (T) -> Void, failure: @escaping (EmbyError) -> Void) {
        
        Alamofire.request(request)
            .responseJSON { (res) -> Void in
                
                if case .Success(let json) = res.result {
                    if  let jsonObject = json as? JSON_Object {
                        
                        if let object = T(jSON: jsonObject) {
                            success(object)
                        }
                        else {
                            failure(EmbyError.JsonDeserializationError)
                        }
                    }
                    else {
                        failure(EmbyError.JsonDeserializationError)
                    }
                }
                else if case .Failure(let error) = res.result {
                    failure(EmbyError.NetworkRequestError(error.description))
                }
        }
    }
    
    public func sendCollectionRequest<T : JSONSerializable>(request: HttpRequest, success: @escaping ([T]) -> Void, failure: @escaping (EmbyError) -> Void) {
        
        Alamofire.request(request)
            .responseJSON { (res) -> Void in
                
                if case .Success(let json) = res.result {
                    if let jsonArray = json as? JSON_Array {
                        
                        var results: [T] = []
                        
                        for object in jsonArray {
                            if let jsonObject = object as? JSON_Object, let object = T(jSON: jsonObject) {
                                results.append(object)
                            }
                        }
                        
                        success(results)
                    }
                    else {
                        failure(EmbyError.JsonDeserializationError)
                    }
                }
                else if case .Failure(let error) = res.result {
                    failure(EmbyError.NetworkRequestError(error.description))
                }
        }
    }
}

public enum EmbyError: Error {
    
    case JsonDeserializationError
    case NetworkRequestError(String)
}
