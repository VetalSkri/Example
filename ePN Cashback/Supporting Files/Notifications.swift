//
//  NotificationConfig.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 29/10/2018.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import FirebaseMessaging

public class Notifications: NSObject, UNUserNotificationCenterDelegate {
    
    let notificationMessaging = Messaging.messaging()
    let notificationCenter = UNUserNotificationCenter.current()
    static let shared = Notifications()
    
    private override init(){}
    
    //MARK: - request Authorization of notification service
    func requestAuthorization() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { ( granted, error) in
            print("Permission granted: \(granted)")
            
            guard granted else { return }
            self.getNotificationSettings()
        }
    }
    
    //MARK: - get settings of notification service and register for remote notifications,
    func getNotificationSettings() {
        notificationCenter.getNotificationSettings { (settings) in
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    //MARK: - set up custom category for notifications
    func setCategoryAction() {
        let defaultAction = "EPN_User_Actions"
        
        let snoozeAction = UNNotificationAction(identifier: "Snooze", title: NSLocalizedString("Notification_Snooze", comment: ""), options: [])
        let deleteAction = UNNotificationAction(identifier: "Delete", title: NSLocalizedString("Notification_Delete", comment: ""), options: [.destructive])
        let category = UNNotificationCategory(identifier: defaultAction, actions: [snoozeAction, deleteAction], intentIdentifiers: [], options: [])
        notificationCenter.setNotificationCategories([category])
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.identifier == "Local Notification" {
            print("handling notification with the local Notification Identifier")
        }
        print("MYLOG: userNotificationCenter didReceive \(response.notification.request.content.userInfo)")
        //Action
        switch response.actionIdentifier {
        case UNNotificationDismissActionIdentifier:
            break
        case UNNotificationDefaultActionIdentifier:
            let userInfo = response.notification.request.content.userInfo
            PushHandler.handle(data: userInfo)
            break
//            UIApplication.shared.open(URL(string: Util.message)!, options: [:], completionHandler: nil)
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            appDelegate.router.trigger(.prepareDeepLink)
//            appDelegate.router.trigger(.deepLinkNotifications)
            
//            let messageStoryboard = UIStoryboard(name: "Message", bundle: nil)
//            let messageVC = messageStoryboard.instantiateViewController(withIdentifier: "MessageVC")
//            let rootNavigationController = UINavigationController(rootViewController: messageVC)
//            (UIApplication.shared.delegate as! AppDelegate?)?.window?.rootViewController = rootNavigationController
//            TODO: - can be used for open another window for unique identifier
            //            let storyboard = UIStoryboard.init(name: "ShopsMain", bundle: nil)
            //            let mainController = storyboard.instantiateViewController(withIdentifier: "ShopsMainViewControllerID")
        //            self.window?.rootViewController = mainController
        case "Snooze":
            print("Snooze action")
            NotificationsConfig.scheduleNotificationWithUserInfo(notificationCenter, withUserInfo: response.notification.request.content.userInfo)
            break
        case "Delete":
            print("Delete action")
            break
        default:
            print("Unknow action")
            break
        }
        
        completionHandler()
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("MYLOG: userNotificationCenter will Present \(notification.request.content.userInfo)")
        completionHandler([.alert, .sound, .badge])
    }
    
    func savePushData(userInfo: [AnyHashable: Any]) {
        print("MYLOG: savePushData in:")
        if let title = userInfo["title"] as? String {
            if let text = userInfo["text"] as? String {
                let autoincrementedId = CoreDataStorageContext.shared.getPushNotificationAutoincrementedId()
                let message = LocalNotification(id: autoincrementedId, title: title, body: text, date: Date(), isRead: false)
                CoreDataStorageContext.shared.add(object: message)
                print("MYLOG: Push meesage success save in coredata: \(userInfo)")
            }
        }
    }
}

//MARK: - Extension for Firebase notifications, get firebase token
extension Notifications: MessagingDelegate {

    public func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("MYLOG: Firebase registration token: \(fcmToken)\n")
        let localToken = Util.getFcmToken()
        if ((localToken == nil || localToken != fcmToken) && Session.shared.access_token != nil) {
            PushApiClient.sendToken(token: fcmToken) { (result) in
                switch result {
                case .success(_):
                    print("MYLOG: Success send push firebase token!")
                    Util.saveFcmToken(token: fcmToken)
                    break
                case .failure(let error):
                    print("MYLOG: send FCM firebase token. Error: \(error.localizedDescription)")
                    break
                }
            }
        }
    }
    
}

//TODO: - For notificationServiceextension
//override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
//    print("didReceive function called \n")
//    self.contentHandler = contentHandler
//    bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
//    print("the content from firebase is \(bestAttemptContent)\n")
//    guard let bestAttemptContent = bestAttemptContent,
//        let apsData = bestAttemptContent.userInfo["aps"] as? [String: Any],
//        let alert = apsData["alert"] as? NSDictionary,
//        let title = alert["title"] as? String,
//        let body = alert["body"] as? String,
//        let attachmentURLAsString = apsData["attachment-url"] as? String else { return }
//    print("The attachmentURLAsString is \(attachmentURLAsString)")
//    print("The title is \(title)")
//    print("The body is \(body)")
//    bestAttemptContent.body = "Edit push notification with old body \(body)"
//    bestAttemptContent.body = "changed title with \(title)"
//    contentHandler(bestAttemptContent)
//}
//
//override func serviceExtensionTimeWillExpire() {
//    // Called just before the extension will be terminated by the system.
//    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
//    if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
//        contentHandler(bestAttemptContent)
//    }
//}
//
//}
//
