//
//  Promocode+CoreDataClass.swift
//  ePN Cashback
//
//  Created by Ivan Nikitin on 11/06/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//
//

import Foundation
import CoreData


public class Promocode: NSManagedObject {
    
    class func fetchPromocodes(inManagedObjectContext context: NSManagedObjectContext) -> [Promocode]? {
        let request: NSFetchRequest<Promocode> = Promocode.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        if let promocodes = (try? context.fetch(request)) {
            return promocodes
        } else {
            return nil
        }
    }
    
    class func findPromocode(byCode code: String, activated: String, expired: String, inManagedObjectContext context: NSManagedObjectContext) -> Promocode? {
        let request: NSFetchRequest<Promocode> = Promocode.fetchRequest()
        var predicates = [NSPredicate]()
        predicates.append(NSPredicate(format: "code == %@", code))
        predicates.append(NSPredicate(format: "activatedAt == %@", activated))
        predicates.append(NSPredicate(format: "expiredAt == %@", expired))
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        if let promocode = (try? context.fetch(request))?.first {
            return promocode
        } else {
            return nil
        }
    }
    
    class func fetchPromocodes(inManagedObjectContext context: NSManagedObjectContext, fetchLimit: Int, fetchOffSet: Int = 0, sortDescriptor: [NSSortDescriptor] = [NSSortDescriptor(key: "id", ascending: true)]) -> [Promocode]? {
        let request: NSFetchRequest<Promocode> = Promocode.fetchRequest()
        request.fetchLimit = fetchLimit
        request.fetchOffset = fetchOffSet
        request.sortDescriptors = sortDescriptor
        if let promocodes = (try? context.fetch(request)) {
            return promocodes
        } else {
            return nil
        }
    }
    
    class func getTheMostIdentifier(inManagedObjectContext context: NSManagedObjectContext) -> Int64 {
        let request: NSFetchRequest<Promocode> = Promocode.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        if let promocodes = (try? context.fetch(request)) {
            return promocodes.first?.id ?? 0
        } else {
            return 1
        }
    }
}
