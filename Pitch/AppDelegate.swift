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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        updateRealmSchema()
        updateAnalyticsSharing()
        Fabric.with([Crashlytics.self])
        UserDefaults.standard.setHasSeenAnalyticsAnimation(false)
        UIApplication.shared.isIdleTimerDisabled = true

        return true
    }
    
    func updateAnalyticsSharing() {
        if UserDefaults.standard.object(forKey: "userBeforeAnalyticsSharing") == nil {
            _ = DataManager.today()
            let isPastUser = DataManager.data(forPastDaysIncludingToday: 10).count > 1
            UserDefaults.standard.setUserBeforeAnalyticsSharing(isPastUser)
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
        
        let recordPermissionGranted = UserDefaults.standard.recordPermission()
        if !Constants.pitchPipeIsPlayingSound && recordPermissionGranted {
            AudioKit.start()
            do {
                try AKSettings.setSession(category: .playAndRecord, with: .defaultToSpeaker)
            } catch {
                print("Error setting category.")
            }
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

