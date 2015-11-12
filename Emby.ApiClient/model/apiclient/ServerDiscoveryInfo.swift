//
//  ServerDiscoveryInfo.swift
//  EmbyApiClient
//

import Foundation

public class ServerDiscoveryInfo: JSONSerializable {
    let address: String?
    let id: String?
    let name: String?

    public required init(jSON: JSON_Object) {
        
        //        {"Address":"http://192.168.1.68:8096","Id":"942bef179117406d852072d207a74a23","Name":"Vedrans-Mini.lan"}
        
        if let Address = jSON["Address"] as? String {
            self.address = Address
        } else {
            self.address = nil
        }
        
        if let Id = jSON["Id"] as? String {
            self.id = Id
        } else {
            self.id = nil
        }
        
        if let Name = jSON["Name"] as? String {
            self.name = Name
        } else {
            self.name = nil
        }
    }
}