//
//  CheckAccessToPhoneViewModel.swift
//  Backit
//
//  Created by Elina Batyrova on 30.08.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation
import XCoordinator

class CheckAccessToPhoneViewModel {
    
    // MARK: - Instance Properties
    
    var alertTitle: String {
        NSLocalizedString("Settings_AccessCheck", comment: "")
    }
    
    var alertDescription: String {
        let phoneNumber = Util.fetchProfile()?.phone ?? ""
        
        return NSLocalizedString("Settings_HaveAccessToPhoneNumber", comment: "") + " " + phoneNumber + "?"
    }
    
    var alertLeftButtonTitle: String {
        NSLocalizedString("Settings_No", comment: "")
    }
    
    var alertRightButtonTitle: String {
        NSLocalizedString("Settings_Yes", comment: "")
    }
    
    // MARK: -
    
    private let router: UnownedRouter<ProfileRoute>
    
    // MARK: - Initializer
    
    init(router: UnownedRouter<ProfileRoute>) {
        self.router = router
    }
    
    // MARK: - Instance Methods
    
    
    func closeController() {
        router.trigger(.dismiss)
    }
    
    func showNoAccessEditPhone() {
        router.trigger(.editPhone(access: .noAccess))
    }
    
    func showYesAccessEditPhone() {
        router.trigger(.editPhone(access: .yesAccess))
    }
}
