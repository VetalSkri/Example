//
//  OfflineOffer+CoreDataClass.swift
//  Backit
//
//  Created by Ivan Nikitin on 09/10/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//
//

import Foundation
import CoreData


public class OfflineOffer: NSManagedObject {

    class func fetchOfflineOffers(inManagedObjectContext context: NSManagedObjectContext, sortDescriptor: [NSSortDescriptor] = [NSSortDescriptor(key: "priority", ascending: true),NSSortDescriptor(key: "id", ascending: true)]) -> [OfflineOffer]? {
        let request: NSFetchRequest<OfflineOffer> = OfflineOffer.fetchRequest()
        request.sortDescriptors = sortDescriptor
        if let offers = (try? context.fetch(request)) {
            return offers
        } else {
            return nil
        }
    }
    
    class func fetchOfflineOffers(byType typeId: Int, inManagedObjectContext context: NSManagedObjectContext,sortDescriptor: [NSSortDescriptor] = [NSSortDescriptor(key: "priority", ascending: true),NSSortDescriptor(key: "id", ascending: true)]) -> [OfflineOffer]? {
        let request: NSFetchRequest<OfflineOffer> = OfflineOffer.fetchRequest()
        request.predicate = NSPredicate(format: "type == %i", typeId)
        request.sortDescriptors = sortDescriptor
        if let offers = (try? context.fetch(request)){
            return offers
        } else {
            return nil
        }
    }
    
    class func fetchOfflineOffersByCategory(ids: [Int], inManagedObjectContext context: NSManagedObjectContext, typeId: Int, sortDescriptor: [NSSortDescriptor] = [NSSortDescriptor(key: "priority", ascending: true),NSSortDescriptor(key: "id", ascending: true)]) -> [OfflineOffer]? {
        let request: NSFetchRequest<OfflineOffer> = OfflineOffer.fetchRequest()
        request.sortDescriptors = sortDescriptor
        var predicates = [NSPredicate]()
        predicates.append(NSPredicate(format: "id IN %@", ids))
        predicates.append(NSPredicate(format: "type == %i", typeId))
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        if let shops = (try? context.fetch(request)) {
            return shops
        } else {
            return nil
        }
    }
    
    class func searchOfflineOffer(byTypeId typeId: Int?, byTitle title: String, inManagedObjectContext context: NSManagedObjectContext, sortDescriptor: [NSSortDescriptor] = [NSSortDescriptor(key: "priority", ascending: true),NSSortDescriptor(key: "id", ascending: true)]) -> [OfflineOffer]? {
        let request: NSFetchRequest<OfflineOffer> = OfflineOffer.fetchRequest()
        if let typeId = typeId {
            request.predicate = NSPredicate(format: "type == %i && title CONTAINS[c] %@", typeId, title)
        } else {
            request.predicate = NSPredicate(format: "title CONTAINS[c] %@", title)
        }
        request.sortDescriptors = sortDescriptor
        if let shops = (try? context.fetch(request)) {
            return shops
        } else {
            return nil
        }
    }
    
    class func findOfflineOffer(byId id: Int, inManagedObjectContext context: NSManagedObjectContext) -> OfflineOffer? {
        let request: NSFetchRequest<OfflineOffer> = OfflineOffer.fetchRequest()
        request.predicate = NSPredicate(format: "id == %i", id)
        if let offer = (try? context.fetch(request))?.first {
            return offer
        } else {
            return nil
        }
    }
    
}
