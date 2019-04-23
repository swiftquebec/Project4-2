//
//  TableViewController.swift
//  Project4
//
//  Created by Gregory Leck on 2019-04-22.
//  Copyright © 2019 Gregory Leck. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    // List of safe websites
    var websites: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "List of Websites"
        
        let listOfSafeWebsites = SafeWebSites()
        websites = listOfSafeWebsites.safeWebsites
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WebsiteToSelect", for: indexPath)
        cell.textLabel?.text = websites[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "WebView") as? ViewController {
       
            vc.initialWebsite = websites[indexPath.row]
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
