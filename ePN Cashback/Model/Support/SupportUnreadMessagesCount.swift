//
//  SupportUnreadMessagesCount.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 08/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

struct SupportUnreadMessagesCount: Decodable {
    var data: SupportUnreadMessagesCountData
}

struct SupportUnreadMessagesCountData: Decodable {
    var type: String
    var id: String
    var attributes: SupportUnreadMessagesCountAttributes
}

struct SupportUnreadMessagesCountAttributes: Decodable {
    var unreadCount: Int
    
    enum CodingKeys: String, CodingKey {
        case unreadCount = "unread_count"
    }
    
    init (from decoder: Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.unreadCount = try container.decode(Int.self, forKey: .unreadCount)
        
    }
}
