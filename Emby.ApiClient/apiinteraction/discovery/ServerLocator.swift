//
//  ServerLocator.swift
//  Emby.ApiClient
//
//  Created by Vedran Ozir on 03/11/15.
//  Copyright © 2015 Vedran Ozir. All rights reserved.
//

import Foundation
import CocoaAsyncSocket

public class ServerLocator: NSObject, ServerDiscoveryProtocol, GCDAsyncUdpSocketDelegate {
    
    private let logger: ILogger
    private let jsonSerializer: IJsonSerializer
    
    private var onSuccess: (([ServerDiscoveryInfo]) -> Void)?
    var serverDiscoveryInfo: Set<ServerDiscoveryInfo> = []
    
    public init( logger: ILogger, jsonSerializer: IJsonSerializer) {
        self.logger = logger;
        self.jsonSerializer = jsonSerializer;
    }
    
    
    // MARK: - utility methods
    
    public func findServers(timeoutMs: Int, onSuccess: @escaping ([ServerDiscoveryInfo]) -> Void, onError: @escaping (Error) -> Void)
    {
        let udpSocket = GCDAsyncUdpSocket(delegate: self, delegateQueue: DispatchQueue.main)
        
        /*do
        {
            try udpSocket.bind(toPort: 7359)
        }
        
        catch let error
        {
            print("Error binding: \(error)")
        }
        
        do
        {
            try udpSocket.beginReceiving()
        }
        
        catch let error{
            print("Error receiving: \(error)")
        }*/
        
        // Find the server using UDP broadcast
        
        do {
            self.onSuccess = onSuccess
            
            try udpSocket.enableBroadcast(true)
            
            let sendData = "who is EmbyServer?".data(using: String.Encoding.utf8);
            let host = "255.255.255.255"
            let port: UInt16 = 7359;
            
            udpSocket.send(sendData!, toHost: host, port: port, withTimeout: TimeInterval(Double(timeoutMs)/1000.0), tag: 1)
            
            print("ServerLocator >>> Request packet sent to: 255.255.255.255 (DEFAULT)");
            
        } catch {
            print("Error sending DatagramPacket \(error)")
            
            onError(error)
        }
    }
    
    @objc func finished() {
        
        print("Found \(serverDiscoveryInfo.count) servers");
        
        self.onSuccess?(Array(serverDiscoveryInfo))
    }
    
    private func Receive(c: GCDAsyncUdpSocket, timeoutMs: UInt, onResponse: @escaping ([ServerDiscoveryInfo]) -> Void) throws {
        
        serverDiscoveryInfo = []
        let timeout = TimeInterval(Double(timeoutMs) / 1000.0)
        
        Timer.scheduledTimer(timeInterval: timeout, target: self, selector: #selector(ServerLocator.finished), userInfo: nil, repeats: false)
        
        do {
            try c.beginReceiving()
        }
        catch {
            print (error)
        }
    }
    
    
    // MARK: - GCDAsyncUdpSocketDelegate
    
    /**
    * By design, UDP is a connectionless protocol, and connecting is not needed.
    * However, you may optionally choose to connect to a particular host for reasons
    * outlined in the documentation for the various connect methods listed above.
    *
    * This method is called if one of the connect methods are invoked, and the connection is successful.
    **/
    @objc public func udpSocket(_ sock: GCDAsyncUdpSocket, didConnectToAddress address: Data) {
        
        print("didConnectToAddress")
    }
    
    
    /**
     * By design, UDP is a connectionless protocol, and connecting is not needed.
     * However, you may optionally choose to connect to a particular host for reasons
     * outlined in the documentation for the various connect methods listed above.
     *
     * This method is called if one of the connect methods are invoked, and the connection fails.
     * This may happen, for example, if a domain name is given for the host and the domain name is unable to be resolved.
     **/
    @objc public func udpSocket(_ sock: GCDAsyncUdpSocket, didNotConnect error: Error?) {
        
        print("didNotConnect")
    }
    
    
    /**
     * Called when the datagram with the given tag has been sent.
     **/
    @objc public func udpSocket(_ sock: GCDAsyncUdpSocket, didSendDataWithTag tag: Int) {
        
        print("didSendDataWithTag")
        do {
            try self.Receive(c: sock, timeoutMs: UInt(1000), onResponse: { (serverDiscoveryInfo: [ServerDiscoveryInfo]) -> Void in
                
                print("serverDiscoveryInfo \(serverDiscoveryInfo)")
            })
        } catch {
            print("\(error)")
        }
    }
    
    
    /**
     * Called if an error occurs while trying to send a datagram.
     * This could be due to a timeout, or something more serious such as the data being too large to fit in a sigle packet.
     **/
    @objc public func udpSocket(_ sock: GCDAsyncUdpSocket, didNotSendDataWithTag tag: Int, dueToError error: Error?) {
        
        print("didNotSendDataWithTag")
    }
    
    
    /**
     * Called when the socket has received the requested datagram.
     **/
    @objc public func udpSocket(_ sock: GCDAsyncUdpSocket, didReceive data: Data, fromAddress address: Data, withFilterContext filterContext: Any?) {
        
        let json = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue) as String?
        
        // We have a response
        print("ServerLocator >>> Broadcast response from server: \(String(describing: sock.localAddress())): \(String(describing: json))")
        
        do {
            if let serverInfo: ServerDiscoveryInfo = try JsonSerializer().DeserializeFromString( text: json!, type:nil) {
                
                self.serverDiscoveryInfo.insert(serverInfo)
            }
        } catch {
            print("\(error)")
        }
    }
    
    
    /**
     * Called when the socket is closed.
     **/
    @objc public func udpSocketDidClose(_ sock: GCDAsyncUdpSocket, withError error: Error?) {
        
        print("udpSocketDidClose")
    }
}
