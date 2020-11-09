//
//  TicketsCategory+CoreDataProperties.swift
//
//
//  Created by Elina Batyrova on 17.07.2020.
//
//

import Foundation
import CoreData


extension TicketsCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TicketsCategory> {
        return NSFetchRequest<TicketsCategory>(entityName: "TicketsCategory")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String
    @NSManaged public var parentId: Int64
}
