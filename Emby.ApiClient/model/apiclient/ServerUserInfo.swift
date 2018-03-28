//
//  ServerUserInfo.swift
//  Emby.ApiClient
//

import Foundation

public class ServerUserInfo: NSObject, NSCoding {
    public func encode(with aCoder: NSCoder) {
    }
    
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
    
    // MARK: NSObject
    
    /*override public func isEqual(object: AnyObject?) -> Bool {
        if let rhs = object as? ServerUserInfo {
            return id == rhs.id
        }
        return false
    }*/
    
    // MARK: NSCoding
    
    public required convenience init?(coder aDecoder: NSCoder) {
        guard let id = aDecoder.decodeObject(forKey: "id") as? String
            else {
                return nil
        }
        
        self.init(id: id, isSignedInOffline: aDecoder.decodeBool(forKey: "isSignedInOffline"))
    }
    
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.isSignedInOffline, forKey: "isSignedInOffline")
    }
    
    //MARK: - Equatable
    override public func isEqual(_ object: Any?) -> Bool {
        return id == (object as? ServerUserInfo)?.id
    }
}
