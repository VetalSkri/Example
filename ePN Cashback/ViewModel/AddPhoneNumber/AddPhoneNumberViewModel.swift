//
//  AddPhoneNumberViewModel.swift
//  Backit
//
//  Created by Elina Batyrova on 24.08.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation
import XCoordinator
import RxSwift

class AddPhoneNumberViewModel: AddPhoneNumberViewModelProtocol {
    
    // MARK: - Instance Properties
    
    var title: String {
         NSLocalizedString("Phone", comment: "")
    }
    
    var leftBarButtonTitle: String {
        NSLocalizedString("Back", comment: "")
    }
    
    var rightBarButtonTitle: String {
        NSLocalizedString("Next", comment: "")
    }
    
    var textFieldPlaceholder: String {
        NSLocalizedString("Settings_PhoneNumber", comment: "")
    }
    
    var infoText: String {
        NSLocalizedString("Phone usage info", comment: "")
    }
    
    var isLoading: Observable<Bool> {
        isLoadingSubject.asObserver()
    }
    
    var error: Observable<Error> {
        errorSubject.asObserver()
    }
    
    // MARK: -
    
    private let router: UnownedRouter<ProfileRoute>
    
    private var errorSubject = PublishSubject<Error>()
    private var isLoadingSubject = PublishSubject<Bool>()
    
    // MARK: - Initializers
    
    init(router: UnownedRouter<ProfileRoute>) {
        self.router = router
    }
    
    // MARK: - Instance Methods
    
    func goBack() {
        router.trigger(.back)
    }
    
    func sendCodeTo(number: String) {
        isLoadingSubject.onNext(true)
                
        var phoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
           
        phoneNumber.insert("+", at: phoneNumber.startIndex)
        
        ProfileApiClient.getSmsCode(phone: phoneNumber, completion: { [weak self] result in
            guard let `self` = self else {
                return
            }
            
            self.isLoadingSubject.onNext(false)
            
            switch result {
            case .success(let response):
                self.router.trigger(.enterCode(step: .add(phoneNumber: phoneNumber)))
                
            case .failure(let error):
                self.errorSubject.onNext(error)
            }
        })
    }
}
