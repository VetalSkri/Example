//
//  EditPhoneNumberViewModel.swift
//  Backit
//
//  Created by Elina Batyrova on 31.08.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation
import RxSwift
import XCoordinator

enum AccessToCurrentNumber {
    case noAccess
    case yesAccess
}

class EditPhoneNumberViewModel: EditPhoneNumberViewModelProtocol {
    
    // MARK: - Instance Properties
    
    var title: String {
         NSLocalizedString("Settings_ChangeNumber", comment: "")
    }
    
    var leftBarButtonTitle: String {
        NSLocalizedString("Back", comment: "")
    }
    
    var rightBarButtonTitle: String {
        NSLocalizedString("Next", comment: "")
    }
    
    var firstTextFieldPlaceholder: String {
        NSLocalizedString("Settings_OldPhoneNumber", comment: "")
    }
    
    var secondTextFieldPlaceholder: String {
        NSLocalizedString("Settings_NewPhoneNumber", comment: "")
    }
    
    var infoText: NSMutableAttributedString {
        if self.access == .yesAccess {
            return NSMutableAttributedString(string: NSLocalizedString("Edit phone info 1", comment: ""))
        } else {
            let specificColorText = NSLocalizedString("Edit phone info 2 Specific Color", comment: "")
            let mainText = NSLocalizedString("Edit phone info 2", comment: "")
            
            let specificColorRange = (mainText as NSString).range(of: specificColorText)
            
            let attributedString = NSMutableAttributedString(string: mainText)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.prague , range: specificColorRange)
            
            return attributedString
        }
    }
    
    var isLoading: Observable<Bool> {
        isLoadingSubject.asObserver()
    }
    
    var error: Observable<Error> {
        errorSubject.asObserver()
    }
    
    // MARK: -
    
    private let router: UnownedRouter<ProfileRoute>
    private let access: AccessToCurrentNumber
    
    private var errorSubject = PublishSubject<Error>()
    private var isLoadingSubject = PublishSubject<Bool>()
    
    // MARK: - Initializers
    
    init(router: UnownedRouter<ProfileRoute>, access: AccessToCurrentNumber) {
        self.router = router
        self.access = access
    }
    
    // MARK: - Instance Methods
    
    func goBack() {
        router.trigger(.back)
    }
    
    func sendCode(currentNumber: String, newNumber: String) {
        var currentPhoneNumber = currentNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        var newPhoneNumber = newNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        currentPhoneNumber.insert("+", at: currentPhoneNumber.startIndex)
        newPhoneNumber.insert("+", at: newPhoneNumber.startIndex)
        
        isLoadingSubject.onNext(true)
        
        ProfileApiClient.editPhoneGetSmsCode(currentPhone: currentPhoneNumber, newPhone: newPhoneNumber, access: self.access, completion: { [weak self] result in
            guard let `self` = self else {
                return
            }

            self.isLoadingSubject.onNext(false)
            
            switch result {
                case .success:
                    if self.access == .yesAccess {
                        self.router.trigger(.enterCode(step: .editCurrentStep(currentPhoneNumber: currentPhoneNumber,
                                                                              newPhoneNumber: newPhoneNumber)))
                    } else {
                        self.router.trigger(.enterCode(step: .editNewStep(currentPhoneNumber: currentPhoneNumber,
                                                                          newPhoneNumber: newPhoneNumber)))
                    }

                case .failure(let error):
                    self.errorSubject.onNext(error)
            }
        })
    }
}
