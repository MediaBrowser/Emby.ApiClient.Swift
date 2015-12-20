//
//  ServerUserInfo.swift
//  Emby.ApiClient
//

import Foundation

public class ServerUserInfo: NSObject, NSCoding {
    var id: String
    var isSignedInOffline: Bool
    
    override public var hashValue: Int {
        get {
            return id.hashValue
        }
    }
    
    public init(id: String, isSignedInOffline: Bool) {
        self.id = id
        self.isSignedInOffline = isSignedInOffline
    }
    
    // MARK: NSCoding
    
    public required convenience init?(coder aDecoder: NSCoder) {
        guard let id = aDecoder.decodeObjectForKey("id") as? String
            else {
                return nil
        }
        
        self.init(id: id, isSignedInOffline: aDecoder.decodeBoolForKey("isSignedInOffline"))
    }
    
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.id, forKey: "id")
        aCoder.encodeBool(self.isSignedInOffline, forKey: "isSignedInOffline")
    }
}

//MARK: - Equatable
public func ==(lhs: ServerUserInfo, rhs: ServerUserInfo) -> Bool {
    return lhs.id == rhs.id
}