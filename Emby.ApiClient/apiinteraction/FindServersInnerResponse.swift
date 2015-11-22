//
//  FindServersInnerResponse.swift
//  Emby.ApiClient
//
//  Created by Vedran Ozir on 05/11/15.
//  Copyright © 2015 Vedran Ozir. All rights reserved.
//

import Foundation

//package mediabrowser.apiinteraction.connectionmanager;
//
//import mediabrowser.apiinteraction.Response;
//import mediabrowser.model.apiclient.ServerDiscoveryInfo;
//import mediabrowser.model.apiclient.ServerInfo;
//import mediabrowser.model.extensions.IntHelper;
//
//import java.util.ArrayList;

public class FindServersInnerResponse: EmbyApiClient.Response<Array<ServerDiscoveryInfo>> {

    private let connectionManager: ConnectionManager
    private let response: EmbyApiClient.Response<Array<ServerInfo>>
    
    public init(connectionManager: ConnectionManager, response: EmbyApiClient.Response<Array<ServerInfo>>) {
        self.connectionManager = connectionManager;
        self.response = response;
        
        super.init()
    }
    
//    @Override
//    public void onResponse(ArrayList<ServerDiscoveryInfo> foundServers) {
//        
//        ArrayList<ServerInfo> servers = new ArrayList<ServerInfo>();
//        
//        for (int i = 0; i < foundServers.size(); i++) {
//            
//            ServerInfo server = new ServerInfo();
//            ServerDiscoveryInfo foundServer = foundServers.get(i);
//            
//            server.setId(foundServer.getId());
//            server.setLocalAddress(foundServer.getAddress());
//            server.setName(foundServer.getName());
//            
//            server.setManualAddress(ConvertEndpointAddressToManualAddress(foundServer));
//            
//            servers.add(server);
//        }
//        
//        response.onResponse(servers);
//    }
//    
//    @Override
//    public void onError(Exception ex) {
//        
//        Array<ServerInfo> servers = new Array<ServerInfo>();
//        
//        response.onResponse(servers);
//    }
//    
//    private String ConvertEndpointAddressToManualAddress(ServerDiscoveryInfo info)
//    {
//        if (!tangible.DotNetToJavaStringHelper.isNullOrEmpty(info.getAddress()) && !tangible.DotNetToJavaStringHelper.isNullOrEmpty(info.getEndpointAddress()))
//        {
//            String address = info.getEndpointAddress().split(":")[0];
//            
//            // Determine the port, if any
//            String[] parts = info.getAddress().split(":");
//            if (parts.length > 1)
//            {
//                String portString = parts[parts.length-1];
//                
//                int port = 0;
//                tangible.RefObject<Integer> tempRef_expected = new tangible.RefObject<Integer>(port);
//                if (IntHelper.TryParseCultureInvariant(portString, tempRef_expected))
//                {
//                    address += ":" + portString;
//                }
//            }
//            
//            return connectionManager.NormalizeAddress(address);
//        }
//        
//        return null;
//    }
}