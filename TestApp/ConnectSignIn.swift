//
//  ConnectSignIn.swift
//  EmbyApiClient
//
//  Created by Kevin Sullivan on 12/14/15.
//
//

import UIKit

import EmbyApiClient

class ConnectSignIn: UITableViewController {
    
    var connectionManager: ConnectionManager!
    var pinResult: PinCreationResult?
    
    @IBOutlet weak var pinLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        connectionManager.createPin(appDelegate.device.deviceId, onSuccess: { result in
            self.pinResult = result
            self.pinLabel.text = result.pin
        }, onError: { error in
            self.showFailedConnectionAlert(error)
        })
    }
    
    @IBAction func signInButtonTapped(sender: UIBarButtonItem) {
        if let pinResult = pinResult {
            connectionManager.getPinStatus(pinResult, onSuccess: { (result) -> Void in
                
                if result.confirmed {
                    self.exchangePin(pinResult)
                }
                
                }, onError: { error in
                    self.showFailedConnectionAlert(error)
            })
        }
    }
    
    func showFailedConnectionAlert(error: ErrorType) {
        let alert = UIAlertController(title: "Sign In Failed", message: "\(error)", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Continue", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func exchangePin(pinResult: PinCreationResult) {
        connectionManager.exchangePin(pinResult, onSuccess: { (result) -> Void in
            
            let alert = UIAlertController(title: "Sign In Successful", message: "Sign In was successful.    ", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Continue", style: .Default, handler: { (alert) -> Void in
                self.navigationController?.popToRootViewControllerAnimated(true)
            }))
            self.presentViewController(alert, animated: true, completion: nil)
            
        }, onError: { error in
            
            self.showFailedConnectionAlert(error)
            
        })
    }

}
