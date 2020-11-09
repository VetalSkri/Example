//
//  MessageFile+CoreDataClass.swift
//  Backit
//
//  Created by Александр Кузьмин on 04/12/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//
//

import Foundation
import CoreData


public class MessageFile: NSManagedObject {
    
    class func fetch(inManagedObjectContext context: NSManagedObjectContext) -> [MessageFile]? {
        let request: NSFetchRequest<MessageFile> = MessageFile.fetchRequest()
        if let messageFiles = (try? context.fetch(request)) {
            return messageFiles
        } else {
            return nil
        }
    }
    
    class func find(byId id: Int64, inManagedObjectContext context: NSManagedObjectContext) -> MessageFile? {
        let request: NSFetchRequest<MessageFile> = MessageFile.fetchRequest()
        var predicates = [NSPredicate]()
        predicates.append(NSPredicate(format: "id == %ld", id))
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        if let messageFile = (try? context.fetch(request))?.first {
            return messageFile
        } else {
            return nil
        }
    }
    
    class func find(byMessageId messageId: Int64, inManagedObjectContext context: NSManagedObjectContext) -> [MessageFile]? {
        let request: NSFetchRequest<MessageFile> = MessageFile.fetchRequest()
        var predicates = [NSPredicate]()
        predicates.append(NSPredicate(format: "messageId == %ld", messageId))
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        if let messageFile = (try? context.fetch(request)) {
            return messageFile
        } else {
            return nil
        }
    }
    
    class func getTheMostIdentifier(inManagedObjectContext context: NSManagedObjectContext) -> Int64 {
        let request: NSFetchRequest<MessageFile> = MessageFile.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        if let messageFiles = (try? context.fetch(request)) {
            return messageFiles.first?.id ?? 0
        } else {
            return 1
        }
    }
}
