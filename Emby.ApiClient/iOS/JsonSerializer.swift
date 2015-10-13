//
//  JsonSerializer.swift
//  Emby.ApiClient
//
//  Created by Vedran Ozir on 12/10/15.
//  Copyright © 2015 Vedran Ozir. All rights reserved.
//

import Foundation

public class JsonSerializer: IJsonSerializer {
    
    public init() {
    }
    
    public func DeserializeFromString<T: JSONSerializable>(text: String, type: Any) throws -> T? {
        
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            
            if let jsonDictionary = try NSJSONSerialization.JSONObjectWithData( data, options: []) as? [String : AnyObject] {
            
            let obj = T(jSON: jsonDictionary)
            
            return obj
            } else {
                return nil
            }
            
        } else {
            return nil
        }
    }
}