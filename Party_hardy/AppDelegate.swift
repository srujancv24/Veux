//
//  AppDelegate.swift
//  Party_hardy
//
//  Created by Venkata Srujan Chalasani on 2/24/16.
//  Copyright © 2016 Venkata Srujan Chalasani. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let APP_ID = "B0AF361C-8AA4-CD18-FF63-677A5ACB5200"
    let SECRET_KEY = "C5DB14C3-420E-500E-FFB2-0AABE09E8F00"
    let VERSION_NUM = "v1"

    let backendless = Backendless.sharedInstance()

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool
    {
        
       // print("AppDelegate -> application:openURL: \(url.scheme)")
        
        let backendless = Backendless.sharedInstance()
        let user = backendless.userService.handleOpenURL(url)
        if user != nil {
           // print("AppDelegate -> application:openURL: user = \(user)")
            
            // do something, call some ViewController method, for example
        }
        
        return true

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
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
          
    }


}

