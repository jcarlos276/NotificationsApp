//
//  AppDelegate.swift
//  NotificationApp
//
//  Created by Juan Carlos Guillén Castro on 7/24/19.
//  Copyright © 2019 Juan Carlos Guillén Castro. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift
import Fabric
import Answers

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Fabric.sharedSDK().debug = true
        Fabric.with([Answers.self])
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print("USERINFO ----> \(userInfo)")
        saveNotification(withUserInfo: userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        saveNotification(withUserInfo: userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
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
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func saveNotification(withUserInfo userInfo: [AnyHashable : Any]) -> NotificationModel {
        let notification = NotificationModel()
        notification.set(withUserInfo: userInfo)
        let realm = try! Realm()
        try! realm.write {
            realm.add(notification, update: true)
        }
        NotificationCenter.default.post(name: Notification.Name.init("newNotification"), object: self, userInfo: nil)
        
        return notification
    }


}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //ANTES DE MOSTRAR LA BURBUJA
        completionHandler([.alert, .badge, .sound])
        let userInfo = notification.request.content.userInfo
        saveNotification(withUserInfo: userInfo)
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        //TAP EN LA BURBUJA
        let userInfo = response.notification.request.content.userInfo
        print("--------------------NOTIFICATION-----------------------")
        print("\(userInfo)")
        print("--------------------NOTIFICATION-----------------------")
        let notification = saveNotification(withUserInfo: userInfo)
        
        if let navVC = window?.rootViewController as? UINavigationController {
            if let homeVC = navVC.topViewController as? HomeViewController {
                homeVC.showDetail(ofNotification: notification)
            } else {
                navVC.popToRootViewController(animated: true)
            }
        }
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("InstanceID token: \(fcmToken)")
        UserDefaults.standard.set(fcmToken, forKey: "FCMToken")
        NotificationCenter.default.post(name: Notification.Name.init("newNotification"), object: self, userInfo: nil)
    }
}
