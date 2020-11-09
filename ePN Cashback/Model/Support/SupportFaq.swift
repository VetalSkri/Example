//
//  SupportFaq.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 09/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

struct SupportFaq: Decodable {
    var data: SupportFaqData
}

struct SupportFaqData: Decodable {
    var type: String
    var id: String
    var attributes: [SupportFaqAttributes]?
}

struct SupportFaqAttributes: Decodable {
    var id: Int
    var question: String
    var answer: String
}
