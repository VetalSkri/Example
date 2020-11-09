//
//  SupportSendMessageResponse.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 03/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

public struct SupportSendMessageResponse : Decodable {
    
    var data : SupportSendMessageResponseData
    
}

struct SupportSendMessageResponseData : Decodable {
    
    var type: String
    var id: String
    var attributes: SupportSendMessageResponseAttributes
    
}

struct SupportSendMessageResponseAttributes : Decodable {
    
    var ticketId: Int
    
    enum CodingKeys: String, CodingKey {
        case ticketId = "ticket_id"
    }
    
    init (from decoder: Decoder) throws{
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.ticketId = try container.decode(Int.self, forKey: .ticketId)
        
    }
    
}
