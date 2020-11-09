//
//  MessageViewModel.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 14/06/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import XCoordinator

class MessageViewModel: MessageModelType {
    
    private var messages : [LocalNotification]! = []
    private var groupingMessages = Dictionary<String, Array<LocalNotification>>()
    private var sortedDictionaryKeys = Array<String>()
    private var groupingSearchMessages = Dictionary<String, Array<LocalNotification>>()
    private var sortedSearchDictionaryKeys = Array<String>()
    private var readedMessages = Array<Int64>()
    private var isSearching = false
    private let pageSize = 20
    private var page = 1
    private var allIsLoad = false
    
    private let router: UnownedRouter<MessagesRoute>
    
    init(router: UnownedRouter<MessagesRoute>) {
        self.router = router
    }
    
    func goOnBack() {
        router.trigger(.back)
    }
    
    func loadNextMessages(completion: (()->())?, failure: ((Int)->())?) {
        let nextMessages = CoreDataStorageContext.shared.fetchPushNotifications(limit: pageSize, offSet: messages.count) ?? []
        if(nextMessages.count < pageSize) {
            allIsLoad = true
        }
        page += 1
        messages.append(contentsOf: nextMessages)
        
        buildGroupingMessages(messages: messages, isSearch: false)
        completion?()
    }
    
    private func buildGroupingMessages(messages: [LocalNotification], isSearch: Bool) {
        if(isSearch) {
            sortedSearchDictionaryKeys.removeAll()
            groupingSearchMessages.removeAll()
        } else{
            sortedDictionaryKeys.removeAll()
            groupingMessages.removeAll()
        }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.dateFormat = "dd MMM, HH:mm"
        messages.forEach { (message) in
            let key = dateFormatter.string(from: message.date)
            var messagesArray = isSearch ? groupingSearchMessages[key] : groupingMessages[key]
            if (messagesArray == nil) {
                messagesArray = Array<LocalNotification>()
                if isSearch {
                    sortedSearchDictionaryKeys.append(key)
                } else {
                    sortedDictionaryKeys.append(key)
                }
            }
            messagesArray!.append(message)
            if(isSearch) {
                groupingSearchMessages[key] = messagesArray
            } else {
                groupingMessages[key] = messagesArray
            }
        }
    }
    
    func numberOfSections() -> Int {
        return isSearching ? sortedSearchDictionaryKeys.count : sortedDictionaryKeys.count
    }

    func numberOfItems(inSection section:Int) -> Int {
        return isSearching ? groupingSearchMessages[sortedSearchDictionaryKeys[section]]?.count ?? 0 :  groupingMessages[sortedDictionaryKeys[section]]?.count ?? 0
    }
    
    func titleForSection(section: Int) -> String {
        return isSearching ? sortedSearchDictionaryKeys[section] : sortedDictionaryKeys[section]
    }
    
    func getItemTitle(forIndexPath indexPath: IndexPath) -> String {
        return isSearching ? groupingSearchMessages[sortedSearchDictionaryKeys[indexPath.section]]?[indexPath.row].title ?? "" : groupingMessages[sortedDictionaryKeys[indexPath.section]]?[indexPath.row].title ?? ""
    }
    
    func getItemBody(forIndexPath indexPath: IndexPath) -> String {
        return isSearching ? groupingSearchMessages[sortedSearchDictionaryKeys[indexPath.section]]?[indexPath.row].body ?? "" : groupingMessages[sortedDictionaryKeys[indexPath.section]]?[indexPath.row].body ?? ""
    }
    
    func getItemIsRead(forIndexPath indexPath: IndexPath) -> Bool {
        return isSearching ? groupingSearchMessages[sortedSearchDictionaryKeys[indexPath.section]]?[indexPath.row].isRead ?? false : groupingMessages[sortedDictionaryKeys[indexPath.section]]?[indexPath.row].isRead ?? false
    }
    
    func getSectionHeaderHeight() -> Int {
        return 45
    }
    
    func search(withText text: String, completion: (()->())?, failure: ((Int)->())?) {
        let searchMessages = text.isEmpty ? self.messages ?? [] : CoreDataStorageContext.shared.fetchPushNotificationsFromSearch(searchText: text) ?? []
        buildGroupingMessages(messages: searchMessages, isSearch: true)
        completion?()
    }
    
    func hasMessages() -> Bool {
        return (CoreDataStorageContext.shared.fetchPushNotifications()?.count ?? 0) > 0
    }
    
    func setSearchingFlag(isSearching: Bool) {
        self.isSearching = isSearching
    }
    
    func searching() -> Bool {
        return isSearching
    }
    
    func getAllIsLoad() -> Bool {
        return allIsLoad
    }
    
    func willDisplayItem(indexPath:IndexPath) {
        if isSearching {
            return
        }
        guard let message = groupingMessages[sortedDictionaryKeys[indexPath.section]]?[indexPath.row] else {
            return
        }
        if ( !message.isRead &&  !readedMessages.contains(message.id) ) {
            readedMessages.append(message.id)
        }
    }
    
    func commitReadFlags() {
        readedMessages.forEach { (identifier) in
            CoreDataStorageContext.shared.markReadMessage(withId: Int(identifier))
        }
    }
}
