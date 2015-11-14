//
//  ServerLocator.swift
//  Emby.ApiClient
//
//  Created by Vedran Ozir on 03/11/15.
//  Copyright © 2015 Vedran Ozir. All rights reserved.
//

import Foundation
import CocoaAsyncSocket

//package mediabrowser.apiinteraction.discovery;
//
//import mediabrowser.apiinteraction.Response;
//import mediabrowser.model.apiclient.ServerDiscoveryInfo;
//import mediabrowser.model.logging.ILogger;
//import mediabrowser.model.serialization.IJsonSerializer;
//
//import java.io.IOException;
//import java.net.*;
//import java.util.ArrayList;
//import java.util.Date;
//import java.util.Enumeration;

public class ServerLocator: ServerDiscoveryProtocol, GCDAsyncUdpSocketDelegate {
    
    private let logger: ILogger
    private let jsonSerializer: IJsonSerializer
    
    private var onSuccess: (([ServerDiscoveryInfo]) -> Void)?
    var serverDiscoveryInfo = [ServerDiscoveryInfo]()
    
    public init( logger: ILogger, jsonSerializer: IJsonSerializer) {
        self.logger = logger;
        self.jsonSerializer = jsonSerializer;
    }
    
    // MARK: - GCDAsyncUdpSocketDelegate
    
    /**
     * By design, UDP is a connectionless protocol, and connecting is not needed.
     * However, you may optionally choose to connect to a particular host for reasons
     * outlined in the documentation for the various connect methods listed above.
     *
     * This method is called if one of the connect methods are invoked, and the connection is successful.
     **/
    @objc public func udpSocket(sock: GCDAsyncUdpSocket!, didConnectToAddress address: NSData!) {
        
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
    @objc public func udpSocket(sock: GCDAsyncUdpSocket!, didNotConnect error: NSError!) {
        
        print("didNotConnect")
    }

    
    /**
     * Called when the datagram with the given tag has been sent.
     **/
    @objc public func udpSocket(sock: GCDAsyncUdpSocket!, didSendDataWithTag tag: Int) {
        
        print("didSendDataWithTag")
        do {
            try self.Receive(sock, timeoutMs: UInt(1000), onResponse: { (serverDiscoveryInfo: [ServerDiscoveryInfo]) -> Void in
                
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
    @objc public func udpSocket(sock: GCDAsyncUdpSocket!, didNotSendDataWithTag tag: Int, dueToError error: NSError!) {
        
        print("didNotSendDataWithTag")
    }

    
    /**
     * Called when the socket has received the requested datagram.
     **/
    @objc public func udpSocket(sock: GCDAsyncUdpSocket!, didReceiveData data: NSData!, fromAddress address: NSData!, withFilterContext filterContext: AnyObject!) {
        
        let json = NSString(data: data, encoding: NSUTF8StringEncoding) as? String
        
        // We have a response
        print("ServerLocator >>> Broadcast response from server: \(sock.localAddress())");
        print("ServerLocator >>> Broadcast response from server: \(json)");
        
        do {
            if let serverInfo: ServerDiscoveryInfo = try JsonSerializer().DeserializeFromString( json!, type:nil) {
            
                self.serverDiscoveryInfo.append(serverInfo)
            }
        } catch {
            print("\(error)")
        }
    }

    
    /**
     * Called when the socket is closed.
     **/
    @objc public func udpSocketDidClose(sock: GCDAsyncUdpSocket!, withError error: NSError!) {
        
        print("udpSocketDidClose")
    }
    
    
    // MARK: - utility methods
    
    public func findServers(timeoutMs: Int, onSuccess: ([ServerDiscoveryInfo]) -> Void, onError: (ErrorType) -> Void)
        {
        let udpSocket = GCDAsyncUdpSocket(delegate: self, delegateQueue: dispatch_get_main_queue())
        
        // Find the server using UDP broadcast
            
        do {
            self.onSuccess = onSuccess
            
            try udpSocket.enableBroadcast(true)

            let sendData = "who is EmbyServer?".dataUsingEncoding(NSUTF8StringEncoding);

            //Try the 255.255.255.255 first
            
            let host = "255.255.255.255"
            let port: UInt16 = 7359;
            
            udpSocket.sendData(sendData, toHost: host, port: port, withTimeout: NSTimeInterval(Double(timeoutMs)/1000.0), tag: 1)

            print("ServerLocator >>> Request packet sent to: 255.255.255.255 (DEFAULT)");
            
        } catch {
            print("Error sending DatagramPacket \(error)")
            
            onError(error)
        }
        
//        try {
//            // Broadcast the message over all the network interfaces
//            Enumeration interfaces = NetworkInterface.getNetworkInterfaces();
//            while (interfaces.hasMoreElements()) {
//                NetworkInterface networkInterface = (NetworkInterface)interfaces.nextElement();
//                
//                if (networkInterface.isLoopback() || !networkInterface.isUp()) {
//                    continue; // Don't want to broadcast to the loopback interface
//                }
//                
//                for (InterfaceAddress interfaceAddress : networkInterface.getInterfaceAddresses()) {
//                    InetAddress broadcast = interfaceAddress.getBroadcast();
//                    if (broadcast == null) {
//                        continue;
//                    }
//                    
//                    // Send the broadcast package!
//                    try {
//                        DatagramPacket sendPacket = new DatagramPacket(sendData, sendData.length, broadcast, port);
//                        c.send(sendPacket);
//                    } catch (Exception e) {
//                        logger.ErrorException("Error sending DatagramPacket", e);
//                    }
//                    
//                    logger.Debug(getClass().getName() + ">>> Request packet sent to: " + broadcast.getHostAddress() + "; Interface: " + networkInterface.getDisplayName());
//                }
//            }
//            
//            logger.Debug(getClass().getName() + ">>> Done looping over all network interfaces. Now waiting for a reply!");
//            
//            Receive(c, timeoutMs, response);
//            
//            //Close the port!
//            c.close();
//            
//        } catch (Exception ex) {
//            
//            logger.ErrorException("Error finding servers", ex);
//            
//            response.onError(ex);
//        }
    }
    
    @objc func finished() {
        
        print("Found \(serverDiscoveryInfo.count) servers");
        
        self.onSuccess?(serverDiscoveryInfo)
    }
    
    private func Receive(c: GCDAsyncUdpSocket, timeoutMs: UInt, onResponse: ([ServerDiscoveryInfo]) -> Void) throws { // IOException {
        
//        ArrayList<ServerDiscoveryInfo> servers = new ArrayList<ServerDiscoveryInfo>();
//        ArrayList<String> foundServerIds = new ArrayList<String>();
        
        let timeout = NSTimeInterval(Double(timeoutMs) / 1000.0)
        
        NSTimer.scheduledTimerWithTimeInterval(timeout, target: self, selector: Selector("finished"), userInfo: nil, repeats: false)
        
        do {
            try c.beginReceiving()
        }
        catch {
            print (error)
            //                logger.Debug("Server discovery timed out waiting for response.");
            //                break;
        }
        
//        while (timeout > 0){
//        
//        while (timeoutMs > 0){
//            
//            long startTime = System.currentTimeMillis();
//            
//            // Wait for a response
//            byte[] recvBuf = new byte[15000];
//            DatagramPacket receivePacket = new DatagramPacket(recvBuf, recvBuf.length);
//            c.setSoTimeout((int)timeoutMs);
//            
//            try {
//                c.receive(receivePacket);
//            }
//            catch (SocketTimeoutException e) {
//                logger.Debug("Server discovery timed out waiting for response.");
//                break;
//            }
//            
//            SocketAddress remoteEndpoint = c.getRemoteSocketAddress();
//            
//            // We have a response
//            logger.Debug(getClass().getName() + ">>> Broadcast response from server: " + receivePacket.getAddress().getHostAddress());
//            
//            // Check if the message is correct
//            String message = new String(receivePacket.getData()).trim();
//            
//            logger.Debug(getClass().getName() + ">>> Broadcast response from server: " + message);
//            
//            ServerDiscoveryInfo serverInfo = jsonSerializer.DeserializeFromString(message, ServerDiscoveryInfo.class);
//            
//            if (remoteEndpoint != null){
//                serverInfo.setEndpointAddress(remoteEndpoint.toString());
//            }
//            
//            if (foundServerIds.indexOf(serverInfo.getId()) == -1){
//                foundServerIds.add(serverInfo.getId());
//                servers.add(serverInfo);
//            }
//            
//            long endTime = System.currentTimeMillis();
//            timeoutMs = timeoutMs - (endTime - startTime);
//        }
//        
//        logger.Debug("Found %d servers", servers.size());
//        
//        response.onResponse(servers);
    }
}