//
//  AppDelegate.swift
//  Opin
//
//  Created by Brian Vallelunga on 9/12/15.
//  Copyright (c) 2015 Brian Vallelunga. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let infoDictionary = NSBundle.mainBundle().infoDictionary!
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        //Initialize Parse
        ParseCrashReporting.enable()
        Parse.setApplicationId("kZkm35gPYdZKT7dAAie6MYUhSQGiJLrzvdjuHjCi", clientKey: "C8BrrahLYrYx4j4ijlk27PpjmPx1xDda1cPA4xHf")
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        // Track an app open here if we launch with a push, unless
        // "content_available" was used to trigger a background push (introduced
        // in iOS 7). In that case, we skip tracking here to avoid double
        // counting the app-open.
        if application.applicationState != UIApplicationState.Background {
            let preBackgroundPush = !application.respondsToSelector(Selector("backgroundRefreshStatus"))
            let oldPushHandlerOnly = !self.respondsToSelector(Selector("application:didReceiveRemoteNotification:fetchCompletionHandler:"))
            let noPushPayload = (launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey] == nil)
            
            if preBackgroundPush || oldPushHandlerOnly || noPushPayload {
                PFAnalytics.trackAppOpenedWithLaunchOptionsInBackground(launchOptions, block: nil)
            }
        }
        
        // Update Config
        Config.update(nil)
        
        // Configure Settings Panel
        var versionBuild = Global.appBuildVersion()        
        userDefaults.setValue(versionBuild, forKey: "VersionNumber")
        userDefaults.synchronize()
        
        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        Installation.current().setDeviceToken(deviceToken)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        var wasActive = true
        var actions: [String]!
        
        if application.applicationState == UIApplicationState.Inactive {
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayloadInBackground(userInfo, block: nil)
            wasActive = false
        }
        
        if let tempActions = userInfo["actions"] as? String {
            actions = tempActions.componentsSeparatedByString(",")
        } else if let tempAction = userInfo["action"] as? String {
            actions = [tempAction]
        }
        
        if actions != nil && !actions.isEmpty {
            for (var action) in actions {
                var title = userInfo["title"] as? String
                var message = userInfo["message"] as? String
                
                action = action.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                
                switch(action) {
                default: println(action)
                }
            }
        }
        
        Installation.current().clearBadge()
        completionHandler(UIBackgroundFetchResult.NewData)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

