//
//  ServerInfoTests.swift
//  EmbyApiClient
//

import XCTest
@testable import EmbyApiClient

class ServerInfoTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testEqualForSameId() {
        let serverA = ServerInfo()
        serverA.id = "server"
        
        let serverB = ServerInfo()
        serverB.id = "server"
        
        XCTAssertEqual(serverA, serverB)
    }
    
    func testNotEqualForDifferentId() {
        let serverA = ServerInfo()
        serverA.id = "serverA"
        
        let serverB = ServerInfo()
        serverB.id = "serverB"
        
        XCTAssertNotEqual(serverA, serverB)
    }
    
    func testGetAddressLocal() {
        let server = ServerInfo()
        server.localAddress = "localAddress"
        
        XCTAssertEqual("localAddress", server.getAddress(mode: ConnectionMode.Local))
    }
    
    func testGetAddressManual() {
        let server = ServerInfo()
        server.manualAddress = "manualAddress"
        
        XCTAssertEqual("manualAddress", server.getAddress(mode: ConnectionMode.Manual))
    }
    
    func testGetAddressRemote() {
        let server = ServerInfo()
        server.remoteAddress = "remoteAddress"
        
        XCTAssertEqual("remoteAddress", server.getAddress(mode: ConnectionMode.Remote))
    }
    
    func testImportInfo() {
        let publicSystemInfo = PublicSystemInfo(localAddress: "localAddress", wanAddress: "wanAddress", serverName: "serverName", version: "1.0", operatingSystem: "operatingSystem", id: "server")
        
        let server = ServerInfo()
        server.importInfo(systemInfo: publicSystemInfo)
        
        XCTAssertEqual(publicSystemInfo.localAddress, server.localAddress)
        XCTAssertEqual(publicSystemInfo.wanAddress, server.remoteAddress)
    }
    
    func testAddOrUpdateServerAdd() {
        let serverUserInfo = ServerUserInfo(id: "userA", isSignedInOffline: false)
        
        let server = ServerInfo()
        server.addOrUpdate(user: serverUserInfo)
        
        XCTAssertEqual(1, server.users.count)
        XCTAssertTrue(server.users.contains(serverUserInfo))
    }
    
    func testAddOrUpdateServerUpdate() {
        let serverUserInfo = ServerUserInfo(id: "userA", isSignedInOffline: false)
        let server = ServerInfo()
        server.addOrUpdate(user: serverUserInfo)
        
        let updatedServerUserInfo = ServerUserInfo(id: "userA", isSignedInOffline: true)
        server.addOrUpdate(user: updatedServerUserInfo)
        
        let users = server.users
        XCTAssertEqual(1, users.count)
        
        // Ensure the array was updated because we changed the isSignedInOfflineValue
        XCTAssertTrue(users.first!.isSignedInOffline)
    }
}
