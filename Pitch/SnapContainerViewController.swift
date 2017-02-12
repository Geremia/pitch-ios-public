//
//  ContainerViewController.swift
//  SnapchatSwipeView
//
//  Created by Jake Spracher on 8/9/15.
//  Copyright (c) 2015 Jake Spracher. All rights reserved.
//

import UIKit
import Crashlytics

protocol SnapContainerViewControllerDelegate {
    func outerScrollViewShouldScroll() -> Bool
}

enum SnapContainerViewControllerType {
    case left
    case middle
    case right
}

class SnapContainerViewController: UIViewController, UIScrollViewDelegate {
    
    var topVc: UIViewController?
    var leftVc: UIViewController!
    var middleVc: UIViewController!
    var rightVc: UIViewController!
    var bottomVc: UIViewController?
    
    var directionLockDisabled: Bool!
    
    var horizontalViews = [UIViewController]()
    var veritcalViews = [UIViewController]()
    
    var initialContentOffset = CGPoint() // scrollView initial offset
    var middleVertScrollVc: VerticalScrollViewController!
    var scrollView: UIScrollView!
    var delegate: SnapContainerViewControllerDelegate?
    
    class func containerViewWith(_ leftVC: UIViewController,
                                 middleVC: UIViewController,
                                 rightVC: UIViewController,
                                 topVC: UIViewController?=nil,
                                 bottomVC: UIViewController?=nil,
                                 directionLockDisabled: Bool?=false) -> SnapContainerViewController {
        let container = SnapContainerViewController()
        
        container.directionLockDisabled = directionLockDisabled
        
        container.topVc = topVC
        container.leftVc = leftVC
        container.middleVc = middleVC
        container.rightVc = rightVC
        container.bottomVc = bottomVC
        return container
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNotifications()
        setupVerticalScrollView()
        setupHorizontalScrollView()
    }
    
    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(shortcutOpenToneGenerator(_:)), name: .openToneGenerator, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(shortcutOpenAnalytics(_:)), name: .openAnalytics, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeChanged(_:)), name: .darkModeChanged, object: nil)
    }
    
    func setupVerticalScrollView() {
        middleVertScrollVc = VerticalScrollViewController.verticalScrollVcWith(middleVc: middleVc,
                                                                               topVc: topVc,
                                                                               bottomVc: bottomVc)
        delegate = middleVertScrollVc
    }
    
    func setupHorizontalScrollView() {
        scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.delaysContentTouches = false
        
        let view = (
            x: self.view.bounds.origin.x,
            y: self.view.bounds.origin.y,
            width: self.view.bounds.width,
            height: self.view.bounds.height
        )

        scrollView.frame = CGRect(x: view.x,
                                  y: view.y,
                                  width: view.width + 16,
                                  height: view.height
        )
        
        self.view.addSubview(scrollView)
        
        let scrollWidth  = (3 * view.width) + 48
        let scrollHeight  = view.height
        scrollView.contentSize = CGSize(width: scrollWidth, height: scrollHeight)
        
        leftVc.view.frame = CGRect(x: 0,
                                   y: 0,
                                   width: view.width,
                                   height: view.height
        )
        
        middleVertScrollVc.view.frame = CGRect(x: view.width + 16,
                                               y: 0,
                                               width: view.width,
                                               height: view.height
        )
        
        rightVc.view.frame = CGRect(x: (2 * view.width) + 32,
                                    y: 0,
                                    width: view.width,
                                    height: view.height
        )
        
        addChildViewController(leftVc)
        addChildViewController(middleVertScrollVc)
        addChildViewController(rightVc)
        
        scrollView.addSubview(leftVc.view)
        scrollView.addSubview(middleVertScrollVc.view)
        scrollView.addSubview(rightVc.view)
        
        leftVc.didMove(toParentViewController: self)
        middleVertScrollVc.didMove(toParentViewController: self)
        rightVc.didMove(toParentViewController: self)
        
        scrollView.contentOffset.x = middleVertScrollVc.view.frame.origin.x
        scrollView.delegate = self
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.initialContentOffset = scrollView.contentOffset
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if delegate != nil && !delegate!.outerScrollViewShouldScroll() && !directionLockDisabled {
            let newOffset = CGPoint(x: self.initialContentOffset.x, y: self.initialContentOffset.y)
        
            // Setting the new offset to the scrollView makes it behave like a proper
            // directional lock, that allows you to scroll in only one direction at any given time
            self.scrollView!.setContentOffset(newOffset, animated:  false)
        }
        
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.frame.width
        switch page {
        case 0:
            let main: MainViewController = middleVc as! MainViewController
            main.shouldUpdateUI = false
        case 1:
            let main: MainViewController = middleVc as! MainViewController
            main.shouldUpdateUI = true
        case 2:
            let main: MainViewController = middleVc as! MainViewController
            main.shouldUpdateUI = false
            main.hidePopup()
            
            let analytics: AnalyticsViewController = self.rightVc as! AnalyticsViewController
            analytics.checkForShareAndAnimation()
            Answers.logCustomEvent(withName: "Opened Analytics", customAttributes: ["afterPopup" : String(DataManager.today().hasSufficientData)])
        default:
            break
        }
    }
    
    // MARK: - Notifications
    
    func shortcutOpenAnalytics(_ notification: Notification) {
        go(toViewController: .right)
        let analytics: AnalyticsViewController = rightVc as! AnalyticsViewController
        analytics.checkForShareAndAnimation()
    }
    
    func shortcutOpenToneGenerator(_ notification: NSNotification) {
        go(toViewController: .middle)
    }
    
    func darkModeChanged(_ notification: Notification) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let analytics: AnalyticsViewController = storyboard.instantiateViewController(withIdentifier: "analytics") as! AnalyticsViewController
        
        rightVc.removeFromParentViewController()
        rightVc.view.removeFromSuperview()
        
        rightVc = analytics
        let view = (
            x: self.view.bounds.origin.x,
            y: self.view.bounds.origin.y,
            width: self.view.bounds.width,
            height: self.view.bounds.height
        )
        rightVc.view.frame = CGRect(x: (2 * view.width) + 32,
                                    y: 0,
                                    width: view.width,
                                    height: view.height
        )
        
        addChildViewController(rightVc)
        scrollView.addSubview(rightVc.view)
        
        analytics.snapContainer = self
    }
    
    // MARK: - Actions
    
    func transitionLeft(animated: Bool) {
        if animated {
            scrollView.bounces = true
            UIView.animate(withDuration: 0.55, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.6, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
                self.scrollView.contentOffset.x -= self.view.frame.width + 16
            }, completion: { finished in
                self.scrollView.bounces = false
                self.scrollViewDidEndDecelerating(self.scrollView)
            })
        } else {
            scrollView.contentOffset.x -= self.view.frame.width + 16
            scrollViewDidEndDecelerating(scrollView)
        }
    }
    
    func transitionRight(animated: Bool) {
        if animated {
            scrollView.bounces = true
            UIView.animate(withDuration: 0.55, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.6, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
                self.scrollView.contentOffset.x += self.view.frame.width + 16
            }, completion: { finished in
                self.scrollView.bounces = false
                self.scrollViewDidEndDecelerating(self.scrollView)
            })
        } else {
            scrollView.contentOffset.x += self.view.frame.width + 16
            scrollViewDidEndDecelerating(scrollView)
        }
    }
    
    func go(toViewController viewControllerType: SnapContainerViewControllerType) {
        switch viewControllerType {
        case .left:
            scrollView.contentOffset.x = 0
        case .middle:
            scrollView.contentOffset.x = scrollView.frame.width
        case .right:
            scrollView.contentOffset.x = scrollView.frame.width * 2
        }
        scrollViewDidEndDecelerating(scrollView)
    }
    
    // MARK: - Status Bar Style
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
