//
//  PaymentsResponse.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 04/02/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

public struct PaymentsResponse: Codable {
    
    var data: [PaymentsDataResponse]?
    var result: Bool
    var meta: MetaResponse?
    
    
    init(data: [PaymentsDataResponse]?, result: Bool, meta: MetaResponse?) {
        self.data = data
        self.result = result
        self.meta = meta
    }
    
}

struct PaymentsDataResponse: Codable {
    
    var type: String
    var id: Int
    var attributes: PaymentAttributes
    
}

struct Purse: Codable {
    var brand: String?
    var number: String?
    var account: String?
    
    enum CodingKeys: String, CodingKey {
        case brand, number, account
    }
    
    init (brand: String?, number: String?, account: String?) {
        self.brand = brand
        self.number = number
        self.account = account
    }
    init (number: String?) {
        self.number = number
    }
}

struct PaymentAttributes: Codable {
    var status: String
    var purse_type: String
    var purse: Purse
    var amount: Double
    var currency: String
    var created_at: Date?
    var isCharity: Bool
    
    enum CodingKeys: String, CodingKey {
        case status, purse_type, purse, amount, currency, created_at, isCharity
    }
    
    init (status: String, purse_type: String, purse: Purse, amount: Double, currency: String, created_at: Date?, isCharity: Bool) {
        self.status = status
        self.purse_type = purse_type
        self.purse = purse
        self.amount = amount
        self.currency = currency
        self.created_at = created_at
        self.isCharity = isCharity
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try container.decode(String.self, forKey: .status)
        purse_type = try container.decode(String.self, forKey: .purse_type)
        if let value = try? container.decode(String.self, forKey: .purse) {
            purse = Purse(number: value)
        } else {
            purse = try container.decode(Purse.self, forKey: .purse)
        }
        amount = try container.decode(Double.self, forKey: .amount)
        currency = try container.decode(String.self, forKey: .currency)
        let created_at_string = try container.decode(String.self, forKey: .created_at)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        created_at = dateFormatter.date(from: created_at_string)
        isCharity = try container.decode(Bool.self, forKey: .isCharity)
    }
}

class Payments {
    var id: Int
    var payment: PaymentAttributes
    
    init(id: Int, payment: PaymentAttributes) {
        self.id = id
        self.payment = payment
    }
}



/*
purse =         {
    brand = MasterCard;
    country = RU;
    created = "2018-12-24T15:39:00Z";
    "exp_month" = 3;
    "exp_year" = 23;
    fingerprint = 52444DBA8DAE2D736E3A9C4E2DE37A3F372E4C02B8B478E72504075C6AAF1AF8;
    id = "3cf0a4d3-cbe7-49c6-a595-d561e130be8c";
    lastUsed = "<null>";
    name = "ALEKSANDR TSYBRIY";
    number = "5536 **** **** 5621";
}

purse =         {
    account = "4149 **** **** 0884";
    "cardholder_name" = "Timofeenko Leonid";
    "exp_month" = 12;
    "exp_year" = 19;
};
*/
