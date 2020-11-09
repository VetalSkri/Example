//
//  CoreDataManager.swift
//  Backit
//
//  Created by Elina Batyrova on 10.08.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    // MARK: - Instance Properties
    
    let migrator: CoreDataMigratorProtocol
    
    lazy var persistentContainer: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: "EPN_Cashback")
        let description = persistentContainer.persistentStoreDescriptions.first
        
        description?.shouldInferMappingModelAutomatically = false
        description?.shouldMigrateStoreAutomatically = false
        description?.type = storeType
        
        return persistentContainer
    }()
    
    lazy var mainContext: NSManagedObjectContext = {
        let context = self.persistentContainer.viewContext
        
        context.automaticallyMergesChangesFromParent = true
        
        return context
    }()
    
    private let storeType: String
    private var isPersistentStoreLoaded = false
    
    // MARK: - Singleton
    
    static let shared = CoreDataManager()
    
    var isConfigured: Bool {
        isPersistentStoreLoaded
    }
    
    // MARK: - Initializer
    
    init(storeType: String = NSSQLiteStoreType, migrator: CoreDataMigratorProtocol = CoreDataMigrator()) {
        self.storeType = storeType
        self.migrator = migrator
    }
    
    // MARK: - Instance Methods
    
    func setup(completion: @escaping () -> Void) {
        loadPersistentStore {
            completion()
            self.isPersistentStoreLoaded = true
        }
    }
    
    // MARK: -
    
    private func loadPersistentStore(completion: @escaping () -> Void) {
        migrateStoreIfNeeded {
            self.persistentContainer.loadPersistentStores { description, error in
                guard error == nil else {
                    fatalError("Was unable to load store \(error!).")
                }
                
                completion()
            }
        }
    }
    
    private func migrateStoreIfNeeded(completion: @escaping () -> Void) {
        guard let storeURL = persistentContainer.persistentStoreDescriptions.first?.url else {
            fatalError("PersistentContainer was not set up properly.")
        }
        
        if migrator.requiresMigration(at: storeURL, toVersion: CoreDataMigrationVersion.current) {
            DispatchQueue.global(qos: .userInitiated).async {
                self.migrator.migrateStore(at: storeURL, toVersion: CoreDataMigrationVersion.current)
                
                DispatchQueue.main.async {
                    completion()
                }
            }
        } else {
            DispatchQueue.main.async {
                completion()
            }
        }
    }
}
