//
//  Startup.swift
//  EmbyApiClient
//
//  Created by Kevin Sullivan on 12/18/15.
//
//

import UIKit

import EmbyApiClient

class Startup: UIViewController {
    
    var connectionManager: ConnectionManager!
    
    var connectionResult: ConnectionResult?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)        
        connectionManager?.connect(onSuccess: { (result) -> Void in
            self.connectionFinished(result: result)
            }, onError: { (error) -> Void in
                print("Error connecting: \(error)")
        })
    }
    

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let serverSelection = segue.destination as? ServerSelection {
            serverSelection.servers = sender as! [ServerInfo]
            serverSelection.connectionManager = connectionManager
        }
        else if let userSelection = segue.destination as? UserSelection {
            userSelection.connectionResult = connectionResult!
        }
        else if let connectSignIn  = segue.destination as? ConnectSignIn {
            connectSignIn.connectionManager = connectionManager
        }
    }
    
    
    // MARK: - Connection
    
    func connectionFinished(result: ConnectionResult) {
        switch result.state {
        case .ServerSelection:
            performSegue(withIdentifier: "Server Selection", sender: result.servers)
        case .ServerSignIn:
            connectionResult = result
            performSegue(withIdentifier: "User Selection", sender: nil)
        case .ConnectSignIn:
            performSegue(withIdentifier: "Connect Sign In", sender: nil)
        case .SignedIn:
            print("Signed In: \(result)")
        default:
            print("Connection State: \(result.state)")
        }
    }
    
    @IBAction func signOutButtonTapped(sender: UIBarButtonItem) {
        connectionManager.logout(onSuccess: { () -> Void in
            
            }) { () -> Void in
                
        }
    }
}
