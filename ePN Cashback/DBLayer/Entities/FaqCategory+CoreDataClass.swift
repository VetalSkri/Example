//
//  FaqCategory+CoreDataClass.swift
//  CashBackEPN
//
//  Created by Александр on 16/05/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//
//

import Foundation
import CoreData


public class FaqCategory: NSManagedObject {

    class func fetchFaqCategoryes(inManagedObjectContext context: NSManagedObjectContext) -> [FaqCategory]? {
        let request: NSFetchRequest<FaqCategory> = FaqCategory.fetchRequest()
        if let faqCategoryes = (try? context.fetch(request)) {
            return faqCategoryes
        } else {
            return nil
        }
    }
    
    class func find(byId faqCategoryId: Int64, inManagedObjectContext context: NSManagedObjectContext) -> FaqCategory? {
        let request: NSFetchRequest<FaqCategory> = FaqCategory.fetchRequest()
        request.predicate = NSPredicate(format: "id == %i", faqCategoryId)
        if let faqCategory = (try? context.fetch(request))?.first {
            return faqCategory
        } else {
            return nil
        }
    }
    
}
