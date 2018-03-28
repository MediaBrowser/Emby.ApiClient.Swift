//
//  ServerCredentialsTests.swift
//  EmbyApiClient
//

import XCTest
@testable import EmbyApiClient

class ServerCredentialsTests: XCTestCase {
    var serverInfo = ServerInfo()
    var updatedServerInfo = ServerInfo()
    
    override func setUp() {
        super.setUp()
        //     
        serverInfo.users = [ServerUserInfo(id: "userId", isSignedInOffline: false)]

        serverInfo.name = "serverName"
        serverInfo.id = "serverId"
        serverInfo.localAddress = "localAddress"
        serverInfo.remoteAddress = "remoteAddress"
        serverInfo.manualAddress = "manualAddress"
        serverInfo.userId = "userId"
        serverInfo.accessToken = "accessToken"
        serverInfo.wakeOnLanInfos = [WakeOnLanInfo(macAddress: "02:99:9b:10:ac:4d")]
        serverInfo.dateLastAccessed = NSDate()
        serverInfo.exchangeToken = "exchangeToken"
        serverInfo.userLinkType = UserLinkType.Guest
        serverInfo.lastConnectionMode = ConnectionMode.Local
        
        updatedServerInfo.users = [ServerUserInfo(id: "userId", isSignedInOffline: false)]
        
        updatedServerInfo.name = "serverNameUpdated"
        updatedServerInfo.id = "serverId"
        updatedServerInfo.localAddress = "localAddressUpdated"
        updatedServerInfo.remoteAddress = "remoteAddressUpdated"
        updatedServerInfo.manualAddress = "manualAddressUpdated"
        updatedServerInfo.userId = "userIdUpdated"
        updatedServerInfo.accessToken = "accessTokenUpdated"
        updatedServerInfo.wakeOnLanInfos = [WakeOnLanInfo(macAddress: "99:99:99::99:99")]
        updatedServerInfo.dateLastAccessed = serverInfo.dateLastAccessed!.addingTimeInterval(60*60*24)
        updatedServerInfo.exchangeToken = "exchangeTokenUpdated"
        updatedServerInfo.userLinkType = UserLinkType.LinkedUser
        updatedServerInfo.lastConnectionMode = ConnectionMode.Local
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testServerIsAdded() {
        let serverCredentials = ServerCredentials(connectAccessToken: "connectAccessToken", connectUserId: "connectUserId")
        
        serverCredentials.addOrUpdateServer(server: serverInfo)
        
        let servers = serverCredentials.servers
        
        XCTAssertTrue(servers.count == 1, "Only one server should exist")
    }
    
    func testServerIsUpdated() {
        let serverCredentials = ServerCredentials(connectAccessToken: "connectAccessToken", connectUserId: "connectUserId")
        
        serverCredentials.addOrUpdateServer(server: updatedServerInfo)
        
        let server = serverCredentials.servers.first!
        
        XCTAssertEqual(updatedServerInfo.name, server.name)
        XCTAssertEqual(updatedServerInfo.localAddress, server.localAddress)
        XCTAssertEqual(updatedServerInfo.remoteAddress, server.remoteAddress)
        XCTAssertEqual(updatedServerInfo.manualAddress, server.manualAddress)
        XCTAssertEqual(updatedServerInfo.userId, server.userId)
        XCTAssertEqual(updatedServerInfo.accessToken, server.accessToken)
        XCTAssertEqual(updatedServerInfo.wakeOnLanInfos.first!.macAddress, server.wakeOnLanInfos.first!.macAddress)
        XCTAssertEqual(updatedServerInfo.dateLastAccessed, server.dateLastAccessed)
        XCTAssertEqual(updatedServerInfo.exchangeToken, server.exchangeToken)
        XCTAssertEqual(updatedServerInfo.userLinkType, server.userLinkType)
        XCTAssertEqual(updatedServerInfo.name, server.name)
    }

}
