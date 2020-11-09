//
//  CategoryOffline+CoreDataProperties.swift
//  Backit
//
//  Created by Ivan Nikitin on 05/02/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//
//

import Foundation
import CoreData


extension CategoryOffline {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryOffline> {
        return NSFetchRequest<CategoryOffline>(entityName: "CategoryOffline")
    }

    @NSManaged public var idCategory: Int64
    @NSManaged public var idOffline: Int64

}
