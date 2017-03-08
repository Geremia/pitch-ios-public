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
        reloadData()
    }
    
    func reloadData() {
        sessions = DataManager.sessions()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.reloadData()
    }

    // MARK: - Table View Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sessions.count
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SessionsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "sessionCell", for: indexPath) as! SessionsTableViewCell
        let session = sessions[indexPath.row]
        
        cell.indexPath = indexPath
        cell.nameField.text = session.name
        cell.dateLabel.text = session.dateString
        cell.durationLabel.text = session.durationString
        cell.isExpanded = (expandedCellIndex == indexPath)
        
        if expandedCellIndex != nil {
            cell.contentView.alpha = (expandedCellIndex == indexPath) ? 1.0 : 0.2
        } else {
            cell.contentView.alpha = 1.0
        }

        return cell
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
        
        UIView.animate(withDuration: 0.3, animations: {
            for i in 0..<self.sessions.count {
                let index = IndexPath(row: i, section: 0)
                guard let cell: SessionsTableViewCell = tableView.cellForRow(at: index) as? SessionsTableViewCell else { continue }
                if self.expandedCellIndex == nil {
                    cell.contentView.alpha = 1.0
                } else {
                    cell.contentView.alpha = (index == self.expandedCellIndex) ? 1.0 : 0.2
                }
            }
        })
        
        tableView.isScrollEnabled = (expandedCellIndex == nil)
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    // MARK: - Deletion
    
    func deleteSessionAt(_ indexPath: IndexPath) {
        sessions.remove(at: indexPath.row)
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .middle)
        tableView.endUpdates()
        tableView.reloadData()
    }
    
    func updateCellIndexPaths() {
        for i in 0..<sessions.count {
            let index = IndexPath(row: i, section: 0)
            guard let cell: SessionsTableViewCell = tableView.cellForRow(at: index) as? SessionsTableViewCell else { continue }
        }
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
