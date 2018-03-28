//
//  MediaSourceInfoTests.swift
//  EmbyApiClient
//

import XCTest
@testable import EmbyApiClient

class MediaSourceInfoTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetDefaulAudioStreamByIndex() {
        var subtitleMediaStream = MediaStream()
        subtitleMediaStream.type = MediaStreamType.Subtitle
        subtitleMediaStream.index = 2
        subtitleMediaStream.externalId = "subtitleMediaStream"
        
        var audio1MediaStream = MediaStream()
        audio1MediaStream.type = MediaStreamType.Audio
        audio1MediaStream.index = 1
        audio1MediaStream.externalId = "audio1MediaStream"
        
        var audio2MediaStream = MediaStream()
        audio2MediaStream.type = MediaStreamType.Audio
        audio2MediaStream.index = 2
        audio2MediaStream.externalId = "audio2MediaStream"
        
        var mediaSourceInfo = MediaSourceInfo()
        mediaSourceInfo.mediaStreams = [audio1MediaStream, subtitleMediaStream, audio2MediaStream]
        
        let defaultAudioStream = mediaSourceInfo.getDefaultAudioStream(defaultIndex: 2)
        
        XCTAssertEqual(audio2MediaStream.externalId, defaultAudioStream?.externalId)
    }
    
    func testGetDefaulAudioStreamWhenDefault() {
        var subtitleMediaStream = MediaStream()
        subtitleMediaStream.type = MediaStreamType.Subtitle
        subtitleMediaStream.externalId = "subtitleMediaStream"
        
        var audio1MediaStream = MediaStream()
        audio1MediaStream.type = MediaStreamType.Audio
        audio1MediaStream.isDefault = true
        audio1MediaStream.externalId = "audio1MediaStream"
        
        var audio2MediaStream = MediaStream()
        audio2MediaStream.type = MediaStreamType.Audio
        audio2MediaStream.externalId = "audio2MediaStream"
        
        var mediaSourceInfo = MediaSourceInfo()
        mediaSourceInfo.mediaStreams = [audio1MediaStream, subtitleMediaStream, audio2MediaStream]
        
        let defaultAudioStream = mediaSourceInfo.getDefaultAudioStream(defaultIndex: nil)
        
        XCTAssertEqual(audio1MediaStream.externalId, defaultAudioStream?.externalId)
    }
    
    func testGetDefaulAudioStreamWhenNoDefault() {
        var subtitleMediaStream = MediaStream()
        subtitleMediaStream.type = MediaStreamType.Subtitle
        subtitleMediaStream.externalId = "subtitleMediaStream"
        
        var audio1MediaStream = MediaStream()
        audio1MediaStream.type = MediaStreamType.Audio
        audio1MediaStream.externalId = "audio1MediaStream"
        
        var audio2MediaStream = MediaStream()
        audio2MediaStream.type = MediaStreamType.Audio
        audio2MediaStream.externalId = "audio2MediaStream"
        
        var mediaSourceInfo = MediaSourceInfo()
        mediaSourceInfo.mediaStreams = [audio1MediaStream, subtitleMediaStream, audio2MediaStream]
        
        let defaultAudioStream = mediaSourceInfo.getDefaultAudioStream(defaultIndex: nil)
        
        XCTAssertEqual(MediaStreamType.Audio, defaultAudioStream!.type)
    }
    
    func testVideoStream() {
        var subtitleMediaStream = MediaStream()
        subtitleMediaStream.type = MediaStreamType.Subtitle
        subtitleMediaStream.externalId = "subtitleMediaStream"
        
        var videoMediaStream = MediaStream()
        videoMediaStream.type = MediaStreamType.Video
        videoMediaStream.codec = "mp4"
        videoMediaStream.externalId = "videoMediaStream"
        
        var mediaSourceInfo = MediaSourceInfo()
        mediaSourceInfo.mediaStreams = [subtitleMediaStream, videoMediaStream]
        
        let videoStream = mediaSourceInfo.videoStream!
        
        XCTAssertEqual(videoMediaStream.externalId, videoStream.externalId)
    }
    
    func testVideoStreamNotReturnedWithJpegCodec() {
        var subtitleMediaStream = MediaStream()
        subtitleMediaStream.type = MediaStreamType.Subtitle
        subtitleMediaStream.externalId = "subtitleMediaStream"
 
        var jpegVideoStream = MediaStream()
        jpegVideoStream.type = MediaStreamType.Video
        jpegVideoStream.codec = "jpeg"
        jpegVideoStream.externalId = "jpegVideoStream"
        
        var videoMediaStream = MediaStream()
        videoMediaStream.type = MediaStreamType.Video
        videoMediaStream.codec = "mp4"
        videoMediaStream.externalId = "videoMediaStream"
        
        var mediaSourceInfo = MediaSourceInfo()
        mediaSourceInfo.mediaStreams = [subtitleMediaStream, jpegVideoStream, videoMediaStream]
        
        let videoStream = mediaSourceInfo.videoStream!
        
        XCTAssertEqual(videoMediaStream.externalId, videoStream.externalId)
        XCTAssertNotEqual("jpeg", videoStream.codec)
    }
    
    func testMediaStreamCount() {
        var subtitleMediaStream = MediaStream()
        subtitleMediaStream.type = MediaStreamType.Subtitle
        subtitleMediaStream.externalId = "subtitleMediaStream"
        
        var audio1MediaStream = MediaStream()
        audio1MediaStream.type = MediaStreamType.Audio
        audio1MediaStream.externalId = "audio1MediaStream"
        
        var audio2MediaStream = MediaStream()
        audio2MediaStream.type = MediaStreamType.Audio
        audio2MediaStream.externalId = "audio2MediaStream"
        
        var mediaSourceInfo = MediaSourceInfo()
        mediaSourceInfo.mediaStreams = [audio1MediaStream, subtitleMediaStream, audio2MediaStream]
        
        XCTAssertEqual(2, mediaSourceInfo.getStreamCount(type: MediaStreamType.Audio))
        XCTAssertEqual(1, mediaSourceInfo.getStreamCount(type: MediaStreamType.Subtitle))
        XCTAssertEqual(0, mediaSourceInfo.getStreamCount(type: MediaStreamType.EmbeddedImage))

    }
    
    func testGetMediaStreamByTypeAndIndex() {
        var subtitleMediaStream = MediaStream()
        subtitleMediaStream.type = MediaStreamType.Subtitle
        subtitleMediaStream.index = 2
        subtitleMediaStream.externalId = "subtitleMediaStream"
        
        var audio1MediaStream = MediaStream()
        audio1MediaStream.type = MediaStreamType.Audio
        audio1MediaStream.index = 1
        audio1MediaStream.externalId = "audio1MediaStream"
        
        var audio2MediaStream = MediaStream()
        audio2MediaStream.type = MediaStreamType.Audio
        audio2MediaStream.index = 2
        audio2MediaStream.externalId = "audio2MediaStream"
        
        var mediaSourceInfo = MediaSourceInfo()
        mediaSourceInfo.mediaStreams = [audio1MediaStream, subtitleMediaStream, audio2MediaStream]
        
        let defaultAudioStream = mediaSourceInfo.getMediaStream(type: MediaStreamType.Audio, index: 2)
        
        XCTAssertEqual(audio2MediaStream.externalId, defaultAudioStream?.externalId)
    }
    
    func testIsSecondaryAudioStream() {
        var subtitleMediaStream = MediaStream()
        subtitleMediaStream.type = MediaStreamType.Subtitle
        subtitleMediaStream.index = 2
        subtitleMediaStream.externalId = "subtitleMediaStream"
        
        var audio1MediaStream = MediaStream()
        audio1MediaStream.type = MediaStreamType.Audio
        audio1MediaStream.index = 1
        audio1MediaStream.externalId = "audio1MediaStream"
        
        var audio2MediaStream = MediaStream()
        audio2MediaStream.type = MediaStreamType.Audio
        audio2MediaStream.index = 2
        audio2MediaStream.externalId = "audio2MediaStream"
        
        var mediaSourceInfo = MediaSourceInfo()
        mediaSourceInfo.mediaStreams = [audio1MediaStream, subtitleMediaStream]
        
        XCTAssertTrue(mediaSourceInfo.isSecondaryAudio(stream: audio2MediaStream))
        XCTAssertFalse(mediaSourceInfo.isSecondaryAudio(stream: audio1MediaStream))
    }
}
