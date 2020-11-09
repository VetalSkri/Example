//
//  ShopsCategory+CoreDataProperties.swift
//
//
//  Created by Elina Batyrova on 17.07.2020.
//
//

import Foundation
import CoreData


extension ShopsCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShopsCategory> {
        return NSFetchRequest<ShopsCategory>(entityName: "ShopsCategory")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String
    @NSManaged public var parentId: Int64
}
