//
//  FavoriteStore+CoreDataClass.swift
//  Backit
//
//  Created by Ivan Nikitin on 09/12/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//
//

import Foundation
import CoreData

public class FavoriteStore: NSManagedObject {

    class func findFavorite(byId id: Int, inManagedObjectContext context: NSManagedObjectContext) -> FavoriteStore? {
        let request: NSFetchRequest<FavoriteStore> = FavoriteStore.fetchRequest()
        request.predicate = NSPredicate(format: "id == %i", id)
        if let favorite = (try? context.fetch(request))?.first {
            return favorite
        } else {
            return nil
        }
    }
    
    class func fetchFavoriteIds(inManagedObjectContext context: NSManagedObjectContext) -> [Int]? {
        let request: NSFetchRequest<FavoriteStore> = FavoriteStore.fetchRequest()
        if let favoriteIds = (try? context.fetch(request))?.map({ Int($0.id) }) {
            return favoriteIds
        } else {
            return nil
        }
    }
}
