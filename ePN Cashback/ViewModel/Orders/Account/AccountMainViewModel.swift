//
//  AccountMainViewModel.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 22/01/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import XCoordinator

class AccountMainViewModel: AccountMainModelType {
    
    private let router: UnownedRouter<AccountRoute>
    private var menuItems: [AccountMenuItem]!
    
    init(router: UnownedRouter<AccountRoute>) {
        self.router = router
        menuItems = [
            AccountMenuItem(logoName: "accountMenu_historyOfPayments", title: NSLocalizedString("Payment history", comment: ""), route: .paymentHistory),
            AccountMenuItem(logoName: "accountMenu_cbLink", title: NSLocalizedString("CB Links", comment: ""), route: .verifyLink),
            AccountMenuItem(logoName: "accountMenu_promocodes", title: NSLocalizedString("Promocodes", comment: ""), route: .promocodes),
            AccountMenuItem(logoName: "accountMenu_inviteFriends", title: NSLocalizedString("Invite Friends", comment: ""), route: .inviteFriends),
            AccountMenuItem(logoName: "accountMenu_support", title: NSLocalizedString("Support", comment: ""), route: .support),
            AccountMenuItem(logoName: "accountMenu_exit", title: NSLocalizedString("Exit", comment: ""), route: .logout)
        ]
    }
    
    func goOnNotifications() {
        router.trigger(.notifications)
    }
    
    func goOnSettings() {
        router.trigger(.settings)
    }
    
    func goOnFAQ() {
        router.trigger(.faq)
    }
    
    func showTitle() -> String {
        return ""
    }
    
    func logout() {
        PushApiClient.deleteToken { (_) in
            AuthApiClient.logout { (_) in }
            Util.deleteCurrentSessionData()
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        Session.shared.isAuth = false
        appDelegate.router.trigger(.auth(animate: false), with: TransitionOptions(animated: false))
    }
    
    func hasUnreadMessages() -> Bool {
        return CoreDataStorageContext.shared.hasUnreadMessage()
    }
    
    func numberOfMenuItems() -> Int {
        return menuItems.count
    }
    
    func item(for indexPath: IndexPath) -> AccountMenuItem {
        return menuItems[indexPath.row]
    }
    
    func selectItem(at indexPath: IndexPath) {
        let route = menuItems[indexPath.row].route
        if route == .logout {
            logout()
            return
        }
        router.trigger(menuItems[indexPath.row].route)
    }
    
    func header() -> AccountMenuHeaderReusableViewModel {
          return AccountMenuHeaderReusableViewModel(router: router)
    }

}

public struct AccountMenuItem {
    var logoName: String
    var title: String
    var route: AccountRoute
}
