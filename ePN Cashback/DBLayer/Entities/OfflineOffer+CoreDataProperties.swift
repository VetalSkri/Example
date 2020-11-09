//
//  OfflineOffer+CoreDataProperties.swift
//  Backit
//
//  Created by Ivan Nikitin on 09/10/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//
//

import Foundation
import CoreData


extension OfflineOffer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OfflineOffer> {
        return NSFetchRequest<OfflineOffer>(entityName: "OfflineOffer")
    }

    @NSManaged public var id: Int64
    @NSManaged public var image: String?
    @NSManaged public var priority: Int64
    @NSManaged public var tag: String?
    @NSManaged public var title: String
    @NSManaged public var typeId: Int64
    @NSManaged public var url: String?
    @NSManaged public var descript: String?
    @NSManaged public var type: Int64
    
}
