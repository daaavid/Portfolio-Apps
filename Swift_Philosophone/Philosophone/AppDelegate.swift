//
//  AppDelegate.swift
//  Philosophone
//
//  Created by david on 12/4/15.
//  Copyright © 2015 The Iron Yard. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Sound], categories: nil)
        application.registerUserNotificationSettings(settings)

        let options = launchOptions ?? [NSObject : AnyObject]()
        if let _ = options[UIApplicationLaunchOptionsLocalNotificationKey] as? UILocalNotification
        {
            print("found launch options")
            getMainVC().notificationPopped()
        }
        
        return true
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification)
    {
        getMainVC().notificationPopped()
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication)
    {
        getMainVC().saveSettings()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication)
    {
        getMainVC().loadSettings()
    }

    func applicationWillTerminate(application: UIApplication)
    {
        getMainVC().saveSettings()
    }

    func getMainVC() -> MainViewController
    {
        let navC = window?.rootViewController as! UINavigationController
        let mainVC = navC.viewControllers[0] as! MainViewController
        return mainVC
    }
}

