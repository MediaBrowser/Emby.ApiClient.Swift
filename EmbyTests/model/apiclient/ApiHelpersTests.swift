//
//  ApiHelpersTests.swift
//  EmbyApiClient
//

import XCTest
@testable import EmbyApiClient

class ApiHelpersTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSlashesReplacedWithDashes() {
        let name = "/value/"
        
        XCTAssertEqual("-value-", ApiHelpers.getSlugName(name: name))
    }

    func testQuestionMarksReplacedWithDashes() {
        let name = "?value?"
        
        XCTAssertEqual("-value-", ApiHelpers.getSlugName(name: name))
    }
    
    func testAmpersandsReplacedWithDashes() {
        let name = "&value&"
        
        XCTAssertEqual("-value-", ApiHelpers.getSlugName(name: name))
    }
    
    func testAmpersandSlashesQuestionMarksReplacedWithDashes() {
        let name = "/&?value/?&"
        
        XCTAssertEqual("---value---", ApiHelpers.getSlugName(name: name))
    }
}
