//
//  ProfileBindEmailViewModel.swift
//  Backit
//
//  Created by Александр Кузьмин on 10.04.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation
import XCoordinator
import RxRelay

class ProfileBindEmailViewModel: NSObject {
    
    // MARK: - Instance Properties
    
    weak var delegate: ProfileBindEmailVCDelegate?
    
    var title: String {
        NSLocalizedString("Email", comment: "")
    }
    
    var backButtonTitle: String {
        NSLocalizedString("Back", comment: "")
    }
    
    var doneButtonTitle: String {
        NSLocalizedString("Done", comment: "")
    }
    
    // MARK: -
    
    private let router: UnownedRouter<ProfileRoute>
    private let repository = ProfileRepository.shared
    
    // MARK: - Initializer
    
    init(router: UnownedRouter<ProfileRoute>) {
        self.router = router
        super.init()
    }
    
    // MARK: - Instance Methods
    
    func success(email: String) {
        router.trigger(.back) { [weak self] in
            self?.delegate?.successBindEmail(email: email)
        }
    }
    
    func back() {
        router.trigger(.back)
    }
}
