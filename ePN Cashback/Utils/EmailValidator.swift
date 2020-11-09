//
//  EmailValidator.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 30/08/2018.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//

import Foundation

struct EmailValidator {
    
//    private let regexp = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9а-яА-Я.-]{1,64}$"
    private let regexp = "^[a-zA-Z0-9.!#$%&'*+\\/=?^_`{|}~-]+@[a-zA-Z0-9а-яА-Я](?:[a-zA-Z0-9а-яА-Я-]{0,61}[a-zA-Z0-9а-яА-Я])?(?:\\.[a-zA-Z0-9а-яА-Я](?:[a-zA-Z0-9а-яА-Я-]{0,61}[a-zA-Z0-9а-яА-Я])?)*$"
    let isCorrect:Bool
    
    let text: String
    
    init(text: String) {
        self.text = text
        self.isCorrect = text.range(of: regexp, options: .regularExpression) != nil
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func isValid(_ email: String) -> Bool {
        let emailRegEx = "(?:[a-zA-Z0-9!#$%\\&‘*+/=?\\^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%\\&'*+/=?\\^_`{|}" +
        "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
        "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-" +
        "z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5" +
        "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
        "9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
        "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
}
