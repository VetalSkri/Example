//
//  InviteFriendsViewModel.swift
//  CashBackEPN
//
//  Created by Александр Кузьмин on 29/05/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import XCoordinator

class InviteFriendsFaqViewModel: InviteFriendsFaqModelType {
    
    private let router: UnownedRouter<AccountRoute>
    
    init(router: UnownedRouter<AccountRoute>) {
        self.router = router
    }
    
    func goOnBack() {
        router.trigger(.back)
    }
    
}
