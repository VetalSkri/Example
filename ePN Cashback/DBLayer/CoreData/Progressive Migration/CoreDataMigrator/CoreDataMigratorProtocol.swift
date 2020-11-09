//
//  CoreDataMigratorProtocol.swift
//  Backit
//
//  Created by Elina Batyrova on 10.08.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import CoreData

protocol CoreDataMigratorProtocol {
    func requiresMigration(at storeURL: URL, toVersion version: CoreDataMigrationVersion) -> Bool
    func migrateStore(at storeURL: URL, toVersion version: CoreDataMigrationVersion)
}
