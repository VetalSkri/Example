//
//  LaunchInstructor.swift
//  ePN Cashback
//
//  Created by Ivan Nikitin on 12/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

enum LaunchInstructor {
    
    case main
    case auth
    case onboarding
    
    // MARK: - Public methods
    
    static func configure() -> LaunchInstructor {
        return Session.shared.isAuth ? .main : .auth
//        let isAuth = Session.shared.isAuth
//        let isFirstLaunch = Session.shared.isFirstLaunchApp
//        switch (isAuth, isFirstLaunch) {
//        case (true, false): return .main
//        case (false, false): return .auth
//        case (false, true), (true, true): return .onboarding
//        }
    }
}

enum MainLaunchInstructor {
    
    case shops
    case promotions
    case orders
    case account
    
    // MARK: - Public methods
    
    static func configure(page: Int) -> MainLaunchInstructor {
        switch page {
        case 0: return .shops
        case 1: return .promotions
        case 2: return .orders
        case 3: return .account
        default:
            return .shops
        }
    }
}
