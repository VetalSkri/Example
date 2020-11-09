//
//  EnterCodeViewModel.swift
//  Backit
//
//  Created by Elina Batyrova on 26.08.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation
import XCoordinator
import RxSwift

enum EnterCodeStep {
    case add(phoneNumber: String)
    case editCurrentStep(currentPhoneNumber: String, newPhoneNumber: String)
    case editNewStep(currentPhoneNumber: String, newPhoneNumber: String)
}

class EnterCodeViewModel: EnterCodeViewModelProtocol {
    
    // MARK: - Instance Properties
    
    var title: String {
        switch step {
        case .add:
            return NSLocalizedString("Phone", comment: "")
            
        case .editCurrentStep, .editNewStep:
            return NSLocalizedString("Settings_ChangeNumber", comment: "")
        }
    }
    
    var leftBarButtonTitle: String {
        NSLocalizedString("Back", comment: "")
    }
    
    var rightBarButtonTitle: String {
        NSLocalizedString("Done", comment: "")
    }
    
    var instruction: NSMutableAttributedString {
        switch step {
        case .add:
            return NSMutableAttributedString(string: NSLocalizedString("Please enter code", comment: ""))
            
        case .editCurrentStep(let currentPhoneNumber, _):
            let shouldHideString = currentPhoneNumber.prefix(upTo: currentPhoneNumber.index(currentPhoneNumber.endIndex, offsetBy: -3))
            let range = currentPhoneNumber.range(of: shouldHideString)!
            let phone = currentPhoneNumber.replacingCharacters(in: range, with: String(repeating: "*", count: currentPhoneNumber.count - 3))
            
            let specificColorText = "(" + NSLocalizedString("Settings_OldPhoneNumber", comment: "") + " " + phone + ")"
            let mainText = NSLocalizedString("Please enter code", comment: "") + " " + specificColorText
            
            let specificColorRange = (mainText as NSString).range(of: specificColorText)
            
            let attributedString = NSMutableAttributedString(string: mainText)
            attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.semibold15 , range: specificColorRange)
            
            return attributedString
            
        case .editNewStep(_, let newPhoneNumber):
            let shouldHideString = newPhoneNumber.prefix(upTo: newPhoneNumber.index(newPhoneNumber.endIndex, offsetBy: -3))
            let range = newPhoneNumber.range(of: shouldHideString)!
            let phone = newPhoneNumber.replacingCharacters(in: range, with: String(repeating: "*", count: newPhoneNumber.count - 3))
            
            let specificColorText = "(" + NSLocalizedString("Settings_NewPhoneNumber", comment: "") + " " + phone + ")"
            let mainText = NSLocalizedString("Please enter code", comment: "") + " " + specificColorText
            
            let specificColorRange = (mainText as NSString).range(of: specificColorText)
            
            let attributedString = NSMutableAttributedString(string: mainText)
            attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.semibold15 , range: specificColorRange)
            
            return attributedString
        }
        
    }
    
    var errorMessage: String {
        NSLocalizedString("Incorrect code. Please try again", comment: "")
    }
    
    var timerDescription: String {
        NSLocalizedString("Send again in", comment: "")
    }
    
    var sendAgainButtonTitle: String {
        NSLocalizedString("Send again", comment: "")
    }
    
    var isLoading: Observable<Bool> {
        isLoadingSubject.asObserver()
    }
    
    var error: Observable<Error> {
        errorSubject.asObserver()
    }
    
    var isCodeSent: Observable<Error?> {
        isCodeSentSubject.asObserver()
    }

    // MARK: -
    
    private let router: UnownedRouter<ProfileRoute>
    private let step: EnterCodeStep
    
    private var errorSubject = PublishSubject<Error>()
    private var isLoadingSubject = PublishSubject<Bool>()
    private var isCodeSentSubject = PublishSubject<Error?>()
    
    private var access: AccessToCurrentNumber = .yesAccess
    
    // MARK: - Initializers
    
    init(router: UnownedRouter<ProfileRoute>, step: EnterCodeStep) {
        self.router = router
        self.step = step
    }
    
    // MARK: - Instance Methods
    
    func goBack() {
        router.trigger(.back)
    }
    
    func send(code: String) {
        isLoadingSubject.onNext(true)
        
        switch step {
        case .add(let phoneNumber):
            ProfileApiClient.confirmPhone(phone: phoneNumber, code: code, completion: { [weak self] result in
                guard let `self` = self else {
                    return
                }
                
                self.isLoadingSubject.onNext(false)
                
                switch result {
                case .success:
                    self.router.trigger(.backToProfileAndShouldCheckEmailAlert)
                    
                case .failure(let error):
                    self.errorSubject.onNext(error)
                }
            })
            
        case .editCurrentStep(let currentPhoneNumber, let newPhoneNumber):
            ProfileApiClient.confirmOldPhone(phone: currentPhoneNumber, code: code, access: .yesAccess, completion: { [weak self] result in
                guard let `self` = self else {
                    return
                }
                
                self.isLoadingSubject.onNext(false)
                
                switch result {
                case .success:
                    self.isLoadingSubject.onNext(true)
                    
                    ProfileApiClient.getSmsCode(phone: newPhoneNumber, completion: { [weak self] result in
                        guard let `self` = self else {
                            return
                        }
                        
                        self.isLoadingSubject.onNext(false)
                        
                        switch result {
                        case .success:
                            self.router.trigger(.enterCode(step: .add(phoneNumber: newPhoneNumber)))
                            
                        case .failure(let error):
                            self.errorSubject.onNext(error)
                        }
                    })
                    
                case .failure(let error):
                    self.errorSubject.onNext(error)
                }
            })
            
        case .editNewStep(_, let newPhoneNumber):
            ProfileApiClient.confirmOldPhone(phone: newPhoneNumber, code: code, access: .noAccess, completion: { [weak self] result in
                guard let `self` = self else {
                    return
                }
                
                self.isLoadingSubject.onNext(false)
                
                switch result {
                case .success:
                    self.router.trigger(.backToProfileAndShouldCheckEmailAlert)
                    
                case .failure(let error):
                    self.errorSubject.onNext(error)
                }
            })
        }
    }
    
    func retryCodeSending() {
        switch step {
        case .add(let phoneNumber):
            self.retryCodeSendingTo(phone: phoneNumber)
            
        case .editCurrentStep(let currentPhoneNumber, let newPhoneNumber):
            self.access = .yesAccess
            self.retryEditPhoneGetSmsCode(currentNumber: currentPhoneNumber, newNumber: newPhoneNumber)           
        case .editNewStep(let currentPhoneNumber, let newPhoneNumber):
            self.access = .noAccess
            self.retryEditPhoneGetSmsCode(currentNumber: currentPhoneNumber, newNumber: newPhoneNumber)
        }
    }
    
    // MARK: -
    private func retryEditPhoneGetSmsCode(currentNumber: String, newNumber: String) {
        ProfileApiClient.editPhoneGetSmsCode(currentPhone: currentNumber, newPhone: newNumber, access: self.access, completion: { [weak self] result in
            guard let `self` = self else {
                return
            }
            
            self.isLoadingSubject.onNext(false)
            
            switch result {
            case .success:
                self.isCodeSentSubject.onNext(nil)
            case .failure(let error):
                self.isCodeSentSubject.onNext(error)
            }
        })
    }
    
    private func retryCodeSendingTo(phone: String) {
        isLoadingSubject.onNext(true)
        
        ProfileApiClient.getSmsCode(phone: phone, completion: { [weak self] result in
            guard let `self` = self else {
                return
            }
            
            self.isLoadingSubject.onNext(false)
            
            switch result {
            case .success:
                self.isCodeSentSubject.onNext(nil)
                
            case .failure(let error):
                self.isCodeSentSubject.onNext(error)
            }
        })
    }
}
