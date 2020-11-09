//
//  SupportMessage.swift
//  Backit
//
//  Created by Александр Кузьмин on 04/12/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

public class SupportMessage {
    
    var id: Int
    var subject: String?
    var message: String
    var replyToId: Int
    var createdAt: Double
    var files: [SupportMessageFile]?
    
    init(id: Int, subject: String?, message: String, replyToId: Int, createdAt: Double, files: [SupportMessageFile]?) {
        self.id = id
        self.subject = subject
        self.message = message
        self.replyToId = replyToId
        self.createdAt = createdAt
        self.files = files
    }
    
}

public class SupportMessageFile {

    var id: Int
    var file: Data
    var fileName: String
    var fileExtension: String
    var messageId: Int
    var link: String?
    var size: Float
    
    init(id: Int, file: Data, fileName: String, fileExtension: String, messageId: Int, link: String?, size: Float) {
        self.id = id
        self.file = file
        self.fileName = fileName
        self.fileExtension = fileExtension
        self.messageId = messageId
        self.link = link
        self.size = size
    }
    
    func fileType() -> FileType {
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
