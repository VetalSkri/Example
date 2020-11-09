//
//  MainTabBarViewModel.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 28/01/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

class MainTabBarViewModel {
    private(set) var selectedIndex: Int
    
    init(index: Int) {
        self.selectedIndex = index
    }
    
    init() {
        self.selectedIndex = 0
    }
    
    func loadUserProfile() {
        
        ProfileApiClient.profile { (result) in
            switch result {
            case .success(let response):
                OperationQueue.main.addOperation {
                    Util.saveProfileData(profile: response.data.attributes)
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    func loadUserBalance() {
        BalanceApiClient.balance { (result) in
            switch result {
            case .success(let response):
                OperationQueue.main.addOperation {
                    Util.saveBalance(allBalance: response.data)
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
}
