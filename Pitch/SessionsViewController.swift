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
    
    // MARK: - Variables
    
    var delegate: SessionsViewControllerDelegate?
    var audioFile: AKAudioFile?
    
    // MARK: - Setup Views

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Save Audio
    
    func saveAudioIfNecessary() {
        guard let file = audioFile else { return }
        let session = Session.with(name: "Test Session", file: file)
    }
    
    // MARK: - Actions
    
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func newSessionPressed(_ sender: Any) {
        dismiss(animated: true, completion: { _ in
            self.delegate?.prepareForRecording()
        })
    }
    
    // MARK: - Status Bar Style
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
