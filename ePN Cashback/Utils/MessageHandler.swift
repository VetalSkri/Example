//
//  MessageHandler.swift
//  Backit
//
//  Created by Александр Кузьмин on 04/12/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

public class MessageHandler {
    
    static let shared = MessageHandler()
    
    //Initializer access level change now
    private init() {}
    
    private var messagesInProgress = [SupportMessage]()
    
    
    func send(message: SupportMessage, subjectId: Int? = nil, subjectName: String? = nil) {
        print("MYLOG: send call")
        if message.id == -1 {
            print("MYLOG: add message to db")
            OperationQueue.main.addOperation {
                CoreDataStorageContext.shared.addMessage(message: message)
            }
        }
        messagesInProgress.append(message)
        if let files = message.files, files.count > 0, files.contains(where: { (fileMessage) -> Bool in
            return fileMessage.link == nil
        }) {
            files.forEach({
                if $0.link == nil {
                    MessageFileHandler.shared.sendFile(messageFile: $0, messageId: message.id) { success in
                        if !success {
                            self.messagesInProgress.removeAll(where: { return $0.id == message.id })
                            NotificationCenter.default.post(name: NSNotification.Name("SupportMessageStatusNotification"), object: nil, userInfo: ["isSuccess":false, "messageId":message.id])
                            return
                        }
                        if self.checkAllFileIsUploaded(message: message) {
                            self.sendReadyMessage(message: message, subjectId: subjectId, subjectName: subjectName)
                        }
                    }
                }
            })
        } else {
            sendReadyMessage(message: message, subjectId: subjectId, subjectName: subjectName)
        }
    }
    
    func checkMessageInProcess(messageId: Int) -> Bool {
        return messagesInProgress.contains(where: { return $0.id == messageId })
    }
    
    private func sendReadyMessage(message: SupportMessage, subjectId: Int? = nil, subjectName: String? = nil) {
        print("MYLOG: start send message")
        SupportApiClient.sendMessage(subject: subjectName, message: message.message, replyToId: message.replyToId, subjectId: subjectId, files: message.files?.map( { return File(name: $0.fileName, size: $0.size, link: $0.link ?? "") } ) ?? [], ticketParam: nil) { (result) in
            self.messagesInProgress.removeAll(where: { return $0.id == message.id })
            switch result {
            case .success(let answer):
                print("MYLOG: success send message")
                OperationQueue.main.addOperation {
                    CoreDataStorageContext.shared.removeMessage(messageId: message.id)
                }
                NotificationCenter.default.post(name: NSNotification.Name("SupportMessageStatusNotification"), object: nil, userInfo: ["isSuccess":true, "messageId":message.id, "dialogId":answer.data.attributes.ticketId])
                break
            case .failure(let error):
                print("MYLOG: failure send message: \(error.localizedDescription)")
                NotificationCenter.default.post(name: NSNotification.Name("SupportMessageStatusNotification"), object: nil, userInfo: ["isSuccess":false, "messageId":message.id])
                break
            }
        }
    }
    
    private func checkAllFileIsUploaded(message: SupportMessage) -> Bool {
        guard let files = message.files else { return true }
        for index in 0..<files.count {
            if (files[index].link?.isEmpty ?? true) {
                return false
            }
        }
        return true
    }
    
}

public class MessageFileHandler {
    
    static let shared = MessageFileHandler()
    private init() { }
    
    private var messageFileOperations = [MessageFileOperation]()
    
    func sendFile(messageFile: SupportMessageFile, messageId: Int, complete:((Bool)->())?) {
        print("MYLOG: start send file")
        let fileOperation = MessageFileOperation()
        fileOperation.file = messageFile
        messageFileOperations.append(fileOperation)
        CdnApiClient.uploadFile(data: messageFile.file, type: (messageFile.fileType() == FileType.image) ? "image" : "file", name: messageFile.fileName, changeProgress: { (progress) in
            fileOperation.currentProgress = progress
            NotificationCenter.default.post(name: NSNotification.Name("SupportFileStatusNotification"), object:nil, userInfo: ["fileId": messageFile.id, "progress": progress])
        }) { [weak self] (result) in
            self?.messageFileOperations.remove(fileOperation)
            switch result {
            case .success(let response):
                print("MYLOG: success send file")
                if response.data.count <= 0 {
                    complete?(false)
                    return
                }
                messageFile.link = response.data[0].id
                CoreDataStorageContext.shared.updateMessageFileLink(messageFile: messageFile)
                complete?(true)
                NotificationCenter.default.post(name: NSNotification.Name("SupportFileStatusNotification"), object: nil, userInfo: ["fileId":messageFile.id, "success":true])
                break
            case .failure(let error):
                print("MYLOG: failure send file: \(error.localizedDescription)")
                complete?(false)
                NotificationCenter.default.post(name: NSNotification.Name("SupportFileStatusNotification"), object: nil, userInfo: ["fileId":messageFile.id, "success":false])
                break
            }
        }
    }
    
    func progress(fileId: Int) -> Double {
        return messageFileOperations.first(where: { return $0.file?.id == fileId })?.currentProgress ?? 1.0
    }
}

public class MessageFileOperation {
    
    var currentProgress: Double = 0.0
    var file: SupportMessageFile? = nil
    
}
