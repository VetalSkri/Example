//
//  AddPhoneNumberViewModelProtocol.swift
//  Backit
//
//  Created by Elina Batyrova on 24.08.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation
import RxSwift

protocol AddPhoneNumberViewModelProtocol {
    
    // MARK: - Instance Properties
    
    var title: String { get }
    var leftBarButtonTitle: String { get }
    var rightBarButtonTitle: String { get }
    var textFieldPlaceholder: String { get }
    var infoText: String { get }
    var isLoading: Observable<Bool> { get }
    var error: Observable<Error> { get }
    
    // MARK: - Instance Methods
    
    func goBack()
    func sendCodeTo(number: String)
}
