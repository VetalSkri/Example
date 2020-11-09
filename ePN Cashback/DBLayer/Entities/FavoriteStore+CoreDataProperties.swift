//
//  FavoriteStore+CoreDataProperties.swift
//  Backit
//
//  Created by Ivan Nikitin on 09/12/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//
//

import Foundation
import CoreData


extension FavoriteStore {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteStore> {
        return NSFetchRequest<FavoriteStore>(entityName: "FavoriteStore")
    }

    @NSManaged public var id: Int64

}
