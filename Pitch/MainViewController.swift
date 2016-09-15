//
//  MainViewController.swift
//  Pitch
//
//  Created by Daniel Kuntz on 9/14/16.
//  Copyright © 2016 Plutonium Apps. All rights reserved.
//

import UIKit
import TuningFork

enum MainViewState {
    case White
    case LightGreen
    case Green
}

class MainViewController: UIViewController, TunerDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet var lines: [UIView]!
    @IBOutlet var lineHeights: [NSLayoutConstraint]!
    @IBOutlet weak var movingLineCenterConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    
    private var tuner: Tuner?
    private var state: MainViewState = .White
    
    // MARK: - Setup Views

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tuner = Tuner()
        tuner?.delegate = self
        tuner?.start()
        
        printFonts()
    }
    
    // MARK: TunerDelegate
    
    func tunerDidUpdate(_ tuner: Tuner, output: TunerOutput) {
        if output.amplitude < 0.01 {
            noteLabel.text = "--"
            movingLineCenterConstraint.constant = 0.0
            animateViewTo(newState: .White)
        } else {
            noteLabel.text = output.pitch
            movingLineCenterConstraint.constant = CGFloat(-output.distance * 30.0)
            
            if abs(output.distance) < 0.4 {
                animateViewTo(newState: .Green)
            } else if abs(output.distance) < 1.5 {
                animateViewTo(newState: .LightGreen)
            } else {
                animateViewTo(newState: .White)
            }
        }
        
        if abs(movingLineCenterConstraint.constant) < 2.0 {
            movingLineCenterConstraint.constant = 0.0
        }
        
        UIView.animate(withDuration: 0.08, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    // MARK: - UI
    
    func animateViewTo(newState: MainViewState) {
        if newState != state {
            state = newState
            var viewBackgroundColor: UIColor!
            var lineTextColor: UIColor!
            var lineThickness: CGFloat = 1.0
            var font: UIFont = UIFont(name: "Lato-Hairline", size: 100.0)!
            
            switch newState {
            case .White:
                viewBackgroundColor = UIColor.white
                lineTextColor = UIColor.black
            case .LightGreen:
                viewBackgroundColor = UIColor.lightGreenView
                lineTextColor = UIColor.black
            case .Green:
                viewBackgroundColor = UIColor.greenView
                lineTextColor = UIColor.white
                lineThickness = 2.0
                font = UIFont(name: "Lato-Thin", size: 100.0)!
            }
            
            for height in lineHeights {
                height.constant = lineThickness
            }
            
            UIView.animate(withDuration: 0.2, animations: {
                self.view.backgroundColor = viewBackgroundColor
                self.noteLabel.textColor = lineTextColor
                self.noteLabel.font = font
                for line in self.lines {
                    line.backgroundColor = lineTextColor
                    line.layoutIfNeeded()
                }
            })
        }
    }
    
    func printFonts() {
        let fontFamilyNames = UIFont.familyNames
        for familyName in fontFamilyNames {
            print("------------------------------")
            print("Font Family Name = [\(familyName)]")
            let names = UIFont.fontNames(forFamilyName: familyName)
            print("Font Names = [\(names)]")
        }
    }

    // MARK: - Status Bar Style
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

