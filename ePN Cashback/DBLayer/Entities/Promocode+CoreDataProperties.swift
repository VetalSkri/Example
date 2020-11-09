//
//  Promocode+CoreDataProperties.swift
//  ePN Cashback
//
//  Created by Ivan Nikitin on 11/06/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//
//

import Foundation
import CoreData


extension Promocode {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Promocode> {
        return NSFetchRequest<Promocode>(entityName: "Promocode")
    }
    
    @NSManaged public var id: Int64
    @NSManaged public var code: String
    @NSManaged public var activatedAt: String
    @NSManaged public var expiredAt: String
    @NSManaged public var status: String
    
}
