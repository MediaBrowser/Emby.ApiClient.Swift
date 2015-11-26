//
//  UserDtoTests.swift
//  EmbyApiClient
//

import XCTest
@testable import EmbyApiClient

class UserDtoTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testUserHasNoPrimaryImage() {
        let userDto = UserDto()
        
        XCTAssertFalse(userDto.hasPrimaryImage)
    }
    
    func testUserHasPrimaryImage() {
        var userDto = UserDto()
        userDto.primaryImageTag = "primaryImageTag"
        
        XCTAssertTrue(userDto.hasPrimaryImage)
    }

}
