//
//  Shop+CoreDataProperties.swift
//  Backit
//
//  Created by Виталий Скриганюк on 11.08.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//
//

import Foundation
import CoreData


extension Shop {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Shop> {
        return NSFetchRequest<Shop>(entityName: "Shop")
    }
    
    @NSManaged public var maxRatePretext: String?
    @NSManaged public var id: Int64
    @NSManaged public var image: String
    @NSManaged public var logo: String
    @NSManaged public var logo_small: String?
    @NSManaged public var maxRate: String?
    @NSManaged public var name: String
    @NSManaged public var priority: Int64
    @NSManaged public var tag: String
    @NSManaged public var url: String?
    @NSManaged public var title: String
    //    @NSManaged public var labels: NSSet?
    @NSManaged public var typeId: Int64
    @NSManaged public var offlineCbImage: String?
    @NSManaged public var offlineCbImageDescription: String?
    @NSManaged public var linkDefault: String?
    //    @NSManaged public var categoryIds: NSSet?

}
