//
//  Storable.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 21/11/2018.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//

import Foundation
import CoreData

protocol Storable {
}

extension NSManagedObject: Storable {}

extension Store: Storable {}

extension Labels: Storable {}

extension Categories: Storable {}

extension LocalNotification: Storable {}

extension Promocodes: Storable {}

extension Payments: Storable {}

extension OfferOffline: Storable {}

extension NSManagedObject {
    
    class func deleteEntityRequest<T: NSManagedObject>(entity: T.Type, inManagedObjectContext context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = entity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
        } catch let error as NSError {
            print(error)
            //TODO: add crashlytics
        }
    }
    
}
