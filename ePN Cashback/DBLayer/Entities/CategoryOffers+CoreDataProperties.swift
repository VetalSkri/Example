//
//  CategoryOffers+CoreDataProperties.swift
//  Backit
//
//  Created by Ivan Nikitin on 18/12/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//
//

import Foundation
import CoreData


extension CategoryOffers {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryOffers> {
        return NSFetchRequest<CategoryOffers>(entityName: "CategoryOffers")
    }

    @NSManaged public var idStore: Int64
    @NSManaged public var idCategory: Int64

}
