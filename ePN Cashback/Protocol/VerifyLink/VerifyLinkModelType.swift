//
//  VerifyLinkModelType.swift
//  ePN Cashback
//
//  Created by Ivan Nikitin on 26/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

protocol VerifyLinkModelType {
    
    var getPlaceholderText: String { get }
    var infoText: String { get }
    var buttonText: String { get }
    var headTitle: String { get }

    func setLink(urlLink: String?)
    func verifyTheLink(completion: (()->())?, failure: ((Int)->())?)
    
    func goOnResultOfVerifyLink()
    func goOnBack()
    func goOnIncorrectLinkResult()
}

extension VerifyLinkModelType {
    
    var getPlaceholderText: String {
        return NSLocalizedString("Link to item", comment: "")
    }
    
    var infoText: String {
        return NSLocalizedString("Insert a link", comment: "")
    }
    
    var buttonText: String {
        return NSLocalizedString("Check", comment: "")
    }
    
    var headTitle: String {
        return NSLocalizedString("Cashback link and price dynamics", comment: "")
    }
    
    
}
