//
//  PushNotification+CoreDataProperties.swift
//
//
//  Created by Ivan Nikitin on 10/06/2019.
//
//

import Foundation
import CoreData


extension PushNotification {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PushNotification> {
        return NSFetchRequest<PushNotification>(entityName: "PushNotification")
    }
    
    @NSManaged public var title: String?
    @NSManaged public var body: String?
    @NSManaged public var date: Date
    @NSManaged public var isRead: Bool
    @NSManaged public var id: Int64
    
}
