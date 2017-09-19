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
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        connectionManager.createPin(deviceId: appDelegate.device.deviceId, onSuccess: { result in
            self.pinResult = result
            self.pinLabel.text = result.pin
        }, onError: { error in
            self.showFailedConnectionAlert(error: error)
        })
    }
    
    @IBAction func signInButtonTapped(sender: UIBarButtonItem) {
        if let pinResult = pinResult {
            connectionManager.getPinStatus(pin: pinResult, onSuccess: { (result) -> Void in
                
                if result.confirmed {
                    self.exchangePin(pinResult: pinResult)
                }
                
                }, onError: { error in
                    self.showFailedConnectionAlert(error: error)
            })
        }
    }
    
    func showFailedConnectionAlert(error: Error) {
        let alert = UIAlertController(title: "Sign In Failed", message: "\(error)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func exchangePin(pinResult: PinCreationResult) {
        connectionManager.exchangePin(pin: pinResult, onSuccess: { (result) -> Void in
            
            let alert = UIAlertController(title: "Sign In Successful", message: "Sign In was successful.    ", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { (alert) -> Void in
                self.navigationController?.popToRootViewController(animated: true)
            }))
            self.presentpresent(alert, animated: true, completion: nil)
            
        }, onError: { error in
            
            self.showFailedConnectionAlert(error: error)
            
        })
    }

}
