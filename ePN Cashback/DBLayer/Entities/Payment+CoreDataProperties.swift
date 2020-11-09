//
//  Payment+CoreDataProperties.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 01/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//
//

import Foundation
import CoreData


extension Payment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Payment> {
        return NSFetchRequest<Payment>(entityName: "Payment")
    }

    @NSManaged public var id: Int64
    @NSManaged public var status: String
    @NSManaged public var purseType: String
    @NSManaged public var amount: Double
    @NSManaged public var currency: String
    @NSManaged public var created_at: Date?
    @NSManaged public var isCharity: Bool
    @NSManaged public var brand: String?
    @NSManaged public var number: String?
    @NSManaged public var account: String?

}
