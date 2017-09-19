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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return servers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let server = servers[indexPath.row]
        
        cell.textLabel?.text = server.name
        cell.detailTextLabel?.text = server.localAddress
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let server = servers[indexPath.row]
        connectToSelectedServer(server: server)
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let userSelection = segue.destination as? UserSelection {
            userSelection.connectionResult = connectionResult!
        }
    }
    
    
    // MARK: Server Connection
    
    func connectToSelectedServer(server: ServerInfo) {
        
        connectionManager.connect(server: server, onSuccess: { (result) -> Void in
            
            if result.state == .ServerSignIn {
                self.connectionResult = result
                self.performSegue(withIdentifier: "User Selection", sender: nil)
            } else {
                print("Connection State: \(result.state)")
            }
            
        }, onError: {(error) in
            print("Error connecting: \(error)")
        })
    }
}
