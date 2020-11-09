//
//  SupportChatViewModel.swift
//  Backit
//
//  Created by Александр Кузьмин on 12/11/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import XCoordinator
import Differ

class SupportChatViewModel {
    
    private let router: UnownedRouter<SupportRoute>
    private let isDialogOpen: Bool
    private var subjectId: Int? = nil
    private var subjectName: String? = nil
    private var dialogId = 0
    var isLoading = true
    private var messages = [SupportDialogAttributeMessage]()
    private var messagesInProcess = [SupportMessage]()
    private var decoratedMessages = [Any]()
    private var downloadingFileKeys = [(String, Double, Bool)]()
    private var processGetFileFromDisk = false
    private let formatter = DateFormatter()
    private var countOfUnreadMessages = 0
    var sendButtonDisabled = false
    
    init(router: UnownedRouter<SupportRoute>, subjectId: Int? = nil, subjectName: String? = nil, dialogId: Int = 0, isDialogOpen: Bool) {
        self.router = router
        self.isDialogOpen = isDialogOpen
        self.subjectId = subjectId
        self.subjectName = subjectName
        self.dialogId = dialogId
        self.messagesInProcess = CoreDataStorageContext.shared.getMessages(forDialogId: dialogId) ?? [SupportMessage]()
        self.formatter.locale = .current
        self.formatter.dateFormat = "dd MMMM"
    }
    
    var title: String {
        return NSLocalizedString("Support", comment: "")
    }
    
    var shouldShowCloseDialogButton: Bool {
        isDialogOpen
    }
    
    func back() {
        router.trigger(.popToRoot)
    }
    
    func showCloseChatAlert() {
        router.trigger(.closeChatAlert(dialogID: dialogId))
    }
    
    func decorateMessages() {
        decoratedMessages.removeAll()
        
        messagesInProcess.forEach { (message) in
            decoratedMessages.append(message)
        }
        var currentDate = messages.count > 0 ? getDateString(date: messages[0].createdDate ?? Date()) : getDateString(date: Date())
        if decoratedMessages.count > 0 {
            currentDate = NSLocalizedString("Today", comment: "")
        }
        
        messages.forEach { (message) in
            if getDateString(date: message.createdDate ?? Date()) != currentDate {
                decoratedMessages.append(currentDate)
                currentDate = getDateString(date: message.createdDate ?? Date())
            }
            decoratedMessages.append(message)
        }
        if decoratedMessages.count > 0 {
            decoratedMessages.append(currentDate)
        }
    }
    
    func loadMessages(completion:((Bool)->())?) {
        isLoading = true
        SupportApiClient.getDialogMessages(dialogId: "\(dialogId)") { [weak self] (result) in
            self?.isLoading = false
            switch result {
            case .success(let response):
                self?.messages = response.data.attributes.messages.sorted(by: { (message1, message2) -> Bool in
                    return (message1.createdDate ?? Date(timeIntervalSince1970: 0)).timeIntervalSince(message2.createdDate ?? Date(timeIntervalSince1970: 0)) > 0
                })
                self?.decorateMessages()
                self?.markAllUnreadMessagesAsRead()
                completion?(true)
                break
            case .failure(let error):
                Alert.showErrorToast(by: error)
                completion?(false)
                break
            }
        }
    }
    
    func numberOfItems() -> Int {
        return isShowSkelenot() ? 5 : decoratedMessages.count
    }
    
    func message(forIndexPath indexPath: IndexPath) -> (SupportDialogAttributeMessage?, SupportMessage?, String?) {
        if decoratedMessages.count > indexPath.row {
            if let remoteMessage = decoratedMessages[indexPath.row] as? SupportDialogAttributeMessage {
                return (remoteMessage, nil, nil)
            }
            if let localMessage = decoratedMessages[indexPath.row] as? SupportMessage {
                return (nil, localMessage, nil)
            }
            if let decorateText = decoratedMessages[indexPath.row] as? String {
                return (nil, nil, decorateText)
            }
        }
        return (nil, nil, nil)
    }
    
    func isShowSkelenot() -> Bool {
        return isLoading && decoratedMessages.count <= 0 && dialogId > 0
    }
    
    func sendMessage(message: String, files: [SupportMessageFile]? = nil) -> ExtendedDiff {
        if dialogId <= 0 {
            sendButtonDisabled = true
        }
        let message = SupportMessage(id: -1, subject: nil, message: message, replyToId: dialogId, createdAt: Date().timeIntervalSince1970, files: files)
        messagesInProcess.insert(message, at: 0)
        let oldDataSource = decoratedMessages
        decorateMessages()
        MessageHandler.shared.send(message: message, subjectId: subjectId, subjectName: subjectName)
        return oldDataSource.extendedDiff(decoratedMessages) { (firstObject, secondObject) -> Bool in
            if let firstObject = firstObject as? SupportMessage, let secondObject = secondObject as? SupportMessage {
                return firstObject.id == secondObject.id
            }
            if let firstObject = firstObject as? SupportDialogAttributeMessage, let secondObject = secondObject as? SupportDialogAttributeMessage {
                return firstObject.id == secondObject.id
            }
            if let firstObject = firstObject as? String, let secondObject = secondObject as? String {
                return firstObject == secondObject
            }
            return false
        }
    }
    
    func getIndexPathOfProcessMessage(messageId: Int) -> IndexPath? {
        if let index = decoratedMessages.firstIndex(where: {
            if let localMessage = $0 as? SupportMessage, localMessage.id == messageId {
                return true
            }
            return false
        }) {
            return IndexPath(row: index, section: 0)
        }
        return nil
    }
    
    func successSendMessage(messageId: Int, dialogId: Int) {
        if self.dialogId <= 0 {
            self.dialogId = dialogId
            self.subjectId = nil
            self.subjectName = nil
            NotificationCenter.default.post(name: NSNotification.Name("needUpdateTickets"), object: nil)
        }
        sendButtonDisabled = false
        if let message = messagesInProcess.first(where: { return $0.id == messageId }) {
            NotificationCenter.default.post(name: NSNotification.Name("successSendMessage"), object: nil, userInfo: ["dialogId":dialogId, "lastMessage":message.message])
            let files = message.files?.map({ (file) -> SupportDialogAttributeMessageFile in
                return SupportDialogAttributeMessageFile(id: -1, file: "", name: file.fileName, fileVisibility: "private", tempFileData: file.file)
            })
            messages.insert(SupportDialogAttributeMessage(id: 0, userFromId: 0, message: message.message, isRead: false, userRole: "cashback", createdDate: Date(timeIntervalSince1970: message.createdAt), fullname: "", avatar: nil, files: files), at: 0)
            messagesInProcess.removeAll(where: { return $0.id == messageId })
            decorateMessages()
        }
    }
    
    func getDialogId() -> Int {
        return dialogId
    }
    
    func downloadFile(key: String, path: String) {
        var loadInfoObject = (key, 0.0, true)
        self.downloadingFileKeys.removeAll(where: { $0.0 == key })
        self.downloadingFileKeys.append(loadInfoObject)
        CdnApiClient.downloadFile(fileId: path, key: key, changeProgress: { (progress) in
            loadInfoObject.1 = progress
        }) { [weak self] (result) in
            switch result {
            case .success(_):
                self?.downloadingFileKeys.removeAll(where: { $0.0 == key })
                break
            case .failure(_):
                if let existInfoObject = self?.downloadingFileKeys.first(where: { $0.0 == key }) {
                    self?.downloadingFileKeys.removeAll(where: { $0.0 == key })
                    self?.downloadingFileKeys.append((existInfoObject.0, existInfoObject.1, false))
                }
                break
            }
        }
    }
    
    func progress(for key: String) -> Double {
        if let loadInfoObject = self.downloadingFileKeys.first(where: { return $0.0 == key }) {
            return loadInfoObject.1
        }
        return 0.0
    }
    
    func checkFileIsAlredyLoad(key: String) -> Bool {
        return LruFileCache.shared.exist(forKey: key)
    }
    
    func checkFileIsDownloading(key: String) -> Bool {
        return downloadingFileKeys.contains(where: { return $0.0 == key })
    }
    
    func checkFileIsFailed(key: String) -> Bool {
        return downloadingFileKeys.contains(where: { return $0.0 == key && !$0.2 })
    }
    
    func getFile(key: String, fileResult:((Data?)->())?) {
        if processGetFileFromDisk { return }
        processGetFileFromDisk = true
        LruFileCache.shared.file(forKey: key) { [weak self] (fileData) in
            fileResult?(fileData)
            self?.processGetFileFromDisk = false
        }
    }
    
    func getFilePath(key: String) -> String? {
        return LruFileCache.shared.filePath(forKey: key)
    }
    
    func checkMessageIsFailure(messageId: Int) -> Bool {
        if MessageHandler.shared.checkMessageInProcess(messageId: messageId) { return false }
        return true
    }
    
    func resendMessage(messageId: Int) -> IndexPath? {
        guard let messageInProcess = messagesInProcess.first(where: { return $0.id == messageId }) else { return nil }
        MessageHandler.shared.send(message: messageInProcess)
        if let index = decoratedMessages.firstIndex(where: { (decoratedItem) -> Bool in
            if let localMessage = decoratedItem as? SupportMessage, localMessage.id == messageId {
                return true
            }
            return false
        }) {
            return IndexPath(row: index, section: 0)
        }
        return nil
    }
    
    func deleteMessage(messageId: Int) -> ExtendedDiff? {
        messagesInProcess.removeAll(where: { return $0.id == messageId })
        OperationQueue.main.addOperation {
            CoreDataStorageContext.shared.removeMessage(messageId: messageId)
        }
        let oldDataSource = decoratedMessages
        decorateMessages()
        return oldDataSource.extendedDiff(decoratedMessages) { (firstObject, secondObject) -> Bool in
            if let firstObject = firstObject as? SupportMessage, let secondObject = secondObject as? SupportMessage {
                return firstObject.id == secondObject.id
            }
            if let firstObject = firstObject as? SupportDialogAttributeMessage, let secondObject = secondObject as? SupportDialogAttributeMessage {
                return firstObject.id == secondObject.id
            }
            if let firstObject = firstObject as? String, let secondObject = secondObject as? String {
                return firstObject == secondObject
            }
            return false
        }
    }
 
    private func getDateString(date: Date) -> String {
        if Calendar.current.isDateInToday(date) {
            return NSLocalizedString("Today", comment: "")
        } else if Calendar.current.isDateInYesterday(date) {
            return NSLocalizedString("Yesterday", comment: "")
        } else {
            return formatter.string(from: date)
        }
    }
    
    private func markAllUnreadMessagesAsRead() {
        let unreadMessages = messages.filter({ return !$0.isRead && ($0.userRole == "support" || $0.userRole == "admin") })
        countOfUnreadMessages = unreadMessages.count
        for index in 0..<unreadMessages.count {
            SupportApiClient.markMessageAsRead(messageId: "\(unreadMessages[index].id)") { [weak self] (result) in
                guard let self = self else { return }
                switch result {
                case .success(_):
                    self.countOfUnreadMessages -= 1
                    if self.countOfUnreadMessages <= 0 {
                        NotificationCenter.default.post(name: NSNotification.Name("markTicketAsRead"), object: nil, userInfo: ["ticketId": self.dialogId])
                        NotificationCenter.default.post(name: NSNotification.Name("updateUnreadCount"), object: nil, userInfo: ["ticketId": self.dialogId])
                    }
                    break
                case .failure(_):
                    break
                }
            }
        }
    }
}
