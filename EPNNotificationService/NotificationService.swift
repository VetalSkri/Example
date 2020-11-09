//
//  NotificationService.swift
//  EPNNotificationService
//
//  Created by Ivan Nikitin on 30/10/2018.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    //MARK: it's work for fcm by use postman. We need to choose some parameters which we're going to use in the future
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        guard let bestAttemptContent = bestAttemptContent,
//            let apsData = bestAttemptContent.userInfo["aps"] as? [String: Any],
//            let alert = apsData["alert"] as? NSDictionary,
//            let title = alert["title"] as? String,
//            let body = alert["body"] as? String,
//            let attachmentURLAsString = bestAttemptContent.userInfo["attachment-url"] as? String else { return }
//        bestAttemptContent.body = "Edit push notification with old body \(body)"
//        bestAttemptContent.title = "changed title with \(title)"
//        contentHandler(bestAttemptContent)
        let apsData = bestAttemptContent.userInfo["aps"] as? [String: Any],
        let alert = apsData["alert"] as? NSDictionary,
        let title = alert["title"] as? String,
        let body = alert["body"] as? String  else { return }
        bestAttemptContent.body = "Edit push notification with old body \(body)"
        bestAttemptContent.title = "changed title with \(title)"
        contentHandler(bestAttemptContent)
    }

    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
}

