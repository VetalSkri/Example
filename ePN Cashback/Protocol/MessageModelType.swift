//
//  MessageModelType.swift
//  ePN Cashback
//
//  Created by Ivan Nikitin on 30/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

protocol MessageModelType {
    var title: String { get }
    var keyWordsText: String { get }
    var noNotificationsFoundText: String { get }
    var tryToRefourmulateText: String { get }
    var noNotificationsYetText: String { get }
    var notificationsWillBeDisplayText: String { get }
    
    func loadNextMessages(completion: (()->())?, failure: ((Int)->())?)
    func numberOfSections() -> Int
    func numberOfItems(inSection section:Int) -> Int
    func titleForSection(section: Int) -> String
    func getItemTitle(forIndexPath indexPath: IndexPath) -> String
    func getItemBody(forIndexPath indexPath: IndexPath) -> String
    func getItemIsRead(forIndexPath indexPath: IndexPath) -> Bool
    func getSectionHeaderHeight() -> Int
    func search(withText text: String, completion: (()->())?, failure: ((Int)->())?)
    func hasMessages() -> Bool
    func setSearchingFlag(isSearching: Bool)
    func searching() -> Bool
    func getAllIsLoad() -> Bool
    func willDisplayItem(indexPath:IndexPath)
    func commitReadFlags()
    
    func goOnBack()
}

extension MessageModelType {
    
    var title: String {
        return NSLocalizedString("Notifications", comment: "")
    }
    
    var keyWordsText: String {
        return NSLocalizedString("Key words", comment: "")
    }
    
    var noNotificationsFoundText: String {
        return NSLocalizedString("No notifications found", comment: "")
    }
    
    var tryToRefourmulateText: String {
        return NSLocalizedString("Try to reformulate your request", comment: "")
    }
    
    var noNotificationsYetText: String {
        return NSLocalizedString("No notifications yet", comment: "")
    }
    
    var notificationsWillBeDisplayText: String {
        return NSLocalizedString("Notifications will be displayed on this page", comment: "")
    }
    
    
}
