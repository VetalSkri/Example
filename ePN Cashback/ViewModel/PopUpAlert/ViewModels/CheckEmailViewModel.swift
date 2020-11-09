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

class CheckEmailViewModel: PopUpAlertViewModelProtocol {
    
    // MARK: - Instance Properties
    
    var title: String {
        NSLocalizedString("Check your email!", comment: "")
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
    
    var alertMessage: Observable<String>? {
        alertMessageSubject.asObserver()
    }
    
    // MARK: -
    
    private var isLinkActionLoadingSubject = PublishSubject<Bool>()
    private var errorSubject = PublishSubject<Error>()
    private var alertMessageSubject = PublishSubject<String>()
    
    private let router: UnownedRouter<ProfileRoute>
    
    // MARK: - Initializers
    
    init(router: UnownedRouter<ProfileRoute>) {
        self.router = router
    }
    
    // MARK: - Instance Methods
    
    func buttonAction() {
        self.router.trigger(.dismiss)
    }
    
    func linkAction() {
        isLinkActionLoadingSubject.onNext(true)
        
        ProfileApiClient.sendEmail(completion: { [weak self] result in
            guard let `self` = self else {
                return
            }
            
            self.isLinkActionLoadingSubject.onNext(false)
            
            switch result {
            case .success:
                let message = NSLocalizedString("Success email sent", comment: "")
                self.alertMessageSubject.onNext(message)
                
            case .failure(let error):
                self.errorSubject.onNext(error)
            }
        })
    }
    
    func close() {
        router.trigger(.dismiss)
    }
}
