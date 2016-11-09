//
//  SettingsViewController.swift
//  Pitch
//
//  Created by Daniel Kuntz on 11/7/16.
//  Copyright © 2016 Plutonium Apps. All rights reserved.
//

import UIKit
import MessageUI

class SettingsViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var feedbackButton: UIButton!
    
    // MARK: - Setup Views

    override func viewDidLoad() {
        super.viewDidLoad()

        view.layer.cornerRadius = 8.0
        view.clipsToBounds = true
        feedbackButton.layer.cornerRadius = 8.0
    }

    // MARK: - Actions
    
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
    
    // MARK: - Status Bar Style
    
    override var prefersStatusBarHidden: Bool {
        return true
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
