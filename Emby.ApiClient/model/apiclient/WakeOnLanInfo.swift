//
//  WakeOnLanInfo.swift
//  Emby.ApiClient
//

import Foundation

public class WakeOnLanInfo: NSObject, NSCoding {
    let macAddress: String
    let port: Int
    
    init(macAddress: String, port: Int = 0) {
        self.macAddress = macAddress
        self.port = port
    }
    
    
    // MARK: NSCoding
    
    public required convenience init?(coder aDecoder: NSCoder) {
        guard let macAddress = aDecoder.decodeObjectForKey("") as? String
            else { return nil }
        
        self.init(macAddress: macAddress, port: aDecoder.decodeIntegerForKey("port"))
    }
    
    public func encodeWithCoder(aCoder: NSCoder) {
        
    }
}