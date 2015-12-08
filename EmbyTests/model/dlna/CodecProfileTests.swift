//
//  CodecProfileTests.swift
//  EmbyApiClient
//

import XCTest
@testable import EmbyApiClient

class CodecProfileTests: XCTestCase {
    let conditions = [ProfileCondition(condition: ProfileConditionType.Equals, property: ProfileConditionValue.AudioBitrate, value: "condition")]
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testContainsContainerTrue() {
        let codecProfile = CodecProfile(type: CodecType.Video, conditions: self.conditions, codec: nil, container: "containerA,containerB,containerC")
        
        XCTAssertTrue(codecProfile.containsContainer("containerB"))
    }
    
    func testContainsContainerFalseOnMissingContainer() {
        let codecProfile = CodecProfile(type: CodecType.Video, conditions: self.conditions, codec: nil, container: "containerA,containerB,containerC")
        
        XCTAssertFalse(codecProfile.containsContainer("containerD"))
    }
    
    func testContainsCodecFalseOnMissingContainer() {
        let codecProfile = CodecProfile(type: CodecType.Video, conditions: self.conditions, codec: "codecA,codecB,codecC", container: "containerA,containerB,containerC")
        
        XCTAssertFalse(codecProfile.containsCodec("doesNotMatter", container: "containerD"))
    }
    
    func testContainsCodecTrueOnEmptyCodecs() {
        let codecProfile = CodecProfile(type: CodecType.Video, conditions: self.conditions, codec: nil, container: "containerA,containerB,containerC")
        
        XCTAssertTrue(codecProfile.containsCodec("doesNotMatter", container: "containerB"))
    }
    
    func testContainsCodecTrueOnExistingCodec() {
        let codecProfile = CodecProfile(type: CodecType.Video, conditions: self.conditions, codec: "codecA,codecB,codecC", container: "containerA,containerB,containerC")
        
        XCTAssertTrue(codecProfile.containsCodec("codecB", container: "containerC"))
    }
    
    func testContainsCodecFalseOnMissingCodec() {
        let codecProfile = CodecProfile(type: CodecType.Video, conditions: self.conditions, codec: "codecA,codecB,codecC", container: "containerA,containerB,containerC")
        
        XCTAssertFalse(codecProfile.containsCodec("codecD", container: "containerC"))
    }
}
