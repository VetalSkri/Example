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
            AccountMenuItem(logoName: "accountMenu_historyOfPayments", title: NSLocalizedString("Payment history", comment: "") , subtitle: "", route: .paymentHistory),
            AccountMenuItem(logoName: "accountMenu_cbLink", title: NSLocalizedString("CB Links", comment: ""), subtitle: "", route: .verifyLink),
            AccountMenuItem(logoName: "accountMenu_promocodes", title: NSLocalizedString("Promocodes", comment: ""), subtitle: "", route: .promocodes),
            AccountMenuItem(logoName: "accountMenu_inviteFriends", title: NSLocalizedString("Invite Friends", comment: ""), subtitle: "", route: .inviteFriends),
            AccountMenuItem(logoName: "accountMenu_support", title: NSLocalizedString("Support", comment: ""), subtitle: "", route: .support),
            AccountMenuItem(logoName: "accountMenu_exit", title: NSLocalizedString("Exit", comment: ""), subtitle: "", route: .logout)
        ]
    }
    
    func goOnNotifications() {
        router.trigger(.notifications)
    }
    
    func goOnSettings() {
        router.trigger(.settings)
    }
    
    func goOnProfileSettings() {
        router.trigger(.profileSettings)
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
        appDelegate.router.trigger(.auth(animate: false), with: TransitionOptions(animated: false), completion: nil)
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
    
    func getUnreadCount(complete:((Bool)->())?) {
        SupportApiClient.getUnreadMessagesCount { [weak self] (result) in
            switch result {
            case .success(let response):
                if let supportItem = self?.menuItems.first(where: { return $0.route == .support }) {
                    supportItem.subtitle = response.data.attributes.unreadCount <= 0 ? "" : "\(response.data.attributes.unreadCount)"
                }
                complete?(true)
                break
            case .failure(_):
                complete?(false)
                break
            }
        }
    }

}

public class AccountMenuItem {
    var logoName: String
    var title: String
    var subtitle: String
    var route: AccountRoute
    
    init(logoName: String, title: String, subtitle: String, route: AccountRoute) {
        self.logoName = logoName
        self.title = title
        self.subtitle = subtitle
        self.route = route
    }
}
