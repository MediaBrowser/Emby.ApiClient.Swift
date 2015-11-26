//
//  ServerUserInfoTests.swift
//  EmbyApiClient
//

import XCTest
@testable import EmbyApiClient

class ServerUserInfoTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testEqualForSameId() {
        let serverA = ServerUserInfo(id: "server", isSignedInOffline: false)
        let serverB = ServerUserInfo(id: "server", isSignedInOffline: true)
        
        XCTAssertEqual(serverA, serverB)
    }
    
    func testNotEqualForDifferentId() {
        let serverA = ServerUserInfo(id: "serverA", isSignedInOffline: false)
        let serverB = ServerUserInfo(id: "serverB", isSignedInOffline: false)
        
        XCTAssertNotEqual(serverA, serverB)
    }
}
