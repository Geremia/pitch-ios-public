//
//  VerticalSlideAnimationController.swift
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
    case fromBottom
    case toBottom
}

class VerticalSlideAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
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
        
        let darkModeOn = UserDefaults.standard.darkModeOn()
        switch self.direction {
        case .above:
            toViewController.view.frame = CGRect(x: 0, y: -height, width: width, height: height)
            if darkModeOn {
                transitionContext.containerView.backgroundColor = UIColor.darkGrayView
            } else {
                transitionContext.containerView.backgroundColor = UIColor.white
            }
        case .below:
            toViewController.view.frame = CGRect(x: 0, y: height, width: width, height: height)
            if darkModeOn {
                transitionContext.containerView.backgroundColor = UIColor.darkGrayView
            } else {
                transitionContext.containerView.backgroundColor = UIColor.white
            }
        case .fromBottom:
            toViewController.view.frame = CGRect(x: 0, y: height, width: width, height: height)
            self.darkView.frame = fromViewController.view.frame
            fromViewController.view.addSubview(self.darkView)
            
            toViewController.view.layer.shadowColor = UIColor(white: 0.0, alpha: 0.05).cgColor
            toViewController.view.layer.shadowOpacity = 0.0
            toViewController.view.layer.shadowRadius = 4.0
        case .toBottom:
            toViewController.view.frame = CGRect(x: 0, y: 0, width: width, height: height)
            transitionContext.containerView.sendSubview(toBack: toViewController.view)
        case .left:
            toViewController.view.frame = CGRect(x: -width - 16, y: 0, width: width, height: height)
            transitionContext.containerView.backgroundColor = UIColor.black
        case .right:
            toViewController.view.frame = CGRect(x: width + 16, y: 0, width: width, height: height)
            transitionContext.containerView.backgroundColor = UIColor.black
        }
        
        switch self.direction {
        case .above, .below:
            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.6, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
                switch self.direction {
                case .above:
                    toViewController.view.frame.origin.y += height
                    fromViewController.view.frame.origin.y += height
                case .below:
                    toViewController.view.frame.origin.y -= height
                    fromViewController.view.frame.origin.y -= height
                default:
                    return
                }
                
                }, completion: { finished in
                    if finished {
                        transitionContext.completeTransition(true)
                    }
            })
        case .left, .right:
            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.6, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
                switch self.direction {
                case .left:
                    toViewController.view.frame.origin.x += width + 16
                    fromViewController.view.frame.origin.x += width + 16
                case .right:
                    toViewController.view.frame.origin.x -= width + 16
                    fromViewController.view.frame.origin.x -= width + 16
                default:
                    return
                }
                
            }, completion: { finished in
                if finished {
                    transitionContext.completeTransition(true)
                }
            })
        case .fromBottom, .toBottom:
            UIView.animate(withDuration: transitionDuration(using: transitionContext) - 0.1, delay: 0, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
                switch self.direction {
                case .fromBottom:
                    toViewController.view.frame.origin.y -= height
                    toViewController.view.layer.shadowOpacity = 1.0
                    self.darkView.alpha = 0.25
                case .toBottom:
                    fromViewController.view.frame.origin.y += height
                    fromViewController.view.layer.shadowOpacity = 0.0
                    self.darkView.alpha = 0.0
                default:
                    return
                }
                
                }, completion:  { finished in
                    if finished {
                        transitionContext.completeTransition(true)
                        UIApplication.shared.keyWindow!.addSubview(toViewController.view)
                        
                        if self.direction == .toBottom {
                            self.darkView.removeFromSuperview()
                        }
                        
                    }
            })
        }
    }
    
}
