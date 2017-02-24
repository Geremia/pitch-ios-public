//
//  MainViewController+Orientation.swift
//  Pitch
//
//  Created by Daniel Kuntz on 2/22/17.
//  Copyright © 2017 Plutonium Apps. All rights reserved.
//

import UIKit
import PureLayout

extension MainViewController {
    
    override func updateViewConstraints() {
        if !didSetupConstraints {
            orientationDependentConstraints = portraitConstraints()
            let constraints = orientationDependentConstraints as NSArray
            constraints.autoInstallConstraints()
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateConstraints(forSize: view.bounds.size, withTransitionCoordinator: nil)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        updateConstraints(forSize: size, withTransitionCoordinator: coordinator)
    }
    
    // MARK: - Orientation Switching
    
    func updateConstraints(forSize size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator?) {
        let orientation: Orientation = size.height > size.width ? .portrait : .landscape
        
        if orientation != currentOrientation && orientation != .unspecified {
            orientationDependentConstraints.autoRemoveConstraints()
            orientationDependentConstraints = orientation == .portrait ? portraitConstraints() : landscapeConstraints()
            currentOrientation = orientation
            updatePitchPipeButtonImage()
            
            if let coordinator = coordinator {
                coordinator.animate(alongsideTransition: { context in
                    self.orientationDependentConstraints.autoInstallConstraints()
                    self.view.layoutIfNeeded()
                }, completion: nil)
            } else {
                self.orientationDependentConstraints.autoInstallConstraints()
                view.layoutIfNeeded()
            }
        }
    }
    
    func portraitConstraints() -> [NSLayoutConstraint] {
        return NSLayoutConstraint.autoCreateConstraintsWithoutInstalling {
            settingsButton.autoPinEdge(toSuperviewEdge: .bottom)
            settingsButton.autoPinEdge(toSuperviewEdge: .left)
            pitchPipeButton.autoPinEdge(toSuperviewEdge: .bottom)
            pitchPipeButton.autoAlignAxis(toSuperviewAxis: .vertical)
            analyticsButton.autoPinEdge(toSuperviewEdge: .bottom)
            analyticsButton.autoPinEdge(toSuperviewEdge: .right)
            
            let buttonHeight: CGFloat = 54
            for button in pitchPipeView.pitchButtons {
                button.autoSetDimension(.height, toSize: buttonHeight)
            }
            
            tunerView.autoPinEdge(.bottom, to: .top, of: pitchPipeView)
            tunerView.autoPinEdge(toSuperviewEdge: .trailing)
            
            pitchPipeView.autoPinEdge(toSuperviewEdge: .leading)
            pitchPipeView.autoPinEdge(toSuperviewEdge: .trailing)
            pitchPipeView.autoSetDimension(.height, toSize: 231)
            
            let inset: CGFloat = pitchPipeOpen ? 0 : -231
            pitchPipeDisplayConstraint = pitchPipeView.autoPinEdge(toSuperviewEdge: .bottom, withInset: inset)
        }
    }
    
    func landscapeConstraints() -> [NSLayoutConstraint] {
        return NSLayoutConstraint.autoCreateConstraintsWithoutInstalling {
            settingsButton.autoPinEdge(toSuperviewEdge: .bottom)
            settingsButton.autoPinEdge(toSuperviewEdge: .right)
            pitchPipeButton.autoPinEdge(toSuperviewEdge: .right)
            pitchPipeButton.autoAlignAxis(toSuperviewAxis: .horizontal)
            analyticsButton.autoPinEdge(toSuperviewEdge: .top)
            analyticsButton.autoPinEdge(toSuperviewEdge: .right)
            
            let rows: CGFloat = 4
            let buttonHeight = view.bounds.height / rows
            for button in pitchPipeView.pitchButtons {
                button.autoSetDimension(.height, toSize: buttonHeight)
            }
            
            tunerView.autoPinEdge(toSuperviewEdge: .bottom)
            tunerView.autoPinEdge(.trailing, to: .leading, of: pitchPipeView)
            
            pitchPipeView.autoPinEdge(toSuperviewEdge: .top)
            pitchPipeView.autoPinEdge(toSuperviewEdge: .bottom)
            pitchPipeView.autoSetDimension(.width, toSize: 260)
            
            let inset: CGFloat = pitchPipeOpen ? 0 : -260
            pitchPipeDisplayConstraint = pitchPipeView.autoPinEdge(toSuperviewEdge: .right, withInset: inset)
        }
    }
}
