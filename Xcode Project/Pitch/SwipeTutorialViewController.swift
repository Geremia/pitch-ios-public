//
//  SwipeTutorialViewController.swift
//  Pitch
//
//  Created by Daniel Kuntz on 3/18/17.
//  Copyright © 2017 Plutonium Apps. All rights reserved.
//

import UIKit

class SwipeTutorialViewController: StyledViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var hand: UIImageView!
    @IBOutlet weak var handTrailingConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    
    var handMinDistanceFromEdge: CGFloat = 60
    var movingLeft: Bool = true
    
    // MARK: - Setup Views

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareForAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        moveLeft()
    }
    
    // MARK: - Animation
    
    func prepareForAnimation() {
        hand.alpha = 0.0
        handTrailingConstraint.constant = handMinDistanceFromEdge
    }
    
    func moveLeft() {
        handTrailingConstraint.constant = constraintLeft()
        animate()
    }
    
    func moveRight() {
        handTrailingConstraint.constant = handMinDistanceFromEdge
        animate()
    }
    
    func animate() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.hand.alpha = 1.0
        }, completion: { finished in
            UIView.animate(withDuration: 0.3, delay: 1.3, options: [.curveEaseInOut], animations: {
                self.hand.alpha = 0.0
            }, completion: { finished in
                self.hand.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                    self.switchDirection()
                })
            })
        })
        
        UIView.animate(withDuration: 0.3, delay: 0.5, options: [.curveEaseInOut], animations: {
            self.hand.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: nil)
        
        UIView.animate(withDuration: 1.2, delay: 1.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.4, options: [.curveEaseInOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
//        UIView.animate(withDuration: 0.3, delay: 1.3, options: [.curveEaseInOut], animations: {
//            self.hand.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
//        }, completion: nil)
    }
    
    func switchDirection() {
        DispatchQueue.main.async {
            self.movingLeft ? self.moveRight() : self.moveLeft()
            self.movingLeft = !self.movingLeft
        }
    }
    
    func constraintLeft() -> CGFloat {
        return view.frame.width - hand.frame.width - handMinDistanceFromEdge
    }
    
    // MARK: - Actions
    
    @IBAction func gotItPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
