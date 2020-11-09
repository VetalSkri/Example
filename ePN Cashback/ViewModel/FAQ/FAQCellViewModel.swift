//
//  FAQCellViewModel.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 29/04/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

class FAQCellViewModel: FAQViewCellViewModelType {
    
    private var questionAnswer: QuestionAnswer
    
    init(questionAnswer currentQuestionAnswer: QuestionAnswer) {
        self.questionAnswer = currentQuestionAnswer
    }
    
    func titleOfQuestion() -> String {
        return questionAnswer.question
    }
    
    func titleOfAnswer() -> String {
        return questionAnswer.answer
    }
    
    func openned() -> Bool{
        return questionAnswer.openned
    }
    
    
}
