//
//  SlideAnimationController.swift
//  passdown-iOS
//
//  Created by Daniel Kuntz on 4/1/16.
//  Copyright © 2016 Plutonium Apps. All rights reserved.
//

import UIKit

enum Direction {
    case above
    case below
    case left
    case right
}

class SlideAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    var direction: Direction
    var darkView: UIView!
    
    init(direction: Direction, darkView: UIView) {
        self.direction = direction
        self.darkView = darkView
        
        super.init()
    }
    
    init(direction: Direction) {
        self.direction = direction
        
        self.darkView = UIView()
        self.darkView.layer.backgroundColor = UIColor(white: 0.0, alpha: 1.0).cgColor
        self.darkView.alpha = 0.0
        
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.55
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toViewController: UIViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let fromViewController: UIViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        
        transitionContext.containerView.addSubview(toViewController.view!)
        transitionContext.containerView.backgroundColor = UIColor.black
        
        let damping: CGFloat!
        let initialVelocity: CGFloat = 0.6
        
        switch self.direction {
        case .above:
            toViewController.view.frame = CGRect(x: 0, y: -height - 16, width: width, height: height)
            damping = 0.8
        case .below:
            toViewController.view.frame = CGRect(x: 0, y: height + 16, width: width, height: height)
            damping = 0.8
        case .left:
            toViewController.view.frame = CGRect(x: -width - 16, y: 0, width: width, height: height)
            damping = 0.75
        case .right:
            toViewController.view.frame = CGRect(x: width + 16, y: 0, width: width, height: height)
            damping = 0.75
        }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: initialVelocity, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
            switch self.direction {
            case .above:
                toViewController.view.frame.origin.y += height + 16
                fromViewController.view.frame.origin.y += height + 16
            case .below:
                toViewController.view.frame.origin.y -= height + 16
                fromViewController.view.frame.origin.y -= height + 16
            case .left:
                toViewController.view.frame.origin.x += width + 16
                fromViewController.view.frame.origin.x += width + 16
            case .right:
                toViewController.view.frame.origin.x -= width + 16
                fromViewController.view.frame.origin.x -= width + 16
            }
        }, completion: { finished in
            if finished {
                transitionContext.completeTransition(true)
            }
        })
    }
    
}
