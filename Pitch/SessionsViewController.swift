//
//  SessionsViewController.swift
//  Pitch
//
//  Created by Daniel Kuntz on 3/2/17.
//  Copyright © 2017 Plutonium Apps. All rights reserved.
//

import UIKit
import AudioKit

protocol SessionsViewControllerDelegate {
    func prepareForRecording()
}

class SessionsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var sessionsLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var newSessionButton: UIButton!
    
    // MARK: - Properties
    
    var snapContainer: SnapContainerViewController?
    var delegate: SessionsViewControllerDelegate?
    
    var session: Session?
    var tableViewController: SessionsTableViewController?
    
    // MARK: - Setup Views

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        saveSessionIfNecessary()
    }
    
    // MARK: - Save Audio
    
    func saveSessionIfNecessary() {
        guard let recordedSession = session else { return }
        DataManager.add(recordedSession)
        tableViewController?.newSessionAdded()
    }
    
    // MARK: - Actions
    
    @IBAction func backPressed(_ sender: Any) {
        if let container = snapContainer {
            container.transitionLeft(animated: true)
        }
    }

    @IBAction func newSessionPressed(_ sender: Any) {
        dismiss(animated: true, completion: { _ in
            self.delegate?.prepareForRecording()
        })
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sessionsTableEmbed" {
            tableViewController = segue.destination as? SessionsTableViewController
        }
    }
    
    // MARK: - Status Bar Style
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
