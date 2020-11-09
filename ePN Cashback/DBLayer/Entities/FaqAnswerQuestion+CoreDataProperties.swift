//
//  FaqAnswerQuestion+CoreDataProperties.swift
//  CashBackEPN
//
//  Created by Александр on 16/05/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//
//

import Foundation
import CoreData


extension FaqAnswerQuestion {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FaqAnswerQuestion> {
        return NSFetchRequest<FaqAnswerQuestion>(entityName: "FaqAnswerQuestion")
    }

    @NSManaged public var id: Int64
    @NSManaged public var question: String
    @NSManaged public var answer: String
    @NSManaged public var lang: String
    @NSManaged public var questionAnswerId: Int64
    @NSManaged public var category: FaqCategory?

}
