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
    case holding
    case inTune
    
    var isWithinTuningThreshold: Bool {
        return self == MainViewState.holding || self == MainViewState.inTune
    }
    
    fileprivate var darkModeOn: Bool {
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
    
    var octaveLabelFont: UIFont {
        return centsLabelFont.withSize(32.0)
    }
    
    var viewBackgroundColor: UIColor {
        switch self {
        case .outOfTune:
            if darkModeOn {
                return UIColor.darkGrayView
            } else {
                return UIColor.white
            }
        case .almostInTune, .holding:
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
    
    var analyticsCircleThickness: CGFloat {
        switch self {
        case .inTune:
            return 3.0
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
    
    var microphoneImage: UIImage {
        switch self {
        case .inTune:
            return #imageLiteral(resourceName: "thick_microphone")
        default:
            if darkModeOn {
                return #imageLiteral(resourceName: "white_microphone")
            } else {
                return #imageLiteral(resourceName: "microphone")
            }
        }
    }
    
    var menuImage: UIImage {
        switch self {
        case .inTune:
            return #imageLiteral(resourceName: "thick_settings")
        default:
            if darkModeOn {
                return #imageLiteral(resourceName: "white_settings")
            } else {
                return #imageLiteral(resourceName: "settings")
            }
        }
    }
    
    var closePitchPipeImage: UIImage {
        let isPortrait = Constants.currentOrientation == .portrait
        
        switch self {
        case .inTune:
            return isPortrait ? #imageLiteral(resourceName: "thick_down_arrow") : #imageLiteral(resourceName: "thick_forward_arrow")
        default:
            if darkModeOn {
                return isPortrait ? #imageLiteral(resourceName: "white_down_arrow") : #imageLiteral(resourceName: "white_forward_arrow")
            } else {
                return isPortrait ? #imageLiteral(resourceName: "down_arrow") : #imageLiteral(resourceName: "forward_arrow")
            }
        }
    }
    
    var pitchPipeImage: UIImage {
        switch self {
        case .inTune:
            return #imageLiteral(resourceName: "thick_piano")
        default:
            if darkModeOn {
                return #imageLiteral(resourceName: "white_piano")
            } else {
                return #imageLiteral(resourceName: "piano")
            }
        }
    }
    
    var analyticsImage: UIImage {
        switch self {
        case .inTune:
            return #imageLiteral(resourceName: "thick_analytics")
        default:
            if darkModeOn {
                return #imageLiteral(resourceName: "white_analytics")
            } else {
                return #imageLiteral(resourceName: "analytics")
            }
        }
    }
    
}
