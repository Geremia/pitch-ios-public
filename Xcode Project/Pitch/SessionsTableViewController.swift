//
//  SessionsTableViewController.swift
//  Pitch
//
//  Created by Daniel Kuntz on 3/2/17.
//  Copyright © 2017 Plutonium Apps. All rights reserved.
//

import UIKit
import RealmSwift

protocol SessionsTableViewControllerDelegate {
    func showEmptyState()
    func hideEmptyState()
}

class SessionsTableViewController: UITableViewController, SessionsTableViewCellDelegate {
    
    // MARK: - Properties
    
    var delegate: SessionsTableViewControllerDelegate?
    
    var sessions: [Session] = []
    var expandedCellIndex: IndexPath?
    
    // MARK: - Setup

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        reloadData()
    }
    
    func setup() {
        tableView.separatorColor = UIColor.separatorColor
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        
        darkModeChanged()
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeChanged), name: .darkModeChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateExpandedCellPlayhead(_:)), name: .playbackUpdate, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(finishedPlayback), name: .finishedPlayback, object: nil)
    }
    
    // MARK: - Dark Mode
    
    func darkModeChanged() {
        let darkModeOn = UserDefaults.standard.darkModeOn()
        tableView.separatorColor = darkModeOn ? UIColor.darkSeparatorColor : UIColor.separatorColor
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
        sessions.isEmpty ? delegate?.showEmptyState() : delegate?.hideEmptyState()
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
        cell.duration = session.duration
        cell.isExpanded = (expandedCellIndex == indexPath)
        
        setAlphaFor(cell)

        return cell
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let expandedIndex = expandedCellIndex {
            if expandedIndex != indexPath {
                Player.shared.reset()
                finishedPlayback()
                
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
        if expandedCellIndex != nil {
            cell.contentView.alpha = (expandedCellIndex == indexPath) ? 1.0 : 0.2
        } else {
            cell.contentView.alpha = 1.0
        }
    }
    
    // MARK: - SessionsTableViewCellDelegate Methods
    
    func nameEditedOn(_ cell: SessionsTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let session = sessions[indexPath.row]
            DataManager.rename(session, to: cell.nameField.text!)
            reloadData(andTableView: false)
        }
    }
    
    func playPausePressedOn(_ cell: SessionsTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let session = sessions[indexPath.row]
            if cell.isPlaying {
                Player.shared.play(from: session.audioFileUrl)
            } else {
                Player.shared.pause()
            }
        }
    }
    
    func sliderValueChangedOn(_ cell: SessionsTableViewCell) {
        let time = TimeInterval(cell.slider.value)
        
        DispatchQueue.main.async {
            Player.shared.setCurrentTime(time)
        }
    }
    
    func sharePressedOn(_ cell: SessionsTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let session = sessions[indexPath.row]
            let activityView = UIActivityViewController(activityItems: [session.audioFileUrl], applicationActivities: nil)
            present(activityView, animated: true, completion: nil)
        }
    }
    
    func analyticsPressedOn(_ cell: SessionsTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            Player.shared.reset()
            finishedPlayback()
            
            let session = sessions[indexPath.row]
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let analyticsVC: AnalyticsViewController = storyboard.instantiateViewController(withIdentifier: "analytics") as! AnalyticsViewController
            analyticsVC.session = session
            analyticsVC.transitioningDelegate = self
            present(analyticsVC, animated: true, completion: nil)
        }
    }
    
    func deletePressedOn(_ cell: SessionsTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            Player.shared.reset()
            finishedPlayback()
            requestDeletionForSessionAt(indexPath)
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
    
    // MARK: - Playback Notifications
    
    func updateExpandedCellPlayhead(_ notification: Notification) {
        if let index = expandedCellIndex, let currentTime = notification.userInfo!["currentTime"] as? Double {
            let expandedCell: SessionsTableViewCell = tableView.cellForRow(at: index) as! SessionsTableViewCell
            expandedCell.currentTime = currentTime
        }
    }
    
    func finishedPlayback() {
        if let index = expandedCellIndex {
            let expandedCell: SessionsTableViewCell = tableView.cellForRow(at: index) as! SessionsTableViewCell
            expandedCell.isPlaying = false
            expandedCell.resetPlayPauseImage()
            expandedCell.currentTime = 0
        }
    }
}

extension SessionsTableViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideAnimationController(direction: .right)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideAnimationController(direction: .left)
    }
}
