//
//  OnboardingViewController.swift
//  Pitch
//
//  Created by Daniel Kuntz on 2/25/17.
//  Copyright © 2017 Plutonium Apps. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    // MARK: - Properties

    let presentAnimationController = SlideAnimationController(direction: .right)
    
    // MARK: - Setup Views
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.cornerRadius = 8.0
        view.clipsToBounds = true
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.transitioningDelegate = self
    }
    
    // MARK: - Status Bar Style
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Orientation
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

extension OnboardingViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentAnimationController
    }
}
