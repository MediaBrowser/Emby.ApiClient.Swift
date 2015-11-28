//
//  StudioDtoTests.swift
//  EmbyApiClient
//

import XCTest
@testable import EmbyApiClient

class StudioDtoTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testBaseItemPersonHasNoPrimaryImage() {
        let studioDto = StudioDto(name: "name", id: "id", primaryImageTag: nil)
        
        XCTAssertFalse(studioDto.hasPrimaryImage)
    }
    
    func testBaseItemPersonHasPrimaryImage() {
        let studioDto = StudioDto(name: "name", id: "id", primaryImageTag: "primaryImageTag")
        
        XCTAssertTrue(studioDto.hasPrimaryImage)
    }
}
