//
//  SignIn.swift
//  EmbyApiClient
//
//  Created by Kevin Sullivan on 12/14/15.
//
//

import UIKit

import EmbyApiClient

class SignIn: UITableViewController {
    
    var apiClient: ApiClient!
    var userName: String?
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let userName = userName {
            usernameField.text = userName
        }
    }
    
    @IBAction func signInButtonTapped(sender: UIBarButtonItem) {
        apiClient.authenticateUserAsync(username: usernameField.text!, password: passwordField.text ?? "", success: { (result) -> Void in
            
            let alert = UIAlertController(title: "Authentication Successful", message: "Access Token: \(result.accessToken)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            }, failure: { (error) -> Void in
                
                let alert = UIAlertController(title: "Sign In Failed", message: "\(error)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
        })
    }
}
