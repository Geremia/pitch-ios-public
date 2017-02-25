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

    var window: UIWindow?
    var container: SnapContainerViewController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        updateRealmSchema()
        updateAnalyticsSharing()
        addShortcutItems(application: application)
        Fabric.with([Crashlytics.self])
        UserDefaults.standard.setHasSeenAnalyticsAnimation(false)
        UIApplication.shared.isIdleTimerDisabled = true
        
        if let shortcutItem = launchOptions?[UIApplicationLaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem {
            handleShortcut(shortcutItem)
        } else {
            Siren.sharedInstance.checkVersion(checkType: .daily)
        }

        setupSnapContainer()
        Mixer.sharedInstance.setUp()
        
        sendUsageStatistics()
        
        return true
    }
    
    func setupSnapContainer() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let settings: SettingsViewController = storyboard.instantiateViewController(withIdentifier: "settings") as! SettingsViewController
        let main: MainViewController = storyboard.instantiateViewController(withIdentifier: "main") as! MainViewController
        let analytics: AnalyticsViewController = storyboard.instantiateViewController(withIdentifier: "analytics") as! AnalyticsViewController
        
        container = SnapContainerViewController.containerViewWith(settings, middleVC: main, rightVC: analytics)
        
        settings.snapContainer = container
        main.snapContainer = container
        analytics.snapContainer = container
        
        self.window?.rootViewController = container
        self.window?.makeKeyAndVisible()
    }
    
    func updateAnalyticsSharing() {
        if UserDefaults.standard.object(forKey: "userBeforeAnalyticsSharing") == nil {
            _ = DataManager.today()
            let isPastUser = DataManager.data(forPastDaysIncludingToday: 10).count > 1
            UserDefaults.standard.setUserBeforeAnalyticsSharing(isPastUser)
        }
    }
    
    func sendUsageStatistics() {
        if DataManager.data(forPastDaysIncludingToday: 10).count > 1 {
            Answers.logCustomEvent(withName: "Settings", customAttributes: ["Instrument" : UserDefaults.standard.instrument().description,
                                                                            "Dark Mode On" : String(UserDefaults.standard.darkModeOn()),
                                                                            "Difficulty" : UserDefaults.standard.difficulty().description,
                                                                            "Damping" : UserDefaults.standard.damping().description,
                                                                            "Mic Sensitivity" : UserDefaults.standard.micSensitivity().name])
        }
    }
    
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
                }
        })
        
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
    }
    
    func addShortcutItems(application: UIApplication) {
        let analytics = UIMutableApplicationShortcutItem(type: "Analytics", localizedTitle: "Analytics", localizedSubtitle: nil, icon: UIApplicationShortcutIcon(templateImageName: "shortcut_analytics"), userInfo: nil)
        
        let toneGenerator = UIMutableApplicationShortcutItem(type: "ToneGenerator", localizedTitle: "Tone Generator", localizedSubtitle: nil, icon: UIApplicationShortcutIcon(templateImageName: "shortcut_piano"), userInfo: nil)

        application.shortcutItems = [analytics, toneGenerator]
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(handleShortcut(shortcutItem))
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
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        let recordPermissionGranted = UserDefaults.standard.recordPermission()
        if !Constants.pitchPipeIsPlayingSound && recordPermissionGranted {
            if !AudioKit.audioInUseByOtherApps() {
                AudioKit.start()
            }
            try! AKSettings.session.overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

