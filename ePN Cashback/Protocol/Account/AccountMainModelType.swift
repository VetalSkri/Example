//
//  AccountMainModelType.swift
//  ePN Cashback
//
//  Created by Ivan Nikitin on 24/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

protocol AccountMainModelType {
    func goOnFAQ()
    func goOnSettings()
    func goOnProfileSettings()
    func goOnNotifications()
    
    func showTitle() -> String
    func logout()
    func hasUnreadMessages() -> Bool
    
    func numberOfMenuItems() -> Int
    func item(for indexPath: IndexPath) -> AccountMenuItem
    func selectItem(at indexPath: IndexPath)
    
    func header() -> AccountMenuHeaderReusableViewModel
    
    func getUnreadCount(complete:((Bool)->())?)
}
