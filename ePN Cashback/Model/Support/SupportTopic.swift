//
//  SupportTopic.swift
//  Backit
//
//  Created by Александр Кузьмин on 23/12/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

struct SupportTopic: Decodable {
    var data: SupportTopicData
}

struct SupportTopicData: Decodable {
    var attributes: [SupportTopicAttributes]?
}

struct SupportTopicAttributes: Decodable {
    var id: Int
    var name: String
    var answer: String?
}
