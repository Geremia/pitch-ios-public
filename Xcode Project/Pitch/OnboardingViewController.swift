//
//  OnboardingViewController.swift
//  Pitch
//
//  Created by Daniel Kuntz on 2/25/17.
//  Copyright © 2017 Plutonium Apps. All rights reserved.
//

import UIKit

class OnboardingViewController: StyledViewController {
    
    // MARK: - Properties

    let presentAnimationController = SlideAnimationController(direction: .right)
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.transitioningDelegate = self
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
