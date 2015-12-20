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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        connectionManager?.connect(onSuccess: { (result) -> Void in
            self.connectionFinished(result)
            }, onError: { (error) -> Void in
                print("Error connecting: \(error)")
        })
    }
    

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let serverSelection = segue.destinationViewController as? ServerSelection {
            serverSelection.servers = sender as! [ServerInfo]
            serverSelection.connectionManager = connectionManager
        }
        else if let userSelection = segue.destinationViewController as? UserSelection {
            userSelection.connectionResult = connectionResult!
        }
        else if let connectSignIn  = segue.destinationViewController as? ConnectSignIn {
            connectSignIn.connectionManager = connectionManager
        }
    }
    
    
    // MARK: - Connection
    
    func connectionFinished(result: ConnectionResult) {
        switch result.state {
        case .ServerSelection:
            performSegueWithIdentifier("Server Selection", sender: result.servers)
        case .ServerSignIn:
            connectionResult = result
            performSegueWithIdentifier("User Selection", sender: nil)
        case .ConnectSignIn:
            performSegueWithIdentifier("Connect Sign In", sender: nil)
        case .SignedIn:
            print("Signed In: \(result)")
        default:
            print("Connection State: \(result.state)")
        }
    }
    
    @IBAction func signOutButtonTapped(sender: UIBarButtonItem) {
        connectionManager.logout({ () -> Void in
            
            }) { () -> Void in
                
        }
    }
}
