//
//  AccountMenuViewCellViewModel.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 23/01/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

class AccountMenuViewCellViewModel {
    
    private var index: Int
    
    var titleHistoryOfPayments: String {
        return NSLocalizedString("Payment history", comment: "")
    }
    var titleCBLinks: String {
        return NSLocalizedString("CB Links", comment: "")
    }
    var titlePromocodes: String {
        return NSLocalizedString("Promocodes", comment: "")
    }
    var titleInviteFriends: String {
        return NSLocalizedString("Invite Friends", comment: "")
    }
    var titleSupport: String {
        return NSLocalizedString("Support", comment: "")
    }
    var titleExit: String {
        return NSLocalizedString("Exit", comment: "")
    }
    
    var logoHistoryOfPayments: UIImage {
        return UIImage(named: "accountMenu_historyOfPayments")!
    }
    var logoCBLinks: UIImage {
        return UIImage(named: "accountMenu_cbLink")!
    }
    var logoPromocodes: UIImage {
        return UIImage(named: "accountMenu_promocodes")!
    }
    var logoInviteFriends: UIImage {
        return UIImage(named: "accountMenu_inviteFriends")!
    }
    var logoSupport: UIImage {
        return UIImage(named: "accountMenu_support")!
    }
    var logoExit: UIImage {
        return UIImage(named: "accountMenu_exit")!
    }
    
    func data() -> (String, UIImage) {
        switch index {
        case 1:
            return (titleHistoryOfPayments, logoHistoryOfPayments)
        case 2:
            return (titleCBLinks, logoCBLinks)
        case 3:
            return (titlePromocodes, logoPromocodes)
        case 4:
            return (titleInviteFriends, logoInviteFriends)
        case 5:
            return (titleSupport, logoSupport)
        case 6:
            return (titleExit, logoExit)
        default:
            return ("", UIImage())
        }
    }
    
    init(index: Int) {
        self.index = index
    }
}
