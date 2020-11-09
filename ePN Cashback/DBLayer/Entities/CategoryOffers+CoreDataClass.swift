//
//  CategoryOffers+CoreDataClass.swift
//  Backit
//
//  Created by Ivan Nikitin on 18/11/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//
//

import Foundation
import CoreData


public class CategoryOffers: NSManagedObject {

    class func fetchStoreIds(byCategories ids: [Int], inManagedObjectContext context: NSManagedObjectContext) -> [Int]? {
        let request: NSFetchRequest<CategoryOffers> = CategoryOffers.fetchRequest()
        request.predicate = NSPredicate(format: "idCategory IN %@", ids)
        if let idStores = (try? context.fetch(request)) {
            return idStores.map{ Int($0.idStore) }
        } else {
            return nil
        }
    }
    
}
