//
//  SessionsViewController.swift
//  Pitch
//
//  Created by Daniel Kuntz on 3/2/17.
//  Copyright © 2017 Plutonium Apps. All rights reserved.
//

import UIKit
import AudioKit

class SessionsViewController: UIViewController, SessionsTableViewControllerDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var sessionsLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var newSessionButton: UIButton!
    @IBOutlet weak var emptyStateLabel: UILabel!
    
    // MARK: - Properties
    
    var snapContainer: SnapContainerViewController?
    var tableViewController: SessionsTableViewController?
    
    // MARK: - Setup Views

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Notifications
    
    func newSessionRecorded(_ notification: Notification) {
        let session: Session = notification.object as! Session
        DataManager.add(session)
        tableViewController?.newSessionAdded()
    }
    
    func doneRecording() {
        newSessionButton.isHidden = false
    }
    
    // MARK: - Empty State
    
    func showEmptyState() {
        UIView.transition(with: emptyStateLabel, duration: 0.3, options: [.transitionCrossDissolve], animations: {
            self.emptyStateLabel.isHidden = false
        }, completion: nil)
    }
    
    func hideEmptyState() {
        UIView.transition(with: emptyStateLabel, duration: 0.3, options: [.transitionCrossDissolve], animations: {
            self.emptyStateLabel.isHidden = true
        }, completion: nil)
    }
    
    // MARK: - Actions
    
    @IBAction func backPressed(_ sender: Any) {
        if let container = snapContainer {
            container.transitionLeft(animated: true)
        }
    }

    @IBAction func newSessionPressed(_ sender: Any) {
        if let container = snapContainer {
            container.go(toViewController: .main, animated: true, completion: {
                self.newSessionButton.isHidden = true
                NotificationCenter.default.post(name: .prepareForRecording, object: nil)
            })
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sessionsTableEmbed" {
            tableViewController = segue.destination as? SessionsTableViewController
            tableViewController?.delegate = self
        }
    }
    
    // MARK: - Status Bar Style
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
