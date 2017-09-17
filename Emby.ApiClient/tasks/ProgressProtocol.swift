//
//  ProgressProtocol.swift
//  Emby.ApiClient
//

import Foundation

public class ProgressProtocol<T> {
    func report(progress: T) {
        onProgress(progress)
    }
    
    func reportComplete() {
        onComplete()
    }
    
    func reportCancelled() {
        onComplete()
    }
    
    func reportError(_ error: Error?) {
        onError(error)
    }
    
    func onProgress(_ progress: T) {
        
    }
    
    func onComplete() {
        
    }
    
    func onCancelled() {
        
    }
    
    func onError(_ error: Error?) {
        
    }
}
