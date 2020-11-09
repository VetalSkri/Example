//
//  EnterCodeViewModelProtocol.swift
//  Backit
//
//  Created by Elina Batyrova on 26.08.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation
import RxSwift

protocol EnterCodeViewModelProtocol {
    
    // MARK: - Instance Properties
    
    var title: String { get }
    var leftBarButtonTitle: String { get }
    var rightBarButtonTitle: String { get }
    var instruction: NSMutableAttributedString { get }
    var errorMessage: String { get }
    var timerDescription: String { get }
    var sendAgainButtonTitle: String { get }
    var isLoading: Observable<Bool> { get }
    var error: Observable<Error> { get }
    var isCodeSent: Observable<Error?> { get }
    
    // MARK: - Instance Methods
    
    func goBack()
    func send(code: String)
    func retryCodeSending()
}
