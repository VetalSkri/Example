//
//  Message+CoreDataProperties.swift
//  Backit
//
//  Created by Александр Кузьмин on 04/12/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//
//

import Foundation
import CoreData


extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message")
    }

    @NSManaged public var id: Int64
    @NSManaged public var subject: String?
    @NSManaged public var message: String?
    @NSManaged public var replyToId: Int64
    @NSManaged public var createdAt: Double
    @NSManaged public var files: NSSet?

}

// MARK: Generated accessors for files
extension Message {

    @objc(addFilesObject:)
    @NSManaged public func addToFiles(_ value: MessageFile)

    @objc(removeFilesObject:)
    @NSManaged public func removeFromFiles(_ value: MessageFile)

    @objc(addFiles:)
    @NSManaged public func addToFiles(_ values: NSSet)

    @objc(removeFiles:)
    @NSManaged public func removeFromFiles(_ values: NSSet)

}
