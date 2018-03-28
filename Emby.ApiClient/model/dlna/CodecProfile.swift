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
            return splitToArray(stringToSplit: codec, delimiter: ",")
        }
    }
    var containers: [String] {
        get {
            return splitToArray(stringToSplit: container, delimiter: ",")
        }
    }
    
    public func containsContainer(container: String) -> Bool {
        return self.container == nil || containers.contains(where: { $0.lowercased() == container.lowercased()})
    }
    
    public func containsCodec(codec: String, container: String) -> Bool {
        if !containsContainer(container: container) {
            return false
        }
        
        return codecs.isEmpty || codecs.contains(where: { $0.lowercased() == codec.lowercased()})
    }
}
