//
//  SupportDialogsResponse.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 03/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

public struct SupportDialogs : Decodable {
    
    var data: SupportDialogsData
    var meta: SupportDialogsMeta
    
}

struct SupportDialogsData : Decodable {
    
    var id: String
    var type: String
    var attributes: [SupportDialogsAttributes]?
    
}

struct SupportDialogsMeta : Decodable {
    var count : Int
}

struct SupportDialogsAttributes: Decodable {
    var id: Int
    var createdAt: Date?
    var updatedAt: Date?
    var subject: String?
    var isRead: Bool
    var lastFromSupport: Bool
    var lastUserRole: String
    var message: String
    var lastFullName: String
    var userName: String?
    var avatar: String?
    var newMessagesCount: Int
    var supportReadMessage: Bool
    var userReadMessage: Bool
    var status: DialogStatus
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case subject
        case isRead = "is_readed"
        case lastFromSupport = "last_from_support"
        case lastUserRole = "last_user_role"
        case message
        case lastFullName = "last_fullname"
        case userName = "username"
        case avatar
        case newMessagesCount = "new_messages_count"
        case supportReadMessage = "support_read_message"
        case userReadMessage = "user_read_message"
        case status
    }
    
    init (from decoder: Decoder) throws{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        let createdAtString = try container.decode(String?.self, forKey: .createdAt)
        self.createdAt = createdAtString != nil ? dateFormatter.date(from: createdAtString!) : nil
        let updatedAtString = try container.decode(String?.self, forKey: .updatedAt)
        self.updatedAt = updatedAtString != nil ? dateFormatter.date(from: updatedAtString!) : nil
        self.subject = try? container.decode(String.self, forKey: .subject)
        self.isRead = try container.decode(Int.self, forKey: .isRead) == 1 ? true : false
        self.lastFromSupport = try container.decode(Int.self, forKey: .lastFromSupport) == 1 ? true : false
        self.lastUserRole = try container.decode(String.self, forKey: .lastUserRole)
        self.message = try container.decode(String.self, forKey: .message)
        self.lastFullName = try container.decode(String.self, forKey: .lastFullName)
        self.userName = try container.decode(String?.self, forKey: .userName)
        self.avatar = try container.decode(String?.self, forKey: .avatar)
        self.newMessagesCount = try container.decode(Int.self, forKey: .newMessagesCount)
        self.supportReadMessage = try container.decode(Int.self, forKey: .supportReadMessage) == 1 ? true : false
        self.userReadMessage = try container.decode(Int.self, forKey: .userReadMessage) == 1 ? true : false
        let statusString = try container.decode(String.self, forKey: .status)
        if statusString == DialogStatus.open.rawValue {
            status = .open
        } else if statusString == DialogStatus.closed.rawValue {
            status = .closed
        } else {
            Analytics.supportDialogUnknownTicketStatus(ticketStatus: statusString)
            status = .notify
        }
    }
    
}

enum DialogStatus: String {
    case open = "open"
    case closed = "closed"
    case notify = "notify"
}
