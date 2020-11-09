//
//  PopUpAlertViewModelProtocol.swift
//  Backit
//
//  Created by Elina Batyrova on 17.08.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation
import RxSwift

protocol PopUpAlertViewModelProtocol: AnyObject {
    
    // MARK: - Instance Properties
    
    var title: String { get }
    var description: String { get }
    var buttonTitle: String { get }
    var linkTitle: String? { get }
    var isLinkActionLoading: Observable<Bool>? { get }
    var alertMessage: Observable<String>? { get }
    var error: Observable<Error> { get }
    
    // MARK: - Instance Methods
    
    func buttonAction()
    func close()
    func linkAction()
}

extension PopUpAlertViewModelProtocol {
    
    // MARK: - Instance Properties
    
    var isLinkRequired: Bool {
        linkTitle != nil
    }
    
    var linkTitle: String? {
        nil
    }
    
    var isLinkActionLoading: Observable<Bool>? {
        nil
    }
    
    var alertMessage: Observable<String>? {
        nil
    }
    
    // MARK: - Instance Methods
    
    func linkAction() {
        if isLinkRequired {
            linkAction()
        }
    }
}
