//
//  Onboarding5ViewController.swift
//  Pitch
//
//  Created by Daniel Kuntz on 2/25/17.
//  Copyright © 2017 Plutonium Apps. All rights reserved.
//

import UIKit

class Onboarding5ViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var label: UILabel!
    
    // MARK: - Variables
    
    let presentAnimationController = SlideAnimationController(direction: .above)
    
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
        
        let combined: NSMutableAttributedString = chunk1 as! NSMutableAttributedString
        combined.append(chunk2)
        combined.append(chunk3)
        combined.append(chunk4)
        combined.append(chunk5)
        
        label.attributedText = combined
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.transitioningDelegate = self
    }
}

extension Onboarding5ViewController: UIViewControllerTransitioningDelegate {
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentAnimationController
    }
}
