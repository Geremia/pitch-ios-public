//
//  SettingsViewController.swift
//  Pitch
//
//  Created by Daniel Kuntz on 11/7/16.
//  Copyright © 2016 Plutonium Apps. All rights reserved.
//

import UIKit
import MessageUI

class SettingsViewController: UIViewController, MFMailComposeViewControllerDelegate, SettingsTableViewControllerDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var touchBlockingView: UIView!
    
    @IBOutlet weak var settingsView: UIView!
    @IBOutlet weak var settingsViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var improveLabel: UILabel!
    @IBOutlet weak var feedbackButton: UIButton!
    
    @IBOutlet weak var instrumentKeyView: UIView!
    @IBOutlet weak var instrumentKeyBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Variables
    
    var settingsTableViewController: SettingsTableViewController?
    var snapContainer: SnapContainerViewController?
    
    // MARK: - Setup Views

    override func viewDidLoad() {
        super.viewDidLoad()

        settingsView.layer.cornerRadius = 8.0
        settingsView.layer.masksToBounds = true
        instrumentKeyView.layer.cornerRadius = 8.0
        instrumentKeyView.layer.masksToBounds = true
        
        feedbackButton.layer.cornerRadius = 8.0
        darkModeChanged()
        
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeChanged), name: .darkModeChanged, object: nil)
    }
    
    // MARK: - Actions
    
    @IBAction func backPressed(_ sender: Any) {
        if let container = snapContainer {
            container.transitionRight(animated: true)
        }
    }
    
    @IBAction func feedbackPressed(_ sender: Any) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["dkuntz0@gmail.com"])
            mail.setSubject("Pitch Tuner Feedback")
            mail.setMessageBody("Hi Daniel,\n This is how I think you can improve the Pitch tuner app: \n\n\n\n\n\n ", isHTML: true)
            
            present(mail, animated: true, completion: nil)
        }
    }
    
    // MARK: - MFMailComposeViewControllerDelegate
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - SettingsTableViewControllerDelegate
    
    func instrumentKeySelected() {
        openInstrumentKeyView()
    }
    
    func openInstrumentKeyView() {
        touchBlockingView.isHidden = false
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SettingsViewController.closeInstrumentKeyView(_:)))
        settingsView.addGestureRecognizer(tapGestureRecognizer)
        NotificationCenter.default.post(name: .darkModeChanged, object: nil)
        
        instrumentKeyBottomConstraint.constant = 0
        settingsViewBottomConstraint.constant = instrumentKeyView.frame.height + 8
        
        UIView.animate(withDuration: 0.55, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.6, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
            self.view.layoutIfNeeded()
            self.settingsView.alpha = 0.5
        }, completion: nil)
    }
    
    func closeInstrumentKeyView(_ gestureRecognizer: UITapGestureRecognizer) {
        touchBlockingView.isHidden = true
        settingsTableViewController?.updateKeyLabel()
        settingsView.removeGestureRecognizer(gestureRecognizer)
        
        instrumentKeyBottomConstraint.constant = -(instrumentKeyView.frame.height + 8)
        settingsViewBottomConstraint.constant = 0

        UIView.animate(withDuration: 0.55, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.6, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
            self.view.layoutIfNeeded()
            self.settingsView.alpha = 1.0
        }, completion: nil)
    }
    
    // MARK: - Dark Mode Switching 
    
    func darkModeChanged() {
        let darkModeOn = UserDefaults.standard.darkModeOn()
        if darkModeOn {
            settingsView.backgroundColor = UIColor.darkGrayView
            instrumentKeyView.backgroundColor = UIColor.darkGrayView
            settingsLabel.textColor = UIColor.white
            improveLabel.textColor = UIColor.white
            backButton.setImage(#imageLiteral(resourceName: "white_forward_arrow"), for: .normal)
            feedbackButton.backgroundColor = UIColor.darkInTune
        } else {
            settingsView.backgroundColor = UIColor.white
            instrumentKeyView.backgroundColor = UIColor.white
            settingsLabel.textColor = UIColor.black
            improveLabel.textColor = UIColor.black
            backButton.setImage(#imageLiteral(resourceName: "forward_arrow"), for: .normal)
            feedbackButton.backgroundColor = UIColor.inTune
        }
    }
    
    // MARK: - Status Bar Style
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "settingsTableEmbed" {
            let tableViewController: SettingsTableViewController = segue.destination as! SettingsTableViewController
            settingsTableViewController = tableViewController
            settingsTableViewController?.delegate = self
        }
    }
    
}
