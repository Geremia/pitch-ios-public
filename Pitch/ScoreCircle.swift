//
//  ScoreCircle.swift
//  Pitch
//
//  Created by Daniel Kuntz on 12/26/16.
//  Copyright © 2016 Plutonium Apps. All rights reserved.
//

import UIKit

class ScoreCircle: UIView {

    var circleLayer: CAShapeLayer = CAShapeLayer()
    var borderLayer: CAShapeLayer = CAShapeLayer()
    
    var score: Double = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    var colorful: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addBorder()
        setupCircleLayer()
    }
    
    func resetForDarkMode() {
        removeBorder()
        addBorder()
        circleLayer.removeFromSuperlayer()
        setupCircleLayer()
    }
    
    func setupCircleLayer() {
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineWidth = 2.0
        circleLayer.strokeColor = UIColor.black.cgColor
        circleLayer.lineCap = kCALineCapRound
        self.layer.addSublayer(circleLayer)
    }
    
    func addBorder() {
        borderLayer.path = UIBezierPath(ovalIn: bounds).cgPath
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.lineWidth = 2.0
        let darkModeOn = UserDefaults.standard.darkModeOn()
        borderLayer.strokeColor = darkModeOn ? UIColor.darkPitchPipeBackground.cgColor : UIColor.separatorColor.cgColor
        self.layer.addSublayer(borderLayer)
    }
    
    func removeBorder() {
        borderLayer.removeFromSuperlayer()
    }
    
    override func draw(_ rect: CGRect) {
        let circleCenter = CGPoint(x: frame.width / 2.0, y: frame.height / 2.0)
        let circleRadius = frame.width / 2.0
        let start = CGFloat(3 * M_PI_2)
        let end = start + CGFloat(2 * M_PI * score/100)
        let circlePath = UIBezierPath(arcCenter: circleCenter, radius: circleRadius, startAngle: start, endAngle: end, clockwise: true)
        
        circleLayer.path = circlePath.cgPath
        if colorful {
            switch score {
            case 0...40:
                circleLayer.strokeColor = UIColor.red.cgColor
            case 41...70:
                circleLayer.strokeColor = UIColor.yellow.cgColor
            case 71...100:
                let darkModeOn = UserDefaults.standard.darkModeOn()
                circleLayer.strokeColor = darkModeOn ? UIColor.darkInTune.cgColor : UIColor.inTune.cgColor
            default:
                break
            }
        }
    }

}
