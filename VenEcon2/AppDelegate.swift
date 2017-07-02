//
//  AppDelegate.swift
//  VenEcon2
//
//  Created by Girish Gupta on 08/08/2016.
//  Copyright © 2016 Girish Gupta. All rights reserved.
//

import UIKit
import Inapptics


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        // Override point for customization after application launch.
        registerForPushNotifications(application: application) // 20161126 Spent forever thinking something up with capabilities/provisioning profiles etc. But hadn't uncommented this line!
        
        //if let notification = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? [String: AnyObject] {
         //   let aps = notification["aps"] as! [String: AnyObject]
            //Notificaion and app was opened new. Don't really want to do anything.
            
        //}
        
        Inapptics.letsGo(withAppToken: "b3DOF1vPXE8K0kBV97bF46Bo0kRKr05o1JQ9Aeym")
        //https://inapptics.com/integration-guide.html?t=NqJsdrRWyCGjzjFR7hAx6yyL7GcYEVJ31PVvZImj&_ga=2.213760988.995553334.1498954087-41180827.1498954087
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    func registerForPushNotifications(application: UIApplication) {
        let notificationSettings = UIUserNotificationSettings(
            types: [.badge, .sound, .alert], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != .none {
            application.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var tokenString = ""
        for i in 0..<deviceToken.count {
            tokenString = tokenString + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        
        print("Device Token:", tokenString)
        
        let defaults = UserDefaults.standard
        defaults.set(tokenString, forKey: "DeviceToken")        
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register:", error)
    }
    
    
    


}

