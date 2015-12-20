//
//  ServerInfo.swift
//  Emby.ApiClient
//

import Foundation

public class ServerInfo: NSObject, NSCoding {
    public var users = Set<ServerUserInfo>()
    public var name: String = ""
    public var id: String = ""
    public var localAddress: String?
    public var remoteAddress: String?
    public var manualAddress: String?
    public var userId: String?
    public var accessToken: String?
    public var wakeOnLanInfos = [WakeOnLanInfo]()
    public var dateLastAccessed: NSDate?
    public var exchangeToken: String?
    public var userLinkType: UserLinkType?
    public var lastConnectionMode: ConnectionMode?
    
    override public var hashValue: Int {
        get {
            return id.hashValue
        }
    }
    
    override init() {
        
    }
    
    func importInfo(systemInfo: PublicSystemInfo) {
        name = systemInfo.serverName
        id = systemInfo.id
        
        if let lAddress = systemInfo.localAddress where !lAddress.isEmpty {
            localAddress = lAddress
        }
        
        if let wAddress = systemInfo.wanAddress where !wAddress.isEmpty {
            remoteAddress = wAddress
        }
        
        if let fullSystemInfo = systemInfo as? SystemInfo {
                wakeOnLanInfos.append(WakeOnLanInfo(macAddress: fullSystemInfo.macAddress))
        }
    }
    
    func getAddress(mode: ConnectionMode) -> String? {
        switch mode {
        case .Local:
            return localAddress
        case .Manual:
            return manualAddress
        case .Remote:
            return remoteAddress
        }
    }
    
    func addOrUpdate(user: ServerUserInfo) {
        if ( users.contains(user)) {
            users.remove(user)
        }
        
        users.insert(user)
    }
    
    // MARK: NSCoding
    
    public required init?(coder aDecoder: NSCoder) {
        super.init()
        
        guard let name = aDecoder.decodeObjectForKey("name") as? String,
            let id = aDecoder.decodeObjectForKey("id") as? String,
            let localAddress = aDecoder.decodeObjectForKey("localAddress") as? String?,
            let remoteAddress = aDecoder.decodeObjectForKey("remoteAddress") as? String?,
            let manualAddress = aDecoder.decodeObjectForKey("manualAddress") as? String?,
            let userId = aDecoder.decodeObjectForKey("userId") as? String?,
            let accessToken = aDecoder.decodeObjectForKey("accessToken") as? String?,
            let dateLastAccessed = aDecoder.decodeObjectForKey("dateLastAccessed") as? NSDate?,
            let userLinkTypeString = aDecoder.decodeObjectForKey("userLinkType") as? String?,
            let lastConnectionModeString = aDecoder.decodeObjectForKey("lastConnectionMode") as? String?,
            let users = aDecoder.decodeObjectForKey("users") as? Set<ServerUserInfo>,
            let wakeOnLanInfos = aDecoder.decodeObjectForKey("wakeOnLanInfos") as? [WakeOnLanInfo]
            else { return nil }
        
        self.name = name
        self.id = id
        self.localAddress = localAddress
        self.remoteAddress = remoteAddress
        self.manualAddress = manualAddress
        self.userId = userId
        self.accessToken = accessToken
        self.dateLastAccessed = dateLastAccessed
        self.userLinkType = UserLinkType(rawValue: userLinkTypeString ?? "")
        self.lastConnectionMode = ConnectionMode(rawValue: lastConnectionModeString ?? "")
        self.users = users
        self.wakeOnLanInfos = wakeOnLanInfos
    }
    
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.name, forKey: "name")
        aCoder.encodeObject(self.id, forKey: "id")
        aCoder.encodeObject(self.localAddress, forKey: "localAddress")
        aCoder.encodeObject(self.remoteAddress, forKey: "remoteAddress")
        aCoder.encodeObject(self.manualAddress, forKey: "manualAddress")
        aCoder.encodeObject(self.userId, forKey: "userId")
        aCoder.encodeObject(self.accessToken, forKey: "accessToken")
        aCoder.encodeObject(self.dateLastAccessed, forKey: "dateLastAccessed")
        aCoder.encodeObject(self.userLinkType?.rawValue, forKey: "userLinkType")
        aCoder.encodeObject(self.lastConnectionMode?.rawValue, forKey: "lastConnectionMode")
        aCoder.encodeObject(self.users, forKey: "users")
        aCoder.encodeObject(self.wakeOnLanInfos, forKey: "wakeOnLanInfos")
    }
    
    
    // MARK: - Equatable
    public override func isEqual(object: AnyObject?) -> Bool {
        if let object = object as? ServerInfo {
            return self == object
        }
        return false
    }
}

//MARK: - Equatable
public func ==(lhs: ServerInfo, rhs: ServerInfo) -> Bool {
    return lhs.id == rhs.id
}