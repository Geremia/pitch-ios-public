//
//  AnalyticsViewController+Delegates.swift
//  Pitch
//
//  Created by Daniel Kuntz on 1/25/17.
//  Copyright © 2017 Plutonium Apps. All rights reserved.
//

import UIKit
import MessageUI

extension AnalyticsViewController: MFMailComposeViewControllerDelegate {
    
    // MARK: - MFMailComposeViewControllerDelegate
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension AnalyticsViewController: ShareViewControllerDelegate {
    
    // MARK: - ShareViewControllerDelegate Methods
    
    func userDidShare() {
        showingShareView = false
        shareView.isHidden = true
        reloadData()
        checkForShareAndAnimation()
    }
}

extension AnalyticsViewController: PitchesTableViewControllerDelegate {
    
    // MARK: - PitchesTableViewControllerDelegate Methods
    
    func setNumberOfRows(_ rows: Int) {
        outOfTuneTableHeightConstraint.constant = 44.0 * CGFloat(rows)
        view.layoutIfNeeded()
    }
}
