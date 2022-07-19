//
//  AppDelegate.swift
//  videoChamp
//
//  Created by iOS Developer on 15/02/22.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import FirebaseMessaging
import Firebase
import UserNotifications
import MultipeerConnectivity

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

var window: UIWindow?

    var orientationLock = UIInterfaceOrientationMask.all
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.resignFirstResponder()
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        registerForPushNotification()
//        let notificationCenter = UNUserNotificationCenter.current()
//        
//        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { success, _ in
//            guard success else {return}
//            print("success in APNS Registry")
//
//        }
//        let content = UNMutableNotificationContent()
//        content.sound = .default
//        let triggered = UNTimeIntervalNotificationTrigger.init(timeInterval: 1.0, repeats: false)
//        
//        let request = UNNotificationRequest.init(identifier: UUID().uuidString, content: content, trigger: triggered)
//        
//        notificationCenter.add(request) { (error) in
//            print(error?.localizedDescription ?? "")
//        }
//        application.registerForRemoteNotifications()
        return true
    }
    
//    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
//        return self.orientationLock
//    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print(url)
        let array = url.path.components(separatedBy: "/")
        let myPeerID = array[array.count-2]
//        let myPeerID = MCPeerID(displayName: urlName)
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let profileViewController = mainStoryboard.instantiateViewController(withIdentifier: "SplashVC") as! SplashVC

        if array[array.count-4] == "false"{
            profileViewController.redirectType = .camera
            profileViewController.myPeerID = myPeerID
            profileViewController.verified_Code = array[array.count-1]
            profileViewController.userID = array[array.count-7]
            profileViewController.isCamera = array[array.count-4]
            
            videochampManager.videochamp_sharedManager.redirectType  = .camera
        }else if array[array.count-4] == "true" {
//            CMJoinLink(verifyNumber: array[array.count-1], userID: array[array.count-7])
            profileViewController.myPeerID = myPeerID
            profileViewController.verified_Code = array[array.count-1]
            profileViewController.userID = array[array.count-7]
            print("Generated Code : \(array[array.count-1])")
            profileViewController.isCamera = array[array.count-4]
            profileViewController.redirectType = .remote
            videochampManager.videochamp_sharedManager.redirectType  = .remote
        }else{
            profileViewController.redirectType = .none
        }
        if let navController = UIApplication.getNavController() {
             //do something with rootViewController
            navController.pushViewController(profileViewController, animated: true)
        }
        return true
    }
    

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "videoChamp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}


//MARK: - Push notification


extension AppDelegate : MessagingDelegate, UNUserNotificationCenterDelegate {
    
    private func registerForPushNotification() {
        
        // REGISTER FOR PUSH NOTIFICATIONS
        let center  = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert,.sound,.badge]) { (granted, error) in
            // Enable or disable features based on authorization
            print("Is Notification granted : \(granted)")
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
        
        let action1 = UNNotificationAction(identifier: "action1", title: "Action First", options: [.foreground])
        let action2 = UNNotificationAction(identifier: "action2", title: "Action Second", options: [.foreground])
        let category = UNNotificationCategory(identifier: "actionCategory", actions: [action1,action2], intentIdentifiers: [], options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let info = notification.request.content.userInfo
        print("Notification Info : \(info)") // the payload that is attached to the push notification
        completionHandler([.alert,.sound, .badge])
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        messaging.token { token, _  in
            guard let token = token else {
                return
            }
            print("FCM Token : \(token)")
            UserDefaults.standard.set(token, forKey: "deviceToken")
        }
        
        print("Token = \(fcmToken ?? "")")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("Device Token: \(token)")
        //fcmToken = token 
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failted to register for notification :( \(error)")
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Handle push from background or closed")
        // if you set a member variable in didReceiveRemoteNotification, you  will know if this is from closed or background
        print("\(response.notification.request.content.userInfo)")
        
    }
    
}



class videochampManager
{
    
    static let videochamp_sharedManager = videochampManager()
    var redirectType : RedirectVC = .none
    var _captureState : _CaptureState = .idle

}

struct AppUtility {

    static let shared = AppUtility()

    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {

        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }

    /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
        self.lockOrientation(orientation)
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }

}


