//
//  StringHelpers.swift
//  EmbyApiClient
//

import Foundation

internal func splitToArray(stringToSplit: String?, delimiter: Character) -> [String] {
    if let toBeSplit = stringToSplit {
        return toBeSplit.characters.split{ $0 == delimiter }.map(String.init).filter({!$0.isEmpty})
    } else {
        return [String]()
    }
}

extension String {
    func sha1() -> String {
        let data = self.data(using: String.Encoding.utf8)!
        var digest = [UInt8](repeating: 0, count:Int(CC_SHA1_DIGEST_LENGTH))
        data.withUnsafeBytes{
            _ = CC_SHA1($0, CC_LONG(data.count), &digest)
        }
        let hexBytes = digest.map{String(format: "%02hhx", $0)}
        return hexBytes.joined()
    }
    
    func md5() -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.deinitialize()
        
        return String( hash)
    }
}
