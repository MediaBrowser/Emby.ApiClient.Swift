//
//  BoolHelpersTests.swift
//  EmbyApiClient
//

import XCTest
@testable import EmbyApiClient

class BoolHelpersTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testThatOneReturnsTrue() {
        XCTAssertTrue(Bool(1))
    }

    func testThatGreaterThanOneReturnsFalse() {
        XCTAssertFalse(Bool(2))
    }
    
    func testThatZeroReturnsFalse() {
        XCTAssertFalse(Bool(0))
    }
    
    func testThatLessThanZeroReturnsFalse() {
        XCTAssertFalse(Bool(-1))
    }
}
