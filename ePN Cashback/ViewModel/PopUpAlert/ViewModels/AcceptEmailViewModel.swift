//
//  AcceptEmailViewModel.swift
//  Backit
//
//  Created by Elina Batyrova on 17.08.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation
import RxSwift
import XCoordinator

class AcceptEmailViewModel: PopUpAlertViewModelProtocol {
    
    // MARK: - Instance Properties
    
    var title: String {
        NSLocalizedString("Confirm mail address", comment: "")
    }
    
    var description: String {
        NSLocalizedString("A confirmation mail has been set to your mailbox", comment: "")
    }
    
    var buttonTitle: String {
        NSLocalizedString("Ok, thanks", comment: "")
    }
    
    var linkTitle: String? {
        NSLocalizedString("Send again", comment: "")
    }
    
    var isLinkActionLoading: Observable<Bool>? {
        isLinkActionLoadingSubject.asObserver()
    }
    
    var error: Observable<Error> {
        errorSubject.asObserver()
    }
    
    // MARK: -
    
    private var isLinkActionLoadingSubject = PublishSubject<Bool>()
    private var errorSubject = PublishSubject<Error>()
    
    private let router: UnownedRouter<ProfileRoute>
    private let delegate: AcceptMailVCDelegate
    
    // MARK: - Initializers
    
    init(router: UnownedRouter<ProfileRoute>, delegate: AcceptMailVCDelegate) {
        self.router = router
        self.delegate = delegate
    }
    
    // MARK: - Instance Methods
    
    func buttonAction() {
        self.router.trigger(.dismiss)
    }
    
    func linkAction() {
        isLinkActionLoadingSubject.onNext(true)

        ProfileApiClient.confirmEmail { [weak self] (result) in
            guard let `self` = self else {
                return
            }

            self.isLinkActionLoadingSubject.onNext(false)

            switch result {
            case .success(_):
                self.router.trigger(.dismiss)
                self.delegate.emailIsSend()

            case .failure(let error):
                self.errorSubject.onNext(error)
            }
        }
    }
    
    func close() {
        router.trigger(.dismiss)
    }
}
