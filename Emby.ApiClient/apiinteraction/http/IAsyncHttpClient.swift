//
//  IAsyncHttpClient.swift
//  Emby.ApiClient
//
//  Created by Vedran Ozir on 07/10/15.
//  Copyright © 2015 Vedran Ozir. All rights reserved.
//

import Foundation

import Alamofire

public protocol IAsyncHttpClient {
    func sendRequest<T : JSONSerializable>(request: HttpRequest, success: @escaping (T) -> Void, failure: @escaping (EmbyError) -> Void)
    func sendCollectionRequest<T : JSONSerializable>(request: HttpRequest, success: @escaping ([T]) -> Void, failure: @escaping (EmbyError) -> Void)
}

//extension Array:JSONSerializable where Element: JSONSerializable {
//    public init?(jSON: JSON_Object) {
//        return nil
//    }
//}
