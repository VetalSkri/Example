//
//  Doodle+CoreDataProperties.swift
//
//
//  Created by Elina Batyrova on 07.07.2020.
//
//

import Foundation
import CoreData


extension Doodle {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Doodle> {
        return NSFetchRequest<Doodle>(entityName: "Doodle")
    }

    @NSManaged public var backgroundColor: String?
    @NSManaged public var backgroundImage: String?
    @NSManaged public var dateFrom: Date?
    @NSManaged public var dateTo: Date?
    @NSManaged public var goToStore: Bool
    @NSManaged public var image: String?
    @NSManaged public var link: String?
    @NSManaged public var name: String
    @NSManaged public var offerID: Int64
    @NSManaged public var offerLogo: String?
    @NSManaged public var offerTypeID: Int64
    @NSManaged public var priority: Int32
    @NSManaged public var status: String?
    @NSManaged public var subTitle: String?
    @NSManaged public var textButton: String?
    @NSManaged public var title: String?
    @NSManaged public var id: Int64

}
