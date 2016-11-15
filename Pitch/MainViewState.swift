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
    case outOfTune
    case almostInTune
    case inTune
    
    private var darkModeOn: Bool {
        return UserDefaults.standard.darkModeOn()
    }
    
    var font: UIFont {
        switch self {
        case .inTune:
            return UIFont(name: "Lato-Light", size: 110.0)!
        default:
            return UIFont(name: "Lato-Hairline", size: 110.0)!
        }
    }
    
    var centsLabelFont: UIFont {
        switch self {
        case .inTune:
            return UIFont(name: "Lato-Semibold", size: 17.0)!
        default:
            return UIFont(name: "Lato-Light", size: 17.0)!
        }
    }
    
    var viewBackgroundColor: UIColor {
        switch self {
        case .outOfTune:
            if darkModeOn {
                return UIColor.darkGrayView
            } else {
                return UIColor.white
            }
        case .almostInTune:
            if darkModeOn {
                return UIColor.darkAlmostInTune
            } else {
                return UIColor.almostInTune
            }
        case .inTune:
            if darkModeOn {
                return UIColor.darkInTune
            } else {
                return UIColor.inTune
            }
        }
    }
    
    var lineTextColor: UIColor {
        switch self {
        case .inTune:
            return UIColor.white
        default:
            if darkModeOn {
                return UIColor.white
            } else {
                return UIColor.black
            }
        }
    }
    
    var lineThickness: CGFloat {
        switch self {
        case .inTune:
            return 4.0
        default:
            return 1.0
        }
    }
    
    var feedbackImage: UIImage {
        switch self {
        case .inTune:
            return #imageLiteral(resourceName: "white_feedback")
        default:
            if darkModeOn {
                return #imageLiteral(resourceName: "white_feedback")
            } else {
                return #imageLiteral(resourceName: "black_feedback")
            }
        }
    }
    
    var menuImage: UIImage {
        switch self {
        case .inTune:
            return #imageLiteral(resourceName: "thick_menu")
        default:
            if darkModeOn {
                return #imageLiteral(resourceName: "white_menu")
            } else {
                return #imageLiteral(resourceName: "menu")
            }
        }
    }
    
    var downArrowImage: UIImage {
        switch self {
        case .inTune:
            return #imageLiteral(resourceName: "thick_down_arrow")
        default:
            if darkModeOn {
                return #imageLiteral(resourceName: "white_down_arrow")
            } else {
                return #imageLiteral(resourceName: "down_arrow")
            }
        }
    }
    
    var audioWaveImage: UIImage {
        switch self {
        case .inTune:
            return #imageLiteral(resourceName: "thick_audio_wave")
        default:
            if darkModeOn {
                return #imageLiteral(resourceName: "white_audio_wave")
            } else {
                return #imageLiteral(resourceName: "audio_wave")
            }
        }
    }
}
