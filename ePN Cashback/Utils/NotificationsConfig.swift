//
//  NotificationsConfig.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 30/10/2018.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//

import Foundation
import UserNotifications

public class NotificationsConfig {
    
    class func scheduleLocalNotificationWithTitle(_ notificationCenter: UNUserNotificationCenter, forTitle title: String, time timeInterval: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = title
        content.sound = UNNotificationSound.default
        content.badge = 1
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let identifire = "EPN_Local_Notification"           //Should be unique
        let request = UNNotificationRequest(identifier: identifire, content: content, trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
    }
    
    class func scheduleLocalNotificationWithoutAction(_ notificationCenter: UNUserNotificationCenter, forTitle title: String, forBody body: String, time timeInterval: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        content.badge = 1
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let identifire = "EPN_Local_Notification"           //Should be unique
        let request = UNNotificationRequest(identifier: identifire, content: content, trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
    }
    
    class func scheduleLocalNotificationWithTitleDefaultAction(_ notificationCenter: UNUserNotificationCenter, forTitle title: String, time timeInterval: TimeInterval) {
        let content = UNMutableNotificationContent()
        let defaultAction = "EPN_User_Actions"
        content.title = title
        content.body = title
        content.sound = UNNotificationSound.default
        content.badge = 1
        content.categoryIdentifier = defaultAction
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let identifire = "EPN_Local_Notification"           //Should be unique
        let request = UNNotificationRequest(identifier: identifire, content: content, trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
        
        //Add actions for notifications
        
        let snoozeAction = UNNotificationAction(identifier: "Snooze", title: NSLocalizedString("Notification_Snooze", comment: ""), options: [])
        let deleteAction = UNNotificationAction(identifier: "Delete", title: NSLocalizedString("Notification_Delete", comment: ""), options: [.destructive])
        let category = UNNotificationCategory(identifier: defaultAction, actions: [snoozeAction, deleteAction], intentIdentifiers: [], options: [])
        
        notificationCenter.setNotificationCategories([category])
    }
    
    class func scheduleLocalNotificationDefaultAction(_ notificationCenter: UNUserNotificationCenter, forTitle title: String, forBody body: String, time timeInterval: TimeInterval) {
        let content = UNMutableNotificationContent()
        let defaultAction = "EPN_User Actions"
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        content.badge = 1
        content.categoryIdentifier = defaultAction
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let identifire = "EPN_Local_Notification"           //Should be unique
        let request = UNNotificationRequest(identifier: identifire, content: content, trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
        //Add actions for notifications
        
        let snoozeAction = UNNotificationAction(identifier: "Snooze", title: NSLocalizedString("Notification_Snooze", comment: ""), options: [])
        let deleteAction = UNNotificationAction(identifier: "Delete", title: NSLocalizedString("Notification_Delete", comment: ""), options: [.destructive])
        let category = UNNotificationCategory(identifier: defaultAction, actions: [snoozeAction, deleteAction], intentIdentifiers: [], options: [])
        
        notificationCenter.setNotificationCategories([category])
    }
    
    class func scheduleNotificationWithUserInfo(_ notificationCenter: UNUserNotificationCenter, withUserInfo userInfo: [AnyHashable : Any]) {
        
        let content = UNMutableNotificationContent()
        let defaultAction = "EPN_User Actions"
        
        guard let apsData = userInfo["aps"] as? [String: Any],
        let alert = apsData["alert"] as? NSDictionary,
        let title = alert["title"] as? String,
        let body = alert["body"] as? String else { return }
        
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        content.badge = 1
        content.categoryIdentifier = defaultAction
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 86400, repeats: false) // One day - 60*60*24
        let identifire = "EPN_Local_Notification"           //Should be unique
        let request = UNNotificationRequest(identifier: identifire, content: content, trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
        //Add actions for notifications
        
        let snoozeAction = UNNotificationAction(identifier: "Snooze", title: NSLocalizedString("Notification_Snooze", comment: ""), options: [])
        let deleteAction = UNNotificationAction(identifier: "Delete", title: NSLocalizedString("Notification_Delete", comment: ""), options: [.destructive])
        let category = UNNotificationCategory(identifier: defaultAction, actions: [snoozeAction, deleteAction], intentIdentifiers: [], options: [])
        
        notificationCenter.setNotificationCategories([category])
    }
}
