//
//  Shop+CoreDataClass.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 10/12/2018.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//
//

import Foundation
import CoreData


public class Shop: NSManagedObject {

//    class func fetchShops(inManagedObjectContext context: NSManagedObjectContext, sortDescriptor: [NSSortDescriptor] = [NSSortDescriptor(key: "id", ascending: true)]) -> [Shop]? {
//        let request: NSFetchRequest<Shop> = Shop.fetchRequest()
//        request.sortDescriptors = sortDescriptor
//        if let shops = (try? context.fetch(request)) {
//            return shops
//        } else {
//            return nil
//        }
//    }
    
//    class func fetchShops(inManagedObjectContext context: NSManagedObjectContext, typeId: Int, sortDescriptor: [NSSortDescriptor] = [NSSortDescriptor(key: "id", ascending: true)]) -> [Shop]? {
//        let request: NSFetchRequest<Shop> = Shop.fetchRequest()
//        request.sortDescriptors = sortDescriptor
//        request.predicate = NSPredicate(format: "typeId == %d", typeId)
//        if let shops = (try? context.fetch(request)) {
//            return shops
//        } else {
//            return nil
//        }
//    }
    
    
    class func fetchPageOfShops(inManagedObjectContext context: NSManagedObjectContext, typeId: ShopTypeId?, fetchLimit: Int, fetchOffSet: Int = 0, sortDescriptor: [NSSortDescriptor] = [NSSortDescriptor(key: "priority", ascending: true)]) -> [Shop]? {
        let request: NSFetchRequest<Shop> = Shop.fetchRequest()
        request.fetchLimit = fetchLimit
        request.fetchOffset = fetchOffSet
        request.sortDescriptors = sortDescriptor
        if let typeId = typeId?.rawValue {
            request.predicate = NSPredicate(format: "typeId == %d", typeId)
        }
        if let shops = (try? context.fetch(request)) {
            return shops
        } else {
            return nil
        }
    }
    
    class func fetchPageOfShopsByCategory(ids: [Int], inManagedObjectContext context: NSManagedObjectContext, typeId: ShopTypeId?, fetchLimit: Int, fetchOffSet: Int = 0, sortDescriptor: [NSSortDescriptor] = [NSSortDescriptor(key: "priority", ascending: true)]) -> [Shop]? {
        let request: NSFetchRequest<Shop> = Shop.fetchRequest()
        request.fetchLimit = fetchLimit
        request.fetchOffset = fetchOffSet
        request.sortDescriptors = sortDescriptor
        var predicates = [NSPredicate]()
        predicates.append(NSPredicate(format: "id IN %@", ids))
        if let typeId = typeId?.rawValue {
            predicates.append(NSPredicate(format: "typeId == %d", typeId))
        }
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        if let shops = (try? context.fetch(request)) {
            return shops
        } else {
            return nil
        }
    }
    
//    class func findShops(byLabel label: Label, inManagedObjectContext context: NSManagedObjectContext, sortDescriptor: [NSSortDescriptor] = [NSSortDescriptor(key: "id", ascending: true)]) -> [Shop]? {
//        let request: NSFetchRequest<Shop> = Shop.fetchRequest()
//        let predicate = NSPredicate(format: "ANY labels == %@", label)
//        request.predicate = predicate
//        request.sortDescriptors = sortDescriptor
//        if let shops = (try? context.fetch(request)) {
//            return shops
//        } else {
//            return nil
//        }
//    }
    
    class func searchShops(by title: String, fetchOffSet: Int, fetchLimit: Int, typeId: ShopTypeId, inManagedObjectContext context: NSManagedObjectContext, sortDescriptor: [NSSortDescriptor] = [NSSortDescriptor(key: "priority", ascending: true),NSSortDescriptor(key: "id", ascending: true)]) -> [Shop]? {
        let request: NSFetchRequest<Shop> = Shop.fetchRequest()
        request.fetchLimit = fetchLimit
        request.fetchOffset = fetchOffSet
        request.predicate = NSPredicate(format: "typeId == %d && title CONTAINS[c] %@", typeId.rawValue, title)
        request.sortDescriptors = sortDescriptor
        if let shops = (try? context.fetch(request)) {
            return shops
        } else {
            return nil
        }
    }
    
//    class func findShopsToPreview(byLabel label: Label, inManagedObjectContext context: NSManagedObjectContext, fetchLimit: Int, sortDescriptor: [NSSortDescriptor] = [NSSortDescriptor(key: "priority", ascending: true)]) -> [Shop]? {
//        let request: NSFetchRequest<Shop> = Shop.fetchRequest()
//        request.fetchLimit = fetchLimit
//        let predicate = NSPredicate(format: "ANY labels == %@", label)
//        request.predicate = predicate
//        request.sortDescriptors = sortDescriptor
//        if let shops = (try? context.fetch(request)) {
//            return shops
//        } else {
//            return nil
//        }
//    }

    class func findFavoriteShopsPaging(inManagedObjectContext context: NSManagedObjectContext, typeId: ShopTypeId = .common, fetchLimit: Int, fetchOffSet: Int, sortDescriptor: [NSSortDescriptor] = [NSSortDescriptor(key: "priority", ascending: true)], favoriteIds: [Int]? = nil) -> [Shop]? {
        let request: NSFetchRequest<Shop> = Shop.fetchRequest()
        request.fetchLimit = fetchLimit
        request.fetchOffset = fetchOffSet
        var predicates = [NSPredicate]()
        predicates.append(NSPredicate(format: "typeId == %d", typeId.rawValue))
        if let favoriteIds = favoriteIds {
            predicates.append(NSPredicate(format: "id IN %@", favoriteIds))
        }
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        request.sortDescriptors = sortDescriptor
        if let shops = (try? context.fetch(request)) {
            return shops
        } else {
            return nil
        }
    }
    
    class func findShop(byId shopId: Int, inManagedObjectContext context: NSManagedObjectContext) -> Shop? {
        let request: NSFetchRequest<Shop> = Shop.fetchRequest()
        request.predicate = NSPredicate(format: "id == %i", shopId)
        if let shop = (try? context.fetch(request))?.first {
            return shop
        } else {
            return nil
        }
    }
    
    class func findLogoUrlString(byId shopId: Int, inManagedObjectContext context: NSManagedObjectContext) -> String? {
        let request: NSFetchRequest<Shop> = Shop.fetchRequest()
        request.predicate = NSPredicate(format: "id == %i", shopId)
        if let shop = (try? context.fetch(request))?.first {
            return shop.logo_small
        } else {
            return nil
        }
    }
}
