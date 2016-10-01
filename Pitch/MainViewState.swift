//
//  MainViewState.swift
//  Pitch
//
//  Created by Daniel Kuntz on 10/1/16.
//  Copyright © 2016 Plutonium Apps. All rights reserved.
//

import Foundation
import UIKit

enum MainViewState {
    case White
    case LightGreen
    case Green
    
    var font: UIFont {
        switch self {
        case .Green:
            return UIFont(name: "Lato-Thin", size: 110.0)!
        default:
            return UIFont(name: "Lato-Hairline", size: 110.0)!
        }
    }
    
    var viewBackgroundColor: UIColor {
        switch self {
        case .White:
            return UIColor.white
        case .LightGreen:
            return UIColor.lightGreenView
        case .Green:
            return UIColor.greenView
        }
    }
    
    var lineTextColor: UIColor {
        switch self {
        case .Green:
            return UIColor.white
        default:
            return UIColor.black
        }
    }
    
    var lineThickness: CGFloat {
        switch self {
        case .Green:
            return 2.0
        default:
            return 1.0
        }
    }
    
    var feedbackImage: UIImage {
        switch self {
        case .Green:
            return #imageLiteral(resourceName: "white_feedback")
        default:
            return #imageLiteral(resourceName: "black_feedback")
        }
    }
}
