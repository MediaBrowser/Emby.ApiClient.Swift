//
//  AppDelegate.swift
//  TestApp
//
//  Created by Vedran Ozir on 12/10/15.
//  Copyright © 2015 Vedran Ozir. All rights reserved.
//

import UIKit
import EmbyApiClient

var connectionManager: ConnectionManager?

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var timerFor_GetPinStatus: NSTimer?
    
    var deviceId: String?
    var pin: String?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.

        let logger = Logger()
        
        let httpClient = VolleyHttpClient(logger: logger, context: Context())
        
        let jsonSerializer = JsonSerializer()
        
        let connectService = ConnectService(jsonSerializer: jsonSerializer, logger: logger, httpClient: httpClient, appName: "Emby_ApiClient iOS", appVersion: "1.0")
        
//        Authenticate(httpClient, logger: logger, jsonSerializer: jsonSerializer, service: connectService)

        let clientCapabilities = ClientCapabilities()
        let credentialProvider = CredentialProvider(jsonSerializer: jsonSerializer, filePath: "")
        let device = iOSDevice()
        let serverDiscovery = ServerLocator(logger: logger, jsonSerializer: jsonSerializer)
        
        connectionManager = ConnectionManager(clientCapabilities: clientCapabilities,
            credentialProvider: credentialProvider,
            device: device,
            serverDiscovery: serverDiscovery,
            connectService: connectService)
        
        connectionManager?.getAvailableServers({ (serverInfo: [ServerInfo]) -> Void in
            
            print("connectionManager?.getAvailableServers() returns: \(serverInfo)")
            
            }) { (ErrorType) -> Void in
                
        }
        
        return true
    }

    func Authenticate(httpClient: VolleyHttpClient, logger: Logger, jsonSerializer: JsonSerializer, service: ConnectService) {
        
        let response = EmbyApiClient.Response<ConnectAuthenticationResult>()

        let test_CreatePin = false
        let test_GetPinStatus = false
        let test_GetRegistrationInfo = false
        let test_GetConnectUser = false
        let test_GetServers = true
        
        response.completion = { (result: ConnectAuthenticationResult?) -> Void in
            
            print("Authenticate finished with \(result) \(result?.getAccessToken())")
            
            if let
                userId = result?.getUser()?.getId(),
                connectAccessToken = result?.getAccessToken() {
            
                    let deviceId = UIDevice.currentDevice().identifierForVendor?.UUIDString ?? "<<unknown device>>"
                    let pin = "09751"

                    if test_GetServers {
                        
                        self.GetServers(userId, connectAccessToken: connectAccessToken, httpClient: httpClient, logger: logger, jsonSerializer: jsonSerializer, service: service)
                    }
                    
                    if test_CreatePin {
                        self.CreatePin(deviceId, httpClient: httpClient, logger: logger, jsonSerializer: jsonSerializer, service: service)
                    }
                    
                    if test_GetPinStatus {

                        self.deviceId = deviceId
                        self.pin = pin
                        
                        self.timerFor_GetPinStatus = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: Selector("GetPinStatus"), userInfo: nil, repeats: true)
                    }
                    
//                    self.ExchangePin(deviceId, pin: pin, httpClient: httpClient, logger: logger, jsonSerializer: jsonSerializer, service: service)
                    
//                self.Logout(connectAccessToken, httpClient: httpClient, logger: logger, jsonSerializer: jsonSerializer, service: service)
  
                    if test_GetRegistrationInfo {
                        
                        let feature = "TV"
                        
                        self.GetRegistrationInfo(userId, connectAccessToken: connectAccessToken, feature: feature, httpClient: httpClient, logger: logger, jsonSerializer: jsonSerializer, service: service)
                    }
                    
                    if test_GetConnectUser {
                        
                        self.GetConnectUser(userId, connectAccessToken: connectAccessToken, httpClient: httpClient, logger: logger, jsonSerializer: jsonSerializer, service: service)
                    }
            }
            
        }
        
        service.Authenticate("vedrano", password: "123456", response: response)
    }
    
    func GetServers(userId: String, connectAccessToken: String, httpClient: VolleyHttpClient, logger: Logger, jsonSerializer: JsonSerializer, service: ConnectService) {
        
        let response = EmbyApiClient.Response<ConnectUserServers>()
        
        response.completion = { (result: ConnectUserServers?) -> Void in
            
            print("GetServers finished with \(result))")
            
        }
        
        print("response \(response)")
        
        do {
            try service.GetServers(userId, connectAccessToken: connectAccessToken, final: response)
        } catch {
            print("error \(error)")
        }
    }
    
    func GetConnectUser(userId: String, connectAccessToken: String, httpClient: VolleyHttpClient, logger: Logger, jsonSerializer: JsonSerializer, service: ConnectService) {
        
        let response = EmbyApiClient.Response<ConnectUser>()
        
        let connectUserQuery = ConnectUserQuery(jSON: JSON_Object())
        
        connectUserQuery.setId(userId)
        
        response.completion = { (result: ConnectUser?) -> Void in
            
            print("GetConnectUser finished with \(result))")
            
        }
        
        print("response \(response)")
        
        do {
            try service.GetConnectUser(connectUserQuery, connectAccessToken: connectAccessToken, final: response)
        } catch {
            print("error \(error)")
        }
    }
    
    func GetRegistrationInfo(userId: String, connectAccessToken: String, feature: String, httpClient: VolleyHttpClient, logger: Logger, jsonSerializer: JsonSerializer, service: ConnectService) {
        
        let response = EmbyApiClient.Response<RegistrationInfo>()
        
        response.completion = { (result: RegistrationInfo?) -> Void in
            
            print("GetRegistrationInfo finished with \(result))")
        }
        
        print("response \(response)")
        
        do {
            try service.GetRegistrationInfo(userId, feature: feature, connectAccessToken: connectAccessToken, final: response)
        } catch {
            print("error \(error)")
        }
    }

    func GetPinStatus() {
        
        let logger = Logger()
        
        let httpClient = VolleyHttpClient(logger: logger, context: Context())
        
        let jsonSerializer = JsonSerializer()
        
        let service = ConnectService(jsonSerializer: jsonSerializer, logger: logger, httpClient: httpClient, appName: "Emby_ApiClient iOS", appVersion: "1.0")
        
        if let
            deviceId = self.deviceId,
            pin = self.pin {
                
                self.GetPinStatus(deviceId, pin: pin, httpClient: httpClient, logger: logger, jsonSerializer: jsonSerializer, service: service)
        }
    }
    
    func CreatePin(deviceId: String, httpClient: VolleyHttpClient, logger: Logger, jsonSerializer: JsonSerializer, service: ConnectService) {
        
        let response = EmbyApiClient.Response<PinCreationResult>()
        
        response.completion = { (result: PinCreationResult?) -> Void in
            
            print("CreatePin finished with \(result))")
            
        }
        
        print("response \(response)")
        
        service.CreatePin(deviceId, final: response)
    }
    
    func GetPinStatus(deviceId: String, pin: String, httpClient: VolleyHttpClient, logger: Logger, jsonSerializer: JsonSerializer, service: ConnectService) {
        
        let response = EmbyApiClient.Response<PinStatusResult>()
        
        let pinCreationResult = PinCreationResult(jSON: JSON_Object())
        
        pinCreationResult.setDeviceId(deviceId)
        pinCreationResult.setPin(pin)
        
        response.completion = { (result: PinStatusResult?) -> Void in
            
            print("GetPinStatus finished with \(result))")
            
            if result?.getIsConfirmed() == true {
                
                print("stop GetPinStatus timer")
                
                self.timerFor_GetPinStatus?.invalidate()
                
                self.timerFor_GetPinStatus = nil
            }
            
        }
        
        print("response \(response)")
        
        service.GetPinStatus(pinCreationResult, final: response)
    }
    
    func ExchangePin(deviceId: String, pin: String, httpClient: VolleyHttpClient, logger: Logger, jsonSerializer: JsonSerializer, service: ConnectService) {
        
        let response = EmbyApiClient.Response<PinExchangeResult>()
        
        let pinCreationResult = PinCreationResult(jSON: JSON_Object())
        
        pinCreationResult.setDeviceId(deviceId)
        pinCreationResult.setPin(pin)
        
        response.completion = { (result: PinExchangeResult?) -> Void in
            
            print("ExchangePin finished with \(result))")
            
        }
        
        print("response \(response)")
        
        service.ExchangePin(pinCreationResult, final: response)
    }

    func Logout(connectAccessToken: String, httpClient: VolleyHttpClient, logger: Logger, jsonSerializer: JsonSerializer, service: ConnectService) {
        
        let response = EmbyApiClient.Response<EmptyResponse>()
        
        response.completion = { (result: EmptyResponse?) -> Void in
            
            print("Logout finished with \(result))")
        }
        response.completionError = { (error) in
            
            print("response error \(error)")
        }
        
        print("response \(response)")
        
        do {
            try service.Logout(connectAccessToken, final: response)
        } catch {
            print("error \(error)")
        }
    }
    
}

