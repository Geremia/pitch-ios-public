//
//  SessionsTableViewController.swift
//  Pitch
//
//  Created by Daniel Kuntz on 3/2/17.
//  Copyright © 2017 Plutonium Apps. All rights reserved.
//

import UIKit
import RealmSwift

class SessionsTableViewController: UITableViewController, SessionsTableViewCellDelegate {
    
    // MARK: - Properties
    
    var sessions: [Session] = []
    var expandedCellIndex: IndexPath?
    
    // MARK: - Setup

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        reloadData()
    }
    
    func setupUI() {
        tableView.separatorColor = UIColor.separatorColor
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        
        darkModeChanged()
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeChanged), name: .darkModeChanged, object: nil)
    }
    
    // MARK: - Dark Mode
    
    func darkModeChanged() {
        let darkModeOn = UserDefaults.standard.darkModeOn()
        tableView.separatorColor = darkModeOn ? UIColor.darkPitchPipeBackground : UIColor.separatorColor
    }
    
    // MARK: - Data Loading
    
    func reloadData(andTableView reloadTableView: Bool = true) {
        sessions = DataManager.sessions()
        if reloadTableView {
            tableView.reloadData()
        }
    }
    
    func newSessionAdded() {
        reloadData()
        
        let indexPath = IndexPath(row: 0, section: 0)
        let cell: SessionsTableViewCell = tableView.cellForRow(at: indexPath) as! SessionsTableViewCell
        tableView(tableView, didSelectRowAt: indexPath)
        cell.nameField.becomeFirstResponder()
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
        
        cell.delegate = self
        cell.nameField.text = session.name
        cell.dateLabel.text = session.dateString
        cell.durationLabel.text = session.durationString
        cell.isExpanded = (expandedCellIndex == indexPath)
        
        setAlphaFor(cell)

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
                self.setAlphaFor(cell)
            }
        })
        
        tableView.isScrollEnabled = (expandedCellIndex == nil)
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func setAlphaFor(_ cell: SessionsTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        if self.expandedCellIndex != nil {
            cell.contentView.alpha = (self.expandedCellIndex == indexPath) ? 1.0 : 0.2
        } else {
            cell.contentView.alpha = 1.0
        }
    }
    
    // MARK: - Sessions Table View Cell Delegate
    
    func sharePressedOn(_ cell: SessionsTableViewCell) {
    }
    
    func analyticsPressedOn(_ cell: SessionsTableViewCell) {
    }
    
    func deletePressedOn(_ cell: SessionsTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            requestDeletionForSessionAt(indexPath)
        }
    }
    
    func nameEditedOn(_ cell: SessionsTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let session = sessions[indexPath.row]
            DataManager.rename(session, to: cell.nameField.text!)
            reloadData(andTableView: false)
        }
    }
    
    // MARK: - Deletion
    
    func requestDeletionForSessionAt(_ indexPath: IndexPath) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let sessionName = sessions[indexPath.row].name
        let deleteAction = UIAlertAction(title: "Delete \"\(sessionName)\"", style: .destructive, handler: { action in
            self.deleteSessionAt(indexPath)
        })
        
        alertController.addActions([deleteAction, cancelAction])
        present(alertController, animated: true, completion: nil)
    }
    
    func deleteSessionAt(_ indexPath: IndexPath) {
        expandedCellIndex = nil
        UIView.animate(withDuration: 0.3, animations: {
            for i in 0..<self.sessions.count {
                let index = IndexPath(row: i, section: 0)
                guard let cell: SessionsTableViewCell = self.tableView.cellForRow(at: index) as? SessionsTableViewCell else { continue }
                cell.contentView.alpha = 1.0
            }
        })
        
        DataManager.delete(sessions[indexPath.row])
        sessions.remove(at: indexPath.row)
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .middle)
        tableView.endUpdates()
    }
}
