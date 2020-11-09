//
//  FaqCategory+CoreDataProperties.swift
//  CashBackEPN
//
//  Created by Александр on 16/05/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//
//

import Foundation
import CoreData


extension FaqCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FaqCategory> {
        return NSFetchRequest<FaqCategory>(entityName: "FaqCategory")
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String
    @NSManaged public var priority: Int64
    @NSManaged public var answerQuestions: NSSet?

}

// MARK: Generated accessors for answerQuestions
extension FaqCategory {

    @objc(addAnswerQuestionsObject:)
    @NSManaged public func addToAnswerQuestions(_ value: FaqAnswerQuestion)

    @objc(removeAnswerQuestionsObject:)
    @NSManaged public func removeFromAnswerQuestions(_ value: FaqAnswerQuestion)

    @objc(addAnswerQuestions:)
    @NSManaged public func addToAnswerQuestions(_ values: NSSet)

    @objc(removeAnswerQuestions:)
    @NSManaged public func removeFromAnswerQuestions(_ values: NSSet)

}
