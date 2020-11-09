//
//  ShopsCategory+CoreDataClass.swift
//
//
//  Created by Elina Batyrova on 17.07.2020.
//
//

import Foundation
import CoreData

@objc(ShopsCategory)
public class ShopsCategory: NSManagedObject {
    
    class func fetchCategory(inManagedObjectContext context: NSManagedObjectContext, sortDescriptor: [NSSortDescriptor] = [NSSortDescriptor(key: "id", ascending: true)]) -> [ShopsCategory]? {
        let request: NSFetchRequest<ShopsCategory> = ShopsCategory.fetchRequest()
        request.sortDescriptors = sortDescriptor
        if let categories = (try? context.fetch(request)) {
            return categories
        } else {
            return nil
        }
    }
    
    class func findCategory(byId categoryId: Int, inManagedObjectContext context: NSManagedObjectContext) -> ShopsCategory? {
        let request: NSFetchRequest<ShopsCategory> = ShopsCategory.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", categoryId)
        if let category = (try? context.fetch(request))?.first {
            return category
        } else {
            return nil
        }
    }
    
    class func fetchCategories(byParent id: Int, inManagedObjectContext context: NSManagedObjectContext, sortDescriptor: [NSSortDescriptor] = [NSSortDescriptor(key: "id", ascending: true)]) -> [ShopsCategory]? {
        let request: NSFetchRequest<ShopsCategory> = ShopsCategory.fetchRequest()
        request.sortDescriptors = sortDescriptor
        request.predicate = NSPredicate(format: "parentId = %d", id)
        if let categories = try? context.fetch(request) {
            return categories
        } else {
            return nil
        }
    }
}
