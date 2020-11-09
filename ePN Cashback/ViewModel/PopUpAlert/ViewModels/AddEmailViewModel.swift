//
//  AddEmailViewModel.swift
//  Backit
//
//  Created by Elina Batyrova on 21.08.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation
import RxSwift
import XCoordinator

class AddEmailViewModel: PopUpAlertViewModelProtocol {
    
    // MARK: - Instance Properties
    
    var title: String {
        NSLocalizedString("Add email", comment: "")
    }
    
    var description: String {
        NSLocalizedString("Add and confirm email", comment: "")
    }
    
    var buttonTitle: String {
        NSLocalizedString("Add email button", comment: "")
    }
    
    var error: Observable<Error> {
        errorSubject.asObserver()
    }
    
    // MARK: -
    
    private var errorSubject = PublishSubject<Error>()
    
    private let router: UnownedRouter<ProfileRoute>
    private let delegate: ProfileViewModelDelegate
    
    // MARK: - Initializers
    
    init(router: UnownedRouter<ProfileRoute>, delegate: ProfileViewModelDelegate) {
        self.router = router
        self.delegate = delegate
    }
    
    // MARK: - Instance Methods
    
    func buttonAction() {
        self.router.trigger(.dismiss)
        self.delegate.bindEmail()
    }
    
    func close() {
        router.trigger(.dismiss)
    }
}
