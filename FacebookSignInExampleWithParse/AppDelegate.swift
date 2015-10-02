/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse
//import FBSDKCoreKit
//import ParseFacebookUtilsV4

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    struct SectionSet {
        var section: String!
        var items: [String]!
        var selectedIdx: Int?
    }
    var sectionSets = [SectionSet]()
    
    
    // Populate dummy test data, some teachers, into Parse.
    // This is just testing purpose.
    func populateTeachers() {
        
        let teachers = [
            ("Steve", "123", "TEACHER", "ENGLISH", "$30", ("0.01", "0.02"), "Hi! I am an English teacher!", "AMERICAN", "MALE", "34", "Sep 21, 2015"),
            ("Bill", "123", "TEACHER", "COMPUTER", "$50", ("0.02", "0.01"), "Hi! I am a comupter teacher! I am now available around 49 st and 5 ave. Let't have a class with me!", "JAPANESE", "FEMALE", "41", "Sep 28, 2015"),
            ("Zack", "123", "TEACHER", "MUSIC", "$100", ("-0.01", "-0.02"), "Hi! I am a music teacher!", "GERMAN", "MALE", "21", "Oct 12, 2015")
        ]
        
        for t in teachers {
            
            let teacher = PFUser()
            
            teacher["username"] = t.0
            teacher["password"] = t.1
            teacher["usertype"] = t.2
            teacher["subject"] = t.3
            teacher["fee"] = t.4
            teacher["introduction"] = t.6
            teacher["nationality"] = t.7
            teacher["sex"] = t.8
            teacher["age"] = t.9
            teacher["postedAt"] = t.10
            
            let x: Double = atof(t.5.0)
            let y: Double = atof(t.5.1)
            
            teacher["location"] = PFGeoPoint(latitude: 40.759+x, longitude: -73.984+y)
            
            // Register the teacher
            teacher.signUpInBackgroundWithBlock {
                (succeeded: Bool, error: NSError?) -> Void in
                if let _ = error {
                    print("error!")
                } else {
                    print("success!")
                    PFUser.logOut() // work around.
                }
            }
        }
    }
    
    func populateSettings() {
        
        sectionSets = [
            SectionSet(section: "Area", items: ["New York", "Tokyo", "Singapore", "Others"], selectedIdx: nil),
            SectionSet(section: "Subjects", items: ["English", "Computer", "Arts", "Music", "Others"], selectedIdx: nil),
            SectionSet(section: "Nationality", items: ["American", "Japanese", "Others"], selectedIdx: nil),
            SectionSet(section: "Fee", items: ["$10", "$20", "$30", "$40", "$50+"], selectedIdx: nil)
        ]
    }
    
    //--------------------------------------
    // MARK: - UIApplicationDelegate
    //--------------------------------------
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Parse credentials.
        // !!! Paste your keys here !!!
        Parse.setApplicationId("HmvKrkxXpdNw7pejSvmdRAJBf70tctstYLdulsAB", // Application ID
            clientKey: "Hes81QsRF1EfV05lYJ4337ElX2TiJ9ZW42MVjkS5")         // Client Key
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
        
        //PFUser.enableAutomaticUser()
        
        let defaultACL = PFACL();
        
        // If you would like all objects to be private by default, remove this line.
        //defaultACL.setPublicReadAccess(true)
        
        PFACL.setDefaultACL(defaultACL, withAccessForCurrentUser:false)
        
//        populateTeachers()
//        
//        populateSettings()
        
        return true
    }
    
    //--------------------------------------
    // MARK: Push Notifications
    //--------------------------------------
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackground()
        
        PFPush.subscribeToChannelInBackground("") { (succeeded: Bool, error: NSError?) in
            if succeeded {
                print("ParseStarterProject successfully subscribed to push notifications on the broadcast channel.");
            } else {
                print("ParseStarterProject failed to subscribe to push notifications on the broadcast channel with error = %@.", error)
            }
        }
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        if error.code == 3010 {
            print("Push notifications are not supported in the iOS Simulator.")
        } else {
            print("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PFPush.handlePush(userInfo)
        if application.applicationState == UIApplicationState.Inactive {
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
        }
    }
    
    func application(application: UIApplication,
        openURL url: NSURL,
        sourceApplication: String?,
        annotation: AnyObject) -> Bool {
            return FBSDKApplicationDelegate.sharedInstance().application(application,
                openURL: url,
                sourceApplication: sourceApplication,
                annotation: annotation)
    }
    
    
    //Make sure it isn't already declared in the app delegate (possible redefinition of func error)
    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }
}
