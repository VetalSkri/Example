//
//  FaqAnswersResponse.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 24/04/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

struct FaqAnswersResponse: Decodable {
    
    var data: FaqAnswersDataResponse
    
    init(data: FaqAnswersDataResponse) {
        self.data = data
    }
    
}

public struct FaqAnswersDataResponse: Codable {
    var type: String
    var id: String
    var attributes: [FaqAnswersCategory]
}

public struct FaqAnswersCategory: Codable {
    var category_id: Int
    var category_title: String
    var category_icon: String
    var category_priority: Int
    var category_slug: String
    var data: [FaqAnswers]
    
}

public struct FaqAnswers: Codable {
    var question_answer_id: Int
    var question: String
    var answer: String
    var lang: String
}

class FaqCategoryes : Equatable {
    
    var id : Int64
    var title: String
    var priority: Int
    var list: [QuestionAnswer]
    
    init(id: Int64, title: String, priority: Int, faq: [QuestionAnswer]) {
        self.id = id
        self.title = title
        self.priority = priority
        self.list = faq
    }
    
    static func == (lhs: FaqCategoryes, rhs: FaqCategoryes) -> Bool {
        return (lhs.title == rhs.title) && (lhs.priority == rhs.priority) && (lhs.id == rhs.id)
    }
}

class QuestionAnswer {
    var id: Int
    var question: String
    var answer: String
    var lang: String
    var openned: Bool
    
    init(id: Int, question: String, answer: String, lang: String, openned: Bool = false) {
        self.id = id
        self.question = question
        self.answer = answer
        self.lang = lang
        self.openned = openned
    }
}

