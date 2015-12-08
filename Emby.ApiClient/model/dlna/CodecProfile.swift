//
//  CodecProfile.swift
//  EmbyApiClient
//

import Foundation

public struct CodecProfile {
    var type = CodecType.Video
    var conditions = [ProfileCondition]()
    let codec: String?
    let container: String?
    var codecs: [String] {
        get {
            return splitToArray(codec, delimiter: ",")
        }
    }
    var containers: [String] {
        get {
            return splitToArray(container, delimiter: ",")
        }
    }
    
    public func containsContainer(container: String) -> Bool {
        return self.container == nil || containers.contains({ $0.lowercaseString == container.lowercaseString})
    }
    
    public func containsCodec(codec: String, container: String) -> Bool {
        if !containsContainer(container) {
            return false
        }
        
        return codecs.isEmpty || codecs.contains({ $0.lowercaseString == codec.lowercaseString})
    }
}