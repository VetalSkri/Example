//
//  CoreDataStorageContext.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 21/11/2018.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStorageContext: StorableContext {
    
    static let shared = CoreDataStorageContext()
    
    var context : NSManagedObjectContext
    
    required init() {
        context = CoreDataManager.shared.mainContext
    }
    
    func saveData() {
        if CoreDataManager.shared.isConfigured {
            do {
                try context.save()
            } catch {
                print("Error saving context \(error)")
            }
        }
    }
}
