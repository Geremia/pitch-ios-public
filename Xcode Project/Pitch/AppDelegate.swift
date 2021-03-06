//
//  AppDelegate.swift
//  Pitch
//
//  Created by Daniel Kuntz on 9/14/16.
//  Copyright © 2016 Plutonium Apps. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import AudioKit
import RealmSwift
import Siren

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Properties

    var window: UIWindow?
    var container: SnapContainerViewController?
    
    // MARK: - Application Lifecycle

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        updateRealmSchema()
        compactRealm()
        
        updateAnalyticsSharing()
        addShortcutItems(application: application)
        resetAnalyticsAnimationBools()
        Fabric.with([Crashlytics.self])
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        if let shortcutItem = launchOptions?[UIApplicationLaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem {
            handleShortcut(shortcutItem)
        } else {
            Siren.shared.checkVersion(checkType: .daily)
        }

        setRootViewController()
        sendUsageStatistics()
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        if !Constants.pitchPipeIsPlayingSound {
            AudioKit.stop()
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        compactRealm()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        let recordPermissionGranted = UserDefaults.standard.recordPermission()
        let hasSeenOnboarding = UserDefaults.standard.hasSeenOnboarding()
        if !Constants.pitchPipeIsPlayingSound && recordPermissionGranted && hasSeenOnboarding && Mixer.shared.isSetup {
            if !AudioKit.audioInUseByOtherApps() {
                AudioKit.start()
            }
            try! AKSettings.session.overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(handleShortcut(shortcutItem))
    }
    
    // MARK: - Setup
    
    func resetAnalyticsAnimationBools() {
        UserDefaults.standard.setHasSeenAnalyticsAnimation(false)
        let sessions = DataManager.sessions()
        for session in sessions {
            DataManager.setHasSeenAnalyticsAnimation(false, forSession: session)
        }
    }
    
    func setRootViewController() {
        let viewController: UIViewController!
        if UserDefaults.standard.hasSeenOnboarding() {
            Mixer.shared.setUp()
            viewController = snapContainer()
        } else {
            viewController = onboardingViewController()
        }
        
        self.window?.rootViewController = viewController
        self.window?.makeKeyAndVisible()
    }
    
    func snapContainer() -> SnapContainerViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let settings: SettingsViewController = storyboard.instantiateViewController(withIdentifier: "settings") as! SettingsViewController
        let main: MainViewController = storyboard.instantiateViewController(withIdentifier: "main") as! MainViewController
        let analytics: AnalyticsViewController = storyboard.instantiateViewController(withIdentifier: "analytics") as! AnalyticsViewController
        let sessions: SessionsViewController = storyboard.instantiateViewController(withIdentifier: "sessions") as! SessionsViewController
        
        container = SnapContainerViewController.containerViewWith(settings, mainVc: main, analyticsVc: analytics, sessionsVc: sessions)
        
        settings.snapContainer = container
        main.snapContainer = container
        analytics.snapContainer = container
        sessions.snapContainer = container
        
        return container!
    }
    
    func onboardingViewController() -> Onboarding1ViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "onboarding1") as! Onboarding1ViewController
    }
    
    func updateAnalyticsSharing() {
        if UserDefaults.standard.object(forKey: "userBeforeAnalyticsSharing") == nil {
            _ = DataManager.today()
            let isPastUser = DataManager.allDays().count > 1
            UserDefaults.standard.setUserBeforeAnalyticsSharing(isPastUser)
        }
    }
    
    func sendUsageStatistics() {
        if DataManager.allDays().count > 1 {
            Answers.logCustomEvent(withName: "Settings", customAttributes: ["Instrument" : UserDefaults.standard.instrument().description,
                                                                            "Dark Mode On" : String(UserDefaults.standard.darkModeOn()),
                                                                            "Difficulty" : UserDefaults.standard.difficulty().name,
                                                                            "Damping" : UserDefaults.standard.damping().name,
                                                                            "Mic Sensitivity" : UserDefaults.standard.micSensitivity().name])
        }
    }
    
    // MARK: - Realm Setup
    
    func updateRealmSchema() {
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 1,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 1 {
                    migration.enumerateObjects(ofType: Day.className()) { oldObject, newObject in
                        // add new field 'pitchOffsets'
                        newObject!["pitchOffsets"] = List<OffsetData>()
                    }
                } else if oldSchemaVersion < 2 {
                    
                }
        })
        
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
    }
    
    func compactRealm() {
        let defaultURL = Realm.Configuration.defaultConfiguration.fileURL!
        let defaultParentURL = defaultURL.deletingLastPathComponent()
        let compactedURL = defaultParentURL.appendingPathComponent("default-compact.realm")
        
        autoreleasepool {
            let realm = try! Realm()
            try! realm.writeCopy(toFile: compactedURL)
            try! FileManager.default.removeItem(at: defaultURL)
            try! FileManager.default.moveItem(at: compactedURL, to: defaultURL)
        }
    }
    
    // MARK: - 3D Touch Shortcut Handler
    
    func addShortcutItems(application: UIApplication) {
        let analytics = UIMutableApplicationShortcutItem(type: "Analytics", localizedTitle: "Analytics", localizedSubtitle: nil, icon: UIApplicationShortcutIcon(templateImageName: "shortcut_analytics"), userInfo: nil)
        
        let toneGenerator = UIMutableApplicationShortcutItem(type: "ToneGenerator", localizedTitle: "Tone Generator", localizedSubtitle: nil, icon: UIApplicationShortcutIcon(templateImageName: "shortcut_piano"), userInfo: nil)

        application.shortcutItems = [analytics, toneGenerator]
    }
    
    private func handleShortcut(_ shortcutItem: UIApplicationShortcutItem) -> Bool {
        let shortcutType = shortcutItem.type
        guard let shortcutIdentifier = ShortcutIdentifier(fullIdentifier: shortcutType) else {
            return false
        }
        
        switch shortcutIdentifier {
        case .Analytics:
            NotificationCenter.default.post(name: .openAnalytics, object: nil)
        case .ToneGenerator:
            NotificationCenter.default.post(name: .openToneGenerator, object: nil)
        }
        
        return true
    }
}

