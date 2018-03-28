//
//  SubtitleProfileTests.swift
//  EmbyApiClient
//

import XCTest
@testable import EmbyApiClient

class SubtitleProfileTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSupportsLanguageTrueOnNilLanguage() {
        let subtitleProfile = SubtitleProfile(format: "format", method: SubtitleDeliveryMethod.Embed, didlMode: "didlMode", language: nil)
        
        XCTAssertTrue(subtitleProfile.supportsLanguage(subLanguage: "english"))
    }
    
    func testSupportsLanguageTrueOnContainingLanguage() {
        let subtitleProfile = SubtitleProfile(format: "format", method: SubtitleDeliveryMethod.Embed, didlMode: "didlMode", language: "english,french,spanish")
        
        XCTAssertTrue(subtitleProfile.supportsLanguage(subLanguage: "french"))
    }
    
    func testSupportsLanguageFalseOnMissingLanguage() {
        let subtitleProfile = SubtitleProfile(format: "format", method: SubtitleDeliveryMethod.Embed, didlMode: "didlMode", language: "english,french,spanish")
        
        XCTAssertFalse(subtitleProfile.supportsLanguage(subLanguage: "german"))
    }
}
