//
//  ContainerViewController.swift
//  SnapchatSwipeView
//
//  Created by Jake Spracher on 8/9/15.
//  Copyright (c) 2015 Jake Spracher. All rights reserved.
//

import UIKit
import Crashlytics
import PureLayout

protocol SnapContainerViewControllerDelegate {
    func outerScrollViewShouldScroll() -> Bool
}

enum SnapContainerViewControllerType: Int {
    case settings
    case main
    case analytics
    case sessions
}

class SnapContainerViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: - Properties
    
    var settingsVc: UIViewController!
    var mainVc: UIViewController!
    var analyticsVc: UIViewController!
    var sessionsVc: UIViewController!
    var pageControl: UIPageControl!
    
    var directionLockDisabled: Bool!
    
    var horizontalViews = [UIViewController]()
    var veritcalViews = [UIViewController]()
    
    var initialContentOffset = CGPoint() // scrollView initial offset
    var scrollView: UIScrollView!
    var delegate: SnapContainerViewControllerDelegate?
    
    var currentPage: Int = 1
    
    // MARK: - Setup
    
    class func containerViewWith(_ settingsVc: UIViewController,
                                 mainVc: UIViewController,
                                 analyticsVc: UIViewController,
                                 sessionsVc: UIViewController,
                                 directionLockDisabled: Bool?=false) -> SnapContainerViewController {
        let container = SnapContainerViewController()
        
        container.directionLockDisabled = directionLockDisabled
        
        container.settingsVc = settingsVc
        container.mainVc = mainVc
        container.analyticsVc = analyticsVc
        container.sessionsVc = sessionsVc
        return container
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNotifications()
        setupHorizontalScrollView()
    }
    
    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged(_:)), name: .UIDeviceOrientationDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(shortcutOpenToneGenerator(_:)), name: .openToneGenerator, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(shortcutOpenAnalytics(_:)), name: .openAnalytics, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeChanged(_:)), name: .darkModeChanged, object: nil)
    }
    
    func setupPageControl() {
        pageControl = UIPageControl()
        pageControl.numberOfPages = 4
        pageControl.currentPage = 1
        
        pageControl.autoPinEdge(.bottom, to: .bottom, of: view)
        pageControl.autoAlignAxis(toSuperviewAxis: .horizontal)
        
        view.addSubview(pageControl)
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
        
        let spacing: CGFloat = 16
        let scrollWidth  = (4 * view.width) + (4 * spacing)
        let scrollHeight  = view.height
        scrollView.contentSize = CGSize(width: scrollWidth, height: scrollHeight)
        
        settingsVc.view.frame = CGRect(x: 0,
                                       y: 0,
                                       width: view.width,
                                       height: view.height - 20
        )
        
        mainVc.view.frame = CGRect(x: view.width + spacing,
                                   y: 0,
                                   width: view.width,
                                   height: view.height - 20
        )
        
        analyticsVc.view.frame = CGRect(x: (2 * view.width) + (2 * spacing),
                                        y: 0,
                                        width: view.width,
                                        height: view.height - 20
        )
        
        sessionsVc.view.frame = CGRect(x: (3 * view.width) + (3 * spacing),
                                       y: 0,
                                       width: view.width,
                                       height: view.height - 20
        )
        
        addChildViewController(settingsVc)
        addChildViewController(mainVc)
        addChildViewController(analyticsVc)
        addChildViewController(sessionsVc)
        
        scrollView.addSubview(settingsVc.view)
        scrollView.addSubview(mainVc.view)
        scrollView.addSubview(analyticsVc.view)
        scrollView.addSubview(sessionsVc.view)
        
        settingsVc.didMove(toParentViewController: self)
        mainVc.didMove(toParentViewController: self)
        analyticsVc.didMove(toParentViewController: self)
        sessionsVc.didMove(toParentViewController: self)
        
        scrollView.contentOffset.x = mainVc.view.frame.origin.x
        scrollView.delegate = self
    }
    
    // MARK: - Orientation
    
    func orientationChanged(_ notification: Notification) {
        let orientation = UIDevice.current.orientation
        if orientation == .faceUp || orientation == .faceDown { return }
        
        var view = (
            x: self.view.bounds.origin.x,
            y: self.view.bounds.origin.y,
            width: self.view.bounds.width,
            height: self.view.bounds.height
        )
        
        // For some reason a weird bug occurs here only after going through onboarding. This ViewController thinks it's in landscape when it's actually
        // in portrait and vice versa. This fixes it.
        
        if (UIDeviceOrientationIsLandscape(orientation) && view.width < view.height) || (UIDeviceOrientationIsPortrait(orientation) && view.width > view.height) {
            view.width = self.view.bounds.height
            view.height = self.view.bounds.width
        }
        
        UIView.transition(with: self.view, duration: 0.2, options: [.transitionCrossDissolve], animations: {
            self.scrollView.frame = CGRect(x: view.x,
                                      y: view.y,
                                      width: view.width + 16,
                                      height: view.height
            )
            
            let spacing: CGFloat = 16
            let scrollWidth  = (4 * view.width) + (4 * spacing)
            let scrollHeight  = view.height
            self.scrollView.contentSize = CGSize(width: scrollWidth, height: scrollHeight)
            
            self.settingsVc.view.frame = CGRect(x: 0,
                                       y: 0,
                                       width: view.width,
                                       height: view.height - 20
            )
            
            self.mainVc.view.frame = CGRect(x: view.width + spacing,
                                         y: 0,
                                         width: view.width,
                                         height: view.height - 20
            )
            
            self.analyticsVc.view.frame = CGRect(x: (2 * view.width) + (2 * spacing),
                                        y: 0,
                                        width: view.width,
                                        height: view.height - 20
            )
            
            self.sessionsVc.view.frame = CGRect(x: (3 * view.width) + (3 * spacing),
                                                 y: 0,
                                                 width: view.width,
                                                 height: view.height - 20
            )
            
            self.scrollView.contentOffset.x = CGFloat(self.currentPage) * view.width + CGFloat(self.currentPage) * spacing
        }, completion: nil)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
    
    // MARK: - UIScrollViewDelegate Methods
    
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
        currentPage = Int(scrollView.contentOffset.x / scrollView.frame.width)
        
        switch currentPage {
        case 0:
            let main: MainViewController = mainVc as! MainViewController
            main.shouldUpdateUI = false
        case 1:
            let main: MainViewController = mainVc as! MainViewController
            main.shouldUpdateUI = true
        case 2:
            let main: MainViewController = mainVc as! MainViewController
            main.shouldUpdateUI = false
            main.hidePopup()
            
            let analytics: AnalyticsViewController = self.analyticsVc as! AnalyticsViewController
            analytics.checkForShareAndAnimation()
            Answers.logCustomEvent(withName: "Opened Analytics", customAttributes: ["afterPopup" : String(DataManager.today().hasSufficientData)])
        default:
            break
        }
    }
    
    // MARK: - Notifications
    
    func shortcutOpenAnalytics(_ notification: Notification) {
        go(toViewController: .analytics)
        let analytics: AnalyticsViewController = analyticsVc as! AnalyticsViewController
        analytics.checkForShareAndAnimation()
    }
    
    func shortcutOpenToneGenerator(_ notification: NSNotification) {
        go(toViewController: .main)
    }
    
    func darkModeChanged(_ notification: Notification) {
        resetAnalyticsVC()
    }
    
    // MARK: - Actions
    
    func resetAnalyticsVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let analytics: AnalyticsViewController = storyboard.instantiateViewController(withIdentifier: "analytics") as! AnalyticsViewController
        
        analyticsVc.removeFromParentViewController()
        analyticsVc.view.removeFromSuperview()
        
        analyticsVc = analytics
        let view = (
            x: self.view.bounds.origin.x,
            y: self.view.bounds.origin.y,
            width: self.view.bounds.width,
            height: self.view.bounds.height
        )
        analyticsVc.view.frame = CGRect(x: (2 * view.width) + 32,
                                        y: 0,
                                        width: view.width,
                                        height: view.height - 20
        )
        
        addChildViewController(analyticsVc)
        scrollView.addSubview(analyticsVc.view)
        
        analytics.snapContainer = self
    }
    
    func transitionLeft(animated: Bool, completion: (() -> Void)? = nil) {
        if let viewController = SnapContainerViewControllerType(rawValue: currentPage - 1) {
            go(toViewController: viewController, animated: animated, completion: completion)
        }
    }
    
    func transitionRight(animated: Bool, completion: (() -> Void)? = nil) {
        if let viewController = SnapContainerViewControllerType(rawValue: currentPage + 1) {
            go(toViewController: viewController, animated: animated, completion: completion)
        }
    }
    
    func go(toViewController viewControllerType: SnapContainerViewControllerType, animated: Bool = false, completion: (() -> Void)? = nil) {
        if animated {
            scrollView.isUserInteractionEnabled = false
            scrollView.bounces = true
            UIView.animate(withDuration: 0.55, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.6, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
                self.scrollView.contentOffset.x = self.scrollView.frame.width * CGFloat(viewControllerType.rawValue)
            }, completion: { finished in
                self.scrollView.isUserInteractionEnabled = true
                self.scrollView.bounces = false
                self.scrollViewDidEndDecelerating(self.scrollView)
                if let completion = completion {
                    completion()
                }
            })
        } else {
            scrollView.contentOffset.x = scrollView.frame.width * CGFloat(viewControllerType.rawValue)
            scrollViewDidEndDecelerating(scrollView)
            if let completion = completion {
                completion()
            }
        }
    }
    
    // MARK: - Status Bar Style
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
