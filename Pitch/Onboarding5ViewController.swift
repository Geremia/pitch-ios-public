//
//  Onboarding5ViewController.swift
//  Pitch
//
//  Created by Daniel Kuntz on 2/25/17.
//  Copyright © 2017 Plutonium Apps. All rights reserved.
//

import UIKit

class Onboarding5ViewController: OnboardingViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var label: UILabel!
    
    // MARK: - Setup Views

    override func viewDidLoad() {
        super.viewDidLoad()
        styleLabel()
    }
    
    func styleLabel() {
        let boldFont = UIFont(name: "Lato-Regular", size: 22.0)!
        let lightFont = UIFont(name: "Lato-Light", size: 22.0)!
        
        let chunk1 = NSAttributedString(string: "Leave Pitch open during your ", attributes: [NSFontAttributeName: lightFont])
        let chunk2 = NSAttributedString(string: "entire practice session. ", attributes: [NSFontAttributeName: boldFont])
        let chunk3 = NSAttributedString(string: "We'll let you know when your ", attributes: [NSFontAttributeName: lightFont])
        let chunk4 = NSAttributedString(string: "daily analytics ", attributes: [NSFontAttributeName: boldFont])
        let chunk5 = NSAttributedString(string: "are ready!", attributes: [NSFontAttributeName: lightFont])
        
        let combined: NSMutableAttributedString = NSMutableAttributedString(attributedString: chunk1)
        combined.append(chunk2)
        combined.append(chunk3)
        combined.append(chunk4)
        combined.append(chunk5)
        
        label.attributedText = combined
    }
    
    // MARK: - Actions
    
    @IBAction func getStartedPressed(_ sender: Any) {
        let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let container = delegate.snapContainer()
        let window = delegate.window
        window?.rootViewController = container
        window?.makeKeyAndVisible()
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.alpha = 0.0
            container.view.alpha = 1.0
        })
    }
}
