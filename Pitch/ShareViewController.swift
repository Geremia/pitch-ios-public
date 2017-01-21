//
//  ShareViewController.swift
//  Pitch
//
//  Created by Daniel Kuntz on 1/16/17.
//  Copyright © 2017 Plutonium Apps. All rights reserved.
//

import UIKit
import MessageUI
import Crashlytics

protocol ShareViewControllerDelegate {
    func dismiss(animated: Bool, completion: (() -> Void)?)
    func userDidShare()
}

class ShareViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet var labels: [UILabel]!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    // MARK: - Variables
    
    var delegate: ShareViewControllerDelegate?
    
    // MARK: - Setup Views

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        view.layer.cornerRadius = 8.0
        view.clipsToBounds = true
        updateForDarkMode()
    }
    
    func updateForDarkMode() {
        let darkModeOn = UserDefaults.standard.darkModeOn()
        if darkModeOn {
            view.backgroundColor = UIColor.darkGrayView
            for label in labels {
                label.textColor = .white
            }
            shareButton.backgroundColor = UIColor.darkInTune
            cancelButton.setTitleColor(UIColor.white, for: .normal)
        }
    }

    // MARK: - Actions

    @IBAction func shareButtonPressed(_ sender: Any) {
        if MFMessageComposeViewController.canSendText() {
            let controller = MFMessageComposeViewController()
            controller.body = "Hey, I just downloaded this awesome tuner app called Pitch! You should check it out 👉 appstore.com/pitchtunerappforiphone"
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        Answers.logShare(withMethod: "Cancel", contentName: "Cancelled Share", contentType: "messaging", contentId: "002", customAttributes: [:])
        self.dismiss(animated: true, completion: { _ in
            self.delegate?.dismiss(animated: true, completion: nil)
        })
    }
    
    // MARK: - Status Bar Style
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension ShareViewController: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: { _ in
            if result == .sent {
                Answers.logShare(withMethod: "iMessage", contentName: "Shared Pitch via iMessage", contentType: "messaging", contentId: "001", customAttributes: [:])
                UserDefaults.standard.userDidShareFromAnalytics()
                self.delegate?.userDidShare()
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
}
