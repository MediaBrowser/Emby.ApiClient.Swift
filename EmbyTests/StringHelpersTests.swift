//
//  StringHelpersTests.swift
//  EmbyApiClient
//

import XCTest
@testable import EmbyApiClient

class StringHelpersTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testStringSplitByDelimiter() {
        let stringArray = splitToArray(stringToSplit: "a,b,c", delimiter: ",")
        
        XCTAssertEqual(3, stringArray.count)
    }
    
    func testEmptyArrayOnNilStringToSplit() {
        let stringArray = splitToArray(stringToSplit: nil, delimiter: ",")
        
        XCTAssertEqual(0, stringArray.count)
    }
    
    func testNoEmptyStringOnSequentialCommas() {
        let stringArray = splitToArray(stringToSplit: ",,a,b,c,,", delimiter: ",")
        
        XCTAssertEqual(3, stringArray.count)
    }
}
