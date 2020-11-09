//
//  FaqAnswerQuestion+CoreDataClass.swift
//  CashBackEPN
//
//  Created by Александр on 16/05/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//
//

import Foundation
import CoreData


public class FaqAnswerQuestion: NSManagedObject {
    
    class func fetchFaqAnswerQuestion(inManagedObjectContext context: NSManagedObjectContext) -> [FaqAnswerQuestion]? {
        let request: NSFetchRequest<FaqAnswerQuestion> = FaqAnswerQuestion.fetchRequest()
        if let faqAnswerQuestions = (try? context.fetch(request)) {
            return faqAnswerQuestions
        } else {
            return nil
        }
    }
    
    class func find(byId id: Int, lang: String, inManagedObjectContext context: NSManagedObjectContext) -> FaqAnswerQuestion? {
        let request: NSFetchRequest<FaqAnswerQuestion> = FaqAnswerQuestion.fetchRequest()
        request.predicate = NSPredicate(format: "questionAnswerId == %i && lang == %@", id, lang)
        if let faqAnswerQuestion = (try? context.fetch(request))?.first {
            return faqAnswerQuestion
        } else {
            return nil
        }
    }
    
}
