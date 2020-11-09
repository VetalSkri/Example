//
//  Payment+CoreDataClass.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 01/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//
//

import Foundation
import CoreData


public class Payment: NSManagedObject {

    class func fetchPayments(inManagedObjectContext context: NSManagedObjectContext) -> [Payment]? {
        let request: NSFetchRequest<Payment> = Payment.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "created_at", ascending: false)]
        if let payments = (try? context.fetch(request)) {
            return payments
        } else {
            return nil
        }
    }
    
    class func findPayments(byId id: Int64, inManagedObjectContext context: NSManagedObjectContext) -> Payment? {
        let request: NSFetchRequest<Payment> = Payment.fetchRequest()
        var predicates = [NSPredicate]()
        predicates.append(NSPredicate(format: "id == %ld", id))
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        if let payment = (try? context.fetch(request))?.first {
            return payment
        } else {
            return nil
        }
    }
    
    class func fetchPayments(inManagedObjectContext context: NSManagedObjectContext, fetchLimit: Int, fetchOffSet: Int = 0, sortDescriptor: [NSSortDescriptor] = [NSSortDescriptor(key: "created_at", ascending: false)]) -> [Payment]? {
        let request: NSFetchRequest<Payment> = Payment.fetchRequest()
        request.fetchLimit = fetchLimit
        request.fetchOffset = fetchOffSet
        request.sortDescriptors = sortDescriptor
        if let payments = (try? context.fetch(request)) {
            return payments
        } else {
            return nil
        }
    }
    
}
