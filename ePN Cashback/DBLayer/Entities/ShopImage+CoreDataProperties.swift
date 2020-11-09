//
//  ShopImage+CoreDataProperties.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 05/06/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//
//

import Foundation
import CoreData


extension ShopImage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShopImage> {
        return NSFetchRequest<ShopImage>(entityName: "ShopImage")
    }

    @NSManaged public var id: Int32
    @NSManaged public var imageUrl: String

}
