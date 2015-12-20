//
//  ServerSelection.swift
//  EmbyApiClient
//
//  Created by Kevin Sullivan on 12/14/15.
//
//

import UIKit

import EmbyApiClient

class ServerSelection: UITableViewController {
    
    var connectionManager: ConnectionManager!
    var servers: [ServerInfo] = []
    
    var connectionResult: ConnectionResult?
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return servers.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let server = servers[indexPath.row]
        
        cell.textLabel?.text = server.name
        cell.detailTextLabel?.text = server.localAddress

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let server = servers[indexPath.row]
        connectToSelectedServer(server)
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let userSelection = segue.destinationViewController as? UserSelection {
            userSelection.connectionResult = connectionResult!
        }
    }
    
    
    // MARK: Server Connection
    
    func connectToSelectedServer(server: ServerInfo) {
        
        connectionManager.connect(server, onSuccess: { (result) -> Void in
            
            if result.state == .ServerSignIn {
                self.connectionResult = result
                self.performSegueWithIdentifier("User Selection", sender: nil)
            } else {
                print("Connection State: \(result.state)")
            }
            
        }, onError: {(error) in
            print("Error connecting: \(error)")
        })
    }
}
