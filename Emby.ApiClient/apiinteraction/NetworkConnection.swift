//
//  NetworkConnection.swift
//  EmbyApiClient
//
//  Created by Kevin Sullivan on 12/11/15.
//
//

import Foundation
import CocoaAsyncSocket

public class NetworkConnection: NSObject, INetworkConnection, GCDAsyncUdpSocketDelegate {
    
    
    public func sendWakeOnLan(macAddress: String, port: Int) {
        let bytes = macBytesFromString(macAddress: macAddress)!
        let data = NSData(bytes: bytes, length: bytes.count)
        
        let udpSocket = GCDAsyncUdpSocket(delegate: self, delegateQueue: DispatchQueue.main)
        
        do {
            try udpSocket.enableBroadcast(true)
            
            let host = "255.255.255.255"
            udpSocket.send(data as Data, toHost: host, port: UInt16(port), withTimeout: 2, tag: 1)
            
            print("sendWakeOnLan send to 255.255.255.255")
            
        } catch {
            print("Error sending sendWakeOnLan packet: \(error)")
        }
    }
    
    public func sendWakeOnLan(macAddress: String, ipAddress: String, port: Int) {
        let bytes = macBytesFromString(macAddress: macAddress)!
        let data = NSData(bytes: bytes, length: bytes.count)
        
        let udpSocket = GCDAsyncUdpSocket(delegate: self, delegateQueue: DispatchQueue.main)
        
        udpSocket.send(data as Data, toHost: ipAddress, port: UInt16(port), withTimeout: 2, tag: 2)
        
        print("sendWakeOnLan send to \(ipAddress)")
    }
  
    public func getNetworkStatus() -> NetworkStatus {
        return NetworkStatus(networkAvailable: true, localNetworkAvailable: true)
    }
    
    private func macBytesFromString(macAddress: String) -> [UInt8]? {
        let address = "01:23:45:67:89:AB"
        let substrings = address.characters.split(separator: ":")
        
        if substrings.count != 6 {
            return nil
        }
        
        var bytes: [UInt8] = []
        for substring in substrings {
            if let byte = UInt8(String(substring), radix: 16) {
                bytes.append(byte)
            }
            else {
                return nil
            }
        }
        
        
        
        return bytes
    }
    
    // MARK: - GCDAsyncUdpSocketDelegate
    
    /**
    * Called when the datagram with the given tag has been sent.
    **/
    @objc public func udpSocket(sock: GCDAsyncUdpSocket!, didSendDataWithTag tag: Int) {
        print("didSendDataWithTag")
    }
    
    
    /**
     * Called if an error occurs while trying to send a datagram.
     * This could be due to a timeout, or something more serious such as the data being too large to fit in a sigle packet.
     **/
    @objc public func udpSocket(sock: GCDAsyncUdpSocket!, didNotSendDataWithTag tag: Int, dueToError error: NSError!) {
        print("didNotSendDataWithTag")
    }
    
    
    /**
     * Called when the socket has received the requested datagram.
     **/
    @objc public func udpSocket(sock: GCDAsyncUdpSocket!, didReceiveData data: NSData!, fromAddress address: NSData!, withFilterContext filterContext: AnyObject!) {
        
        print("didReceiveData: \(data) fromAddress: \(address)")
    }
    
    
    /**
     * Called when the socket is closed.
     **/
    @objc public func udpSocketDidClose(sock: GCDAsyncUdpSocket!, withError error: NSError!) {
        print("udpSocketDidClose")
    }
}
