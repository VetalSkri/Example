//
//  EditPhoneNumberViewModelProtocol.swift
//  Backit
//
//  Created by Elina Batyrova on 31.08.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation
import RxSwift

protocol EditPhoneNumberViewModelProtocol {
    
    // MARK: - Instance Properties
    
    var title: String { get }
    var leftBarButtonTitle: String { get }
    var rightBarButtonTitle: String { get }
    var firstTextFieldPlaceholder: String { get }
    var secondTextFieldPlaceholder: String { get }
    var infoText: NSMutableAttributedString { get }
    var isLoading: Observable<Bool> { get }
    var error: Observable<Error> { get }
    
    // MARK: - Instance Methods
    
    func goBack()
    func sendCode(currentNumber: String, newNumber: String)
}
