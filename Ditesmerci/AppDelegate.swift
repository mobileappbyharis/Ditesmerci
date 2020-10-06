//
//  AppDelegate.swift
//  Ditesmerci
//
//  Created by 7k04 on 10/06/2019.
//  Copyright © 2019 mobileappbyharis. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDynamicLinks
import FirebaseMessaging
import FirebaseFirestore
import GoogleMaps
import GooglePlaces
import UserNotifications
import NotificationBannerSwift
import CoreLocation

//import Stripe
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    var db: Firestore?
    var handle: AuthStateDidChangeListenerHandle?
    var bool = false

    let API_key_google_maps = "AIzaSyBSslT3Zm9HpxaABQjE3Fg0Kysv6ic1HLs"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        GMSServices.provideAPIKey(API_key_google_maps)
        GMSPlacesClient.provideAPIKey(API_key_google_maps)
//        Stripe.setDefaultPublishableKey("pk_test_3A3CCiFzS2yHMxJnQ3vj5KCk00okfoZ2nz")
        notificationSettings(application: application)
        UNUserNotificationCenter.current().delegate = self
        UITabBar.appearance().tintColor = .blueMerci
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        let launchScreenViewController = LaunchScreenViewController()
        let nav = UINavigationController(rootViewController: launchScreenViewController)
        nav.setNavigationBarHidden(true, animated: false)
        window?.rootViewController = nav
        return true
    }
    
    // get token notification
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let firebaseAuth = Auth.auth()
        firebaseAuth.setAPNSToken(deviceToken, type: AuthAPNSTokenType.unknown)
        setNotificationTokensToFirestore()
    }
    
    // receive notification
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let dict = userInfo["aps"] as? NSDictionary{
            let message: String
            message = dict["alert"] as! String
            print("%@", message )
            let banner = NotificationBanner(title: "Dites Merci", subtitle: message, style: .info)
            DispatchQueue.main.async {
              banner.show()
            }
        }
        let firebaseAuth = Auth.auth()
        if (firebaseAuth.canHandleNotification(userInfo)){
            print(userInfo)
            return
        }
    }
    
    func handleIncomingDynamicLink(_ dynamicLink: DynamicLink) {
        guard let url = dynamicLink.url else {
            print("That's weird. My dynamic link object has no url")
            return
        }
        print("Your incoming link parameter is \(url.absoluteString)")
        
        guard (dynamicLink.matchType == .unique || dynamicLink.matchType == .default) else {
            // Not a strong enough match. Let's just not do anything
            print("Not a strong enough match type to continue")
            return
        }
        
        // Parse the link parameter
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false), let queryItems = components.queryItems else {return}
        
        
        for queryItem in queryItems {
            print("Parameter \(queryItem.name) has a value of \(queryItem.value ?? "")")
        }
        
        
        if components.path == "/invite" {
            
        } else if components.path == "/profil" {
            if let uidQueryItem = queryItems.first(where: {$0.name == "uid"}) {
                guard let uid = uidQueryItem.value else {return}
                
            }
            
        }
    }
    
    
    
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if let incomingURL = userActivity.webpageURL {
            print("Incoming URL is \(incomingURL)")
            let linkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL)
            { (dynamicLink, error) in
                guard error == nil else {
                    print("Found an error! \(error!.localizedDescription)")
                    return
                }
                if let dynamicLink = dynamicLink {
                    self.handleIncomingDynamicLink(dynamicLink)
                }
                
            }
            if linkHandled {
                return true
            } else {
                // Maybe do other things with our incoming URL?
                return false
            }
        }
        return false
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
            self.handleIncomingDynamicLink(dynamicLink)
            return true
        } else {
            // Maybe handle Google or Facebook sign-in here
            return false
        }
    }
    
    
    func notificationSettings(application: UIApplication){
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
                if granted {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
            application.registerForRemoteNotifications()
        } else {
            let notificationSettings = UIUserNotificationSettings(types: [.badge, .alert, .sound], categories: nil)
            UIApplication.shared.registerForRemoteNotifications()
            UIApplication.shared.registerUserNotificationSettings(notificationSettings)
            
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case UNNotificationDismissActionIdentifier:
            print("Dismiss Action")
        case UNNotificationDefaultActionIdentifier:
            print("Open Action")
        case "Snooze":
            print("Snooze")
        case "Delete":
            print("Delete")
        default:
            print("default")
        }
        completionHandler()
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
        
        application.applicationIconBadgeNumber = 0
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    private func setNotificationTokensToFirestore(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        db = Firestore.firestore()
        db?.collection("users").document(uid).getDocument { (document, error) in
            if let document = document, document.exists {
                //User hava data in firestore
                let token = Messaging.messaging().fcmToken
                self.db?.collection("users").document(uid).setData([ "notificationTokens": token ?? "none" ], merge: true)
            } else {
                //User don't have data in firestore
                print("Document does not exist")
            }
        }
    }
}


