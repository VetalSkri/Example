//
//  LandingViewModel.swift
//  Backit
//
//  Created by Александр Кузьмин on 20/11/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import XCoordinator

class LandingViewModel {
    
    private let router: UnownedRouter<OfflineCBRoute>
    
    init(router: UnownedRouter<OfflineCBRoute>) {
        self.router = router
    }
    
    func back() {
        router.trigger(.back)
    }
    
    func getUrl() -> URL? {
        return URL(string: "https://lottery.backit.me")
    }
    
}
