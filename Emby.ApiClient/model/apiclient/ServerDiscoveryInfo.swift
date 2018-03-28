//
//  ServerDiscoveryInfo.swift
//  EmbyApiClient
//

import Foundation

public class ServerDiscoveryInfo: JSONSerializable {
    let address: String
    let id: String
    let name: String

    public required init(jSON: JSON_Object) {
        
        //        {"Address":"http://192.168.1.68:8096","Id":"942bef179117406d852072d207a74a23","Name":"Vedrans-Mini.lan"}
        
        guard let address = jSON["Address"] as? String,
            let id = jSON["Id"] as? String,
            let name = jSON["Name"] as? String else
        {
                preconditionFailure("ServerDiscoveryInfo missing required field")
        }
        
        self.address = address
        self.id = id
        self.name = name
    }
    
    public func toJsonString() -> String {
        let dict = ["Address" : address, "Id": id, "Name": name]
        let jsonData = try! JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
        return String(data: jsonData, encoding: String.Encoding.ascii)!
    }
}

extension ServerDiscoveryInfo: Hashable {
    public var hashValue: Int {
        return id.hashValue
    }
}

public func ==(lhs: ServerDiscoveryInfo, rhs: ServerDiscoveryInfo) -> Bool {
    return lhs.id == rhs.id
}
