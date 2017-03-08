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
    var expandedCellIndex: IndexPath?
    
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
        
        if let expandedIndex = expandedCellIndex {
            cell.isExpanded = (expandedIndex == indexPath)
        } else {
            cell.isExpanded = false
        }

        return cell
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let expandedIndex = expandedCellIndex {
            if expandedIndex != indexPath {
                let expandedCell: SessionsTableViewCell = tableView.cellForRow(at: expandedIndex) as! SessionsTableViewCell
                expandedCell.isExpanded = false
                expandedCellIndex = nil
            }
        } else {
            let selectedCell: SessionsTableViewCell = tableView.cellForRow(at: indexPath) as! SessionsTableViewCell
            selectedCell.isExpanded = true
            expandedCellIndex = indexPath
        }
        
        tableView.isScrollEnabled = (expandedCellIndex == nil)
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
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
