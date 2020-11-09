//
//  MessageFile+CoreDataProperties.swift
//  Backit
//
//  Created by Александр Кузьмин on 04/12/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//
//

import Foundation
import CoreData


extension MessageFile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MessageFile> {
        return NSFetchRequest<MessageFile>(entityName: "MessageFile")
    }

    @NSManaged public var file: Data?
    @NSManaged public var fileName: String?
    @NSManaged public var fileExtension: String?
    @NSManaged public var messageId: Int64
    @NSManaged public var link: String?
    @NSManaged public var id: Int64
    @NSManaged public var message: Message?
    @NSManaged public var size: Float

}
