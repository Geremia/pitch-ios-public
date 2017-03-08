//
//  SessionsTableViewController.swift
//  Pitch
//
//  Created by Daniel Kuntz on 3/2/17.
//  Copyright © 2017 Plutonium Apps. All rights reserved.
//

import UIKit

class SessionsTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var sessions: [Session] = []
    var expandedCellIndex: Int?
    
    // MARK: - Setup Views

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        reloadData()
    }
    
    func reloadData() {
        sessions = DataManager.sessions()
        tableView.reloadData()
    }

    // MARK: - Table View Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sessions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SessionsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "sessionCell", for: indexPath) as! SessionsTableViewCell
        let session = sessions[indexPath.row]
        
        cell.nameField.text = session.name
        cell.dateLabel.text = session.dateString
        cell.durationLabel.text = session.durationString

        return cell
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let index = expandedCellIndex {
            if index != indexPath.row {
                expandedCellIndex = nil
            }
        } else {
            expandedCellIndex = indexPath.row
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let index = expandedCellIndex else { return 70 }
        return indexPath.row == index ? 160 : 70
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
