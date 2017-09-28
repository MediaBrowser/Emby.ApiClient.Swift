//
//  ServerInfo.swift
//  Emby.ApiClient
//

import Foundation

public class ServerInfo: NSObject, NSCoding {
    public func encode(with aCoder: NSCoder) {
    }
    
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
        
        if let lAddress = systemInfo.localAddress, !lAddress.isEmpty {
            localAddress = lAddress
        }
        
        if let wAddress = systemInfo.wanAddress, !wAddress.isEmpty {
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
        if (users.contains(user)) {
            users.remove(user)
        }
        users.insert(user)
    }
    
    // MARK: NSCoding
    
    public required init?(coder aDecoder: NSCoder) {
        super.init()
        
        guard let name = aDecoder.decodeObject(forKey: "name") as? String,
            let id = aDecoder.decodeObject(forKey: "id") as? String,
            let localAddress = aDecoder.decodeObject(forKey: "localAddress") as? String?,
            let remoteAddress = aDecoder.decodeObject(forKey: "remoteAddress") as? String?,
            let manualAddress = aDecoder.decodeObject(forKey: "manualAddress") as? String?,
            let userId = aDecoder.decodeObject(forKey: "userId") as? String?,
            let accessToken = aDecoder.decodeObject(forKey: "accessToken") as? String?,
            let dateLastAccessed = aDecoder.decodeObject(forKey: "dateLastAccessed") as? NSDate?,
            let userLinkTypeString = aDecoder.decodeObject(forKey: "userLinkType") as? String?,
            let lastConnectionModeString = aDecoder.decodeObject(forKey: "lastConnectionMode") as? String?,
            let users = aDecoder.decodeObject(forKey: "users") as? Set<ServerUserInfo>,
            let wakeOnLanInfos = aDecoder.decodeObject(forKey: "wakeOnLanInfos") as? [WakeOnLanInfo]
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
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.localAddress, forKey: "localAddress")
        aCoder.encode(self.remoteAddress, forKey: "remoteAddress")
        aCoder.encode(self.manualAddress, forKey: "manualAddress")
        aCoder.encode(self.userId, forKey: "userId")
        aCoder.encode(self.accessToken, forKey: "accessToken")
        aCoder.encode(self.dateLastAccessed, forKey: "dateLastAccessed")
        aCoder.encode(self.userLinkType?.rawValue, forKey: "userLinkType")
        aCoder.encode(self.lastConnectionMode?.rawValue, forKey: "lastConnectionMode")
        aCoder.encode(self.users, forKey: "users")
        aCoder.encode(self.wakeOnLanInfos, forKey: "wakeOnLanInfos")
    }
    
    
    // MARK: - Equatable
    /*public override func isEqual(object: AnyObject?) -> Bool {
        if let object = object as? ServerInfo {
            return self == object
        }
        return false
    }*/
    
    //MARK: - Equatable
    override public func isEqual(_ object: Any?) -> Bool {
        return id == (object as? ServerInfo)?.id
    }

}
