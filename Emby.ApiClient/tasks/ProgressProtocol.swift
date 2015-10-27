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
    
    func reportError(error: NSError?) {
        onError(error)
    }
    
    func onProgress(progress: T) {
        
    }
    
    func onComplete() {
        
    }
    
    func onCancelled() {
        
    }
    
    func onError(error: NSError?) {
        
    }
}