//
//  PaymentOrder.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 09/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

public struct PaymentOrder: Decodable {
    var data: [PaymentOrderData]
    var result: Bool
}

public struct PaymentOrderData: Decodable {
    var type: String
    var id: Int
    var attributes: PaymentOrderAttributes
}

struct PaymentOrderAttributes: Decodable {
    var status: String
    var purseType: String
    var purse: String
    var amount: Float
    var currency: String
    var createdAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case status
        case purseType = "purse_type"
        case purse
        case amount
        case currency
        case createdAt = "created_at"
    }
    
    init (from decoder: Decoder) throws{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status = try container.decode(String.self, forKey: .status)
        self.purseType = try container.decode(String.self, forKey: .purseType)
        do {
            self.purse = try container.decode(String.self, forKey: .purse)
        } catch {
            self.purse = try container.decode(PaymentOrderPurseObject.self, forKey: .purse).account
        }
        self.amount = try container.decode(Float.self, forKey: .amount)
        self.currency = try container.decode(String.self, forKey: .currency)
        let createdAtString = try container.decode(String?.self, forKey: .createdAt)
        self.createdAt = createdAtString != nil ? dateFormatter.date(from: createdAtString!) : nil
    }
}

struct PaymentOrderPurseObject: Decodable {
    var account: String
    
    enum CodingKeys: String, CodingKey {
        case account
        case number
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            self.account = try container.decode(String.self, forKey: .account)
        } catch {
            self.account = try container.decode(String.self, forKey: .number)
        }
    }
}
