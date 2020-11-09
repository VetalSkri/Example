//
//  SupportDialogMessages.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 08/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

struct SupportDialogMessages: Decodable {
    var data: SupportDialogMessagesData
}

struct SupportDialogMessagesData: Decodable {
    var type: String
    var id: String
    var attributes: SupportDialogMessagesAttributes
}

struct SupportDialogMessagesAttributes: Decodable {
    var messages: [SupportDialogAttributeMessage]
    var ticket: SupportDialogTicket
}

struct SupportDialogAttributeMessage: Decodable {
    var id: Int
    var userFromId: Int
    var message: String
    var isRead: Bool
    var userRole: String
    var createdDate: Date?
    var fullname: String
    var avatar: String?
    var files: [SupportDialogAttributeMessageFile]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userFromId = "user_from_id"
        case message
        case isRead = "is_readed"
        case userRole = "user_role"
        case createdDate = "date_created"
        case fullname
        case avatar
        case files
    }
    
    init(id: Int, userFromId: Int, message: String, isRead: Bool, userRole: String, createdDate: Date?, fullname: String, avatar: String?, files: [SupportDialogAttributeMessageFile]?) {
        self.id = id
        self.userFromId = userFromId
        self.message = message
        self.isRead = isRead
        self.userRole = userRole
        self.createdDate = createdDate
        self.fullname = fullname
        self.avatar = avatar
        self.files = files
    }
    
    init (from decoder: Decoder) throws {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.userFromId = try container.decode(Int.self, forKey: .userFromId)
        self.message = try container.decode(String.self, forKey: .message)
        self.isRead = try container.decode(Int.self, forKey: .isRead) == 1 ? true : false
        self.userRole = try container.decode(String.self, forKey: .userRole)
        let createdTicks = try? container.decode(Int64.self, forKey: .createdDate)
        self.createdDate = createdTicks != nil ? Date(timeIntervalSince1970: TimeInterval(integerLiteral: createdTicks!)) : nil
        self.fullname = try container.decode(String.self, forKey: .fullname)
        self.avatar = try container.decode(String?.self, forKey: .avatar)
        self.files = try container.decode([SupportDialogAttributeMessageFile]?.self, forKey: .files)
    }
}

struct SupportDialogAttributeMessageFile: Decodable {
    var id: Int
    var file: String
    var name: String
    var fileVisibility: String
    var tempFileData: Data?
    
    enum CodingKeys: String, CodingKey {
        case id
        case file
        case name
        case fileVisibility = "file_visibility"
    }
    
    func fileType() -> FileType {
        let fileExtension = name.fileExtension().lowercased()
        switch fileExtension {
        case "png", "jpg", "jpeg":
            return .image
        case "mov", "avi", "mp4":
            return .video
        default:
            return .file
        }
    }
}

enum FileType {
    case image
    case video
    case file
}

struct SupportDialogTicket: Decodable {
    var id: Int
    var userId: Int
    var subject: String
    var status: String
    var createdAt: Date?
    var isFavorites: Bool
    var fullname: String
    var username: String?
    var lang: String
    var role: String
    var autoClosed: Bool
    //var params: SupportDialogTicketParam?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case subject
        case status
        case createdAt = "created_at"
        case isFavorites = "is_favorites"
        case fullname
        case username
        case lang
        case role
        case autoClosed = "auto_closed"
        //case params
    }
    
    init (from decoder: Decoder) throws{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.userId = try container.decode(Int.self, forKey: .userId)
        self.subject = try container.decode(String.self, forKey: .subject)
        self.status = try container.decode(String.self, forKey: .status)
        let createdAtString = try container.decode(String?.self, forKey: .createdAt)
        self.createdAt = createdAtString != nil ? dateFormatter.date(from: createdAtString!) : nil
        self.isFavorites = try container.decode(Int.self, forKey: .isFavorites) == 1 ? true : false
        self.fullname = try container.decode(String.self, forKey: .fullname)
        self.username = try container.decode(String?.self, forKey: .username)
        self.lang = try container.decode(String.self, forKey: .lang)
        self.role = try container.decode(String.self, forKey: .role)
        self.autoClosed = try container.decode(Int.self, forKey: .autoClosed) == 1 ? true : false
        //self.params = try container.decode(SupportDialogTicketParam?.self, forKey: .params)
    }
}

struct SupportDialogTicketParam: Decodable {
    var offerId: Int?
    var orderDate: Date?
    var appPlatform: String?
    var appVersion: String?
    
    enum CodingKeys: String, CodingKey {
        case offerId
        case orderDate
        case appPlatform
        case appVersion
    }
    
    init (from decoder: Decoder) throws{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do{
            self.offerId = try container.decode(Int?.self, forKey: .offerId)
        } catch {   }
        do {
            let orderDateString = try container.decode(String?.self, forKey: .orderDate)
            self.orderDate = orderDateString != nil ? dateFormatter.date(from: orderDateString!) : nil
        } catch {   }
        do {
            self.appPlatform = try container.decode(String?.self, forKey: .appPlatform)
        } catch {   }
        do {
            self.appVersion = try container.decode(String?.self, forKey: .appVersion)
        } catch {   }
    }
}
