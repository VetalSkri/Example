//
//  PushNotification+CoreDataClass.swift
//
//
//  Created by Ivan Nikitin on 10/06/2019.
//
//

import Foundation
import CoreData


public class PushNotification: NSManagedObject {
    
    class func fetchPushNotifications(inManagedObjectContext context: NSManagedObjectContext) -> [PushNotification]? {
        let request: NSFetchRequest<PushNotification> = PushNotification.fetchRequest()
        if let notifications = (try? context.fetch(request)) {
            return notifications
        } else {
            return nil
        }
    }
    
    class func getTheMostIdentifier(inManagedObjectContext context: NSManagedObjectContext) -> Int64 {
        let request: NSFetchRequest<PushNotification> = PushNotification.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        if let notifications = (try? context.fetch(request)) {
            return notifications.first?.id ?? 0
        } else {
            return 1
        }
    }
    
    class func fetchPushNotifications(inManagedObjectContext context: NSManagedObjectContext, sortDescriptor: [NSSortDescriptor] = [NSSortDescriptor(key: "date", ascending: false)]) -> [PushNotification]? {
        let request: NSFetchRequest<PushNotification> = PushNotification.fetchRequest()
        request.sortDescriptors = sortDescriptor
        if let notifications = (try? context.fetch(request)) {
            return notifications
        } else {
            return nil
        }
    }
    
    class func searchPushNotification(byTitle title: String, inManagedObjectContext context: NSManagedObjectContext, sortDescriptor: [NSSortDescriptor] = [NSSortDescriptor(key: "date", ascending: false)]) -> [PushNotification]? {
        let request: NSFetchRequest<PushNotification> = PushNotification.fetchRequest()
        var predicates = [NSPredicate]()
        predicates.append(NSPredicate(format: "title CONTAINS[c] %@", title))
        predicates.append(NSPredicate(format: "body CONTAINS[c] %@", title))
        request.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
        request.sortDescriptors = sortDescriptor
        if let notifications = (try? context.fetch(request)) {
            return notifications
        } else {
            return nil
        }
    }
    
    
    class func fetchPushNotifications(inManagedObjectContext context: NSManagedObjectContext, fetchLimit: Int, fetchOffSet: Int = 0, sortDescriptor: [NSSortDescriptor] = [NSSortDescriptor(key: "date", ascending: false)]) -> [PushNotification]? {
        let request: NSFetchRequest<PushNotification> = PushNotification.fetchRequest()
        request.fetchLimit = fetchLimit
        request.fetchOffset = fetchOffSet
        request.sortDescriptors = sortDescriptor
        if let notifications = (try? context.fetch(request)) {
            return notifications
        } else {
            return nil
        }
    }
    
    class func findMessage(byId messageId: Int, inManagedObjectContext context: NSManagedObjectContext) -> PushNotification? {
        let request: NSFetchRequest<PushNotification> = PushNotification.fetchRequest()
        request.predicate = NSPredicate(format: "id == %i", messageId)
        if let message = (try? context.fetch(request))?.first {
            return message
        } else {
            return nil
        }
    }
    
    class func hasUnreadMessage(inManagedObjectContext context: NSManagedObjectContext) -> Bool {
        let request: NSFetchRequest<PushNotification> = PushNotification.fetchRequest()
        request.predicate = NSPredicate(format: "isRead == %@", NSNumber(value: false))
        if let _ = (try? context.fetch(request))?.first {
            return true
        } else {
            return false
        }
    }
}
