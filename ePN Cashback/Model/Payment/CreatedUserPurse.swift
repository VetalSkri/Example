//
//  Purse.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 10/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

public struct CreatedUserPurse: Decodable {
    var data: CreatedUserPurseData
}

struct CreatedUserPurseData: Decodable {
    var type: String
    var id: Int
    var attributes: CreatedUserPurseAttributes
    
    enum CodingKeys: String, CodingKey {
        case type
        case id
        case attributes
    }
    
    init (from decoder: Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decode(String.self, forKey: .type)
        self.attributes = try container.decode(CreatedUserPurseAttributes.self, forKey: .attributes)
        //This trick, because API send ID field in string and integer as he pleases in different ways
        do {
            self.id = try container.decode(Int.self, forKey: .id)
        } catch {
            let idInString = try container.decode(String.self, forKey: .id)
            self.id = Int(idInString) ?? 0
        }
    }
}

struct CreatedUserPurseAttributes: Decodable {
    var status: Int
    var method: String
    var value: String
    var purse: UserPurseObject
}

struct UserPurseObject: Decodable {
    var name: String?
    var type: String
    var purse: String?
    var purseCardObject: UserPurseCardObject?
    var addedDate: Date?
    var isConfirm: Bool
    var isCharity: Bool
    var isDefault: Bool
    var purseType: PurseType?
    
    enum CodingKeys: String, CodingKey {
        case type
        case purse
        case purseCardObject
        case addedDate = "added_datetime"
        case isConfirm = "is_confirmed"
        case isDefault = "is_default"
        case isCharity
    }
    
    init (from decoder: Decoder) throws{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decode(String.self, forKey: .type)
        do {
            self.purse = try container.decode(String.self, forKey: .purse)
        } catch {
            self.purseCardObject = try container.decode(UserPurseCardObject.self, forKey: .purse)
        }
        let dateString = try container.decode(String?.self, forKey: .addedDate)
        self.addedDate = dateString != nil ? dateFormatter.date(from: dateString!) : nil
        self.isConfirm = try container.decode(Bool.self, forKey: .isConfirm)
        self.isDefault = try container.decode(Bool.self, forKey: .isDefault)
        self.isCharity = container.contains(.isCharity) ? try container.decode(Bool.self, forKey: .isCharity) : false
        self.purseType = PurseType(rawValue: self.type)
    }
}

struct UserPurseCardObject: Decodable {
    var account: String
    var cardholderName: String
    var expMonth: Int
    var expYear: Int
    
    enum CodingKeys: String, CodingKey {
        case account
        case number
        case cardholderName = "cardholder_name"
        case name
        case expMonth = "exp_month"
        case expYear = "exp_year"
        
    }
    
    init (from decoder: Decoder) throws{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            self.account = try container.decode(String.self, forKey: .account)
        } catch {
            self.account = try container.decode(String.self, forKey: .number)
        }
        do {
            self.cardholderName = try container.decode(String.self, forKey: .cardholderName)
        } catch {
            do {
            self.cardholderName = try container.decode(String.self, forKey: .name)
            } catch {
                self.cardholderName = ""
            }
        }
        //This trick, because API send ID field in string and integer as he pleases in different ways
        do {
            self.expMonth = try container.decode(Int.self, forKey: .expMonth)
        } catch {
            let monthInString = try container.decode(String.self, forKey: .expMonth)
            self.expMonth = Int(monthInString) ?? 0
        }
        do {
            self.expYear = try container.decode(Int.self, forKey: .expYear)
        } catch {
            let yearInString = try container.decode(String.self, forKey: .expYear)
            self.expYear = Int(yearInString) ?? 0
        }
    }
}
