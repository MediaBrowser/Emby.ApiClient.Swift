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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        checkServerForUsers()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let user = users[indexPath.row]
        
        cell.textLabel?.text = user.name

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let user = users[indexPath.row]
        
        performSegueWithIdentifier("Sign In", sender: user.name!)
    }


    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let signIn = segue.destinationViewController as? SignIn, let userName = sender as? String {
            signIn.apiClient = connectionResult.apiClient!
            signIn.userName = userName
        }
    }
    
    func checkServerForUsers() {
        let apiClient = connectionResult.apiClient!
        
        apiClient.getPublicUsersAsync({ users in
            self.users = users
            self.tableView.reloadData()
        }, failure: { error in
            print("error: \(error)")
        })
    }
}
