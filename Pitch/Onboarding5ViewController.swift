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

        // Do any additional setup after loading the view.
    }
}

extension Onboarding5ViewController: UIViewControllerTransitioningDelegate {
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentAnimationController
    }
}
