//
//  CategoryOffline+CoreDataClass.swift
//  Backit
//
//  Created by Ivan Nikitin on 05/02/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//
//

import Foundation
import CoreData


public class CategoryOffline: NSManagedObject {

    class func fetchOfflineIds(byCategories ids: [Int], inManagedObjectContext context: NSManagedObjectContext) -> [Int]? {
        let request: NSFetchRequest<CategoryOffline> = CategoryOffline.fetchRequest()
        request.predicate = NSPredicate(format: "idCategory IN %@", ids)
        if let idOfflineStores = (try? context.fetch(request)) {
            return idOfflineStores.map{ Int($0.idOffline) }
        } else {
            return nil
        }
    }
}
