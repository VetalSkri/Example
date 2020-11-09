//
//  Message+CoreDataClass.swift
//  Backit
//
//  Created by Александр Кузьмин on 04/12/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//
//

import Foundation
import CoreData


public class Message: NSManagedObject {
    
    class func fetch(inManagedObjectContext context: NSManagedObjectContext) -> [Message]? {
        let request: NSFetchRequest<Message> = Message.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        if let messages = (try? context.fetch(request)) {
            return messages
        } else {
            return nil
        }
    }
    
    class func find(byId id: Int64, inManagedObjectContext context: NSManagedObjectContext) -> Message? {
        let request: NSFetchRequest<Message> = Message.fetchRequest()
        var predicates = [NSPredicate]()
        predicates.append(NSPredicate(format: "id == %ld", id))
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        if let message = (try? context.fetch(request))?.first {
            return message
        } else {
            return nil
        }
    }
    
    class func find(byTicketId ticketId: Int64, inManagedObjectContext context: NSManagedObjectContext) -> [Message]? {
        let request: NSFetchRequest<Message> = Message.fetchRequest()
        var predicates = [NSPredicate]()
        predicates.append(NSPredicate(format: "replyToId == %ld", ticketId))
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        if let messages = (try? context.fetch(request)) {
            return messages
        } else {
            return nil
        }
    }
    
    class func getTheMostIdentifier(inManagedObjectContext context: NSManagedObjectContext) -> Int64 {
        let request: NSFetchRequest<Message> = Message.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        if let messages = (try? context.fetch(request)) {
            return messages.first?.id ?? 0
        } else {
            return 1
        }
    }
    
}
