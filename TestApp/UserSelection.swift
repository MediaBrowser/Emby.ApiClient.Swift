//
//  UserSelection.swift
//  EmbyApiClient
//
//  Created by Kevin Sullivan on 12/17/15.
//
//

import UIKit

import EmbyApiClient

class UserSelection: UITableViewController {
    
    var users: [UserDto] = []
    
    var connectionResult: ConnectionResult!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = connectionResult.servers[0].name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkServerForUsers()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let user = users[indexPath.row]
        
        cell.textLabel?.text = user.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let user = users[indexPath.row]
        
        performSegue(withIdentifier: "Sign In", sender: user.name!)
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let signIn = segue.destination as? SignIn, let userName = sender as? String {
            signIn.apiClient = connectionResult.apiClient!
            signIn.userName = userName
        }
    }
    
    func checkServerForUsers() {
        let apiClient = connectionResult.apiClient!
        
        apiClient.getPublicUsersAsync(success: { users in
            self.users = users
            self.tableView.reloadData()
        }, failure: { error in
            print("error: \(error)")
        })
    }
}
