//
//  BaseItemPersonTests.swift
//  EmbyApiClient
//

import XCTest
@testable import EmbyApiClient

class BaseItemPersonTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testBaseItemPersonHasNoPrimaryImage() {
        let baseItemPerson = BaseItemPerson(name: "name", role: "role", type: "type")
        
        XCTAssertFalse(baseItemPerson.hasPrimaryImage)
    }
    
    func testBaseItemPersonHasPrimaryImage() {
        let baseItemPerson = BaseItemPerson(name: "name", role: "role", type: "type")
        baseItemPerson.primaryImageTag = "primaryImageTag"
        
        XCTAssertTrue(baseItemPerson.hasPrimaryImage)
    }
}
