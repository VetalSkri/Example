//
//  PasswordValidator.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 30/08/2018.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//

import Foundation

struct PasswordValidator {
    
    /// Правила, которые обеспечивают надежность пароля
    struct PasswordReliability: OptionSet {
        let rawValue: Int
        
        /// Буквы только из латинского алфавита Пароль состоит из <a-z; A-Z; 0-9; символ>
        static let latinLettersOnly = PasswordReliability(rawValue: 1<<0)
        
        /// Буквы только из латинского алфавита Пароль состоит из <a-z; A-Z; 0-9; символ>
        static let excelentPassword = PasswordReliability(rawValue: 1<<1)
        
        /// Пароль состоит из <a-z; A-Z> или <a-z; A-Z; 0-9>
        static let goodPassword = PasswordReliability(rawValue: 1<<2)
        
        /// Пароль состоит из состоит из <a-z> или <a-z; 0-9>
        static let normalPassword = PasswordReliability(rawValue: 1<<3)
        
        /// Содержит больше 7 символов
        static let atLeastEightCharacters = PasswordReliability(rawValue: 1<<4)
        
        /// Содержит хотя бы 1 прописную букву
        static let cursiveLetter = PasswordReliability(rawValue: 1<<5)
        
        /// Содержит хотя бы 1 заглавную букву
        static let capitalLetter = PasswordReliability(rawValue: 1<<6)
        
        /// Содержит хотя бы 1 цифру
        static let number = PasswordReliability(rawValue: 1<<7)
        
        // Содержит что-то из этого !@#$%^&*()-_+=;:,./?\\|`~{}
        static let acceptableCharacters = PasswordReliability(rawValue: 1<<8)
        
        
        
    }
    
    private(set) var reliability: PasswordReliability = []
    
    let text: String
    
    
    init(text: String) {
        self.text = text
        
        // PasswordReliability.latinLettersOnly
        let isPassword = text.range(of: "^([a-zA-Z\\d!@#$%^&*()-_+=;:,./?\\|`~\\[\\]\\{\\}])*$", options: .regularExpression) != nil
        
        if isPassword == true {
            reliability.formUnion(.latinLettersOnly)
        }
        
        // PasswordReliability.atLeastEightCharacters. Также исключает пробелы.
        let atLeastEightCharacters = text.range(of: "^[\\S]{8,}$", options: .regularExpression) != nil
        
        if atLeastEightCharacters == true {
            reliability.formUnion(.atLeastEightCharacters)
        }
        
        // PasswordReliability.cursiveLetter
        let cursiveLetter = text.range(of: "(?=.*[a-z])[A-Za-z\\d!@#$%^&*()-_+=;:,./?\\|`~{}]", options: .regularExpression) != nil
        
        if cursiveLetter == true {
            reliability.formUnion(.cursiveLetter)
        }
        
        // PasswordReliability.capitalLetter
        let capitalLetter = text.range(of: "(?=.*[A-Z])[A-Za-z\\d!@#$%^&*()-_+=;:,./?\\|`~{}]", options: .regularExpression) != nil
        
        if capitalLetter == true {
            reliability.formUnion(.capitalLetter)
        }
        
        // PasswordReliability.number
        let number = text.range(of: "(?=.*\\d)[A-Za-z\\d!@#$%^&*()-_+=;:,./?\\|`~{}]", options: .regularExpression) != nil
        
        if number == true {
            reliability.formUnion(.number)
        }
        
        // PasswordReliability.acceptableCharacters
        let acceptableCharacters = text.rangeOfCharacter(from: CharacterSet(charactersIn: "!@#$%^&*()-_+=;:,./?\\|`~{}[]") ) != nil
        
        if acceptableCharacters == true {
            reliability.formUnion(.acceptableCharacters)
        }
        
        
        let isNormalPassword = atLeastEightCharacters && (cursiveLetter || number  || capitalLetter || acceptableCharacters)
        if isNormalPassword == true {
            reliability.formUnion(.normalPassword)
        }
        
        let isGoodPassword = atLeastEightCharacters && cursiveLetter && capitalLetter && (cursiveLetter && capitalLetter || number || acceptableCharacters)
        
        if isGoodPassword == true {
            reliability.formUnion(.goodPassword)
        }
        
        // Костыль, который исключает все оставшиеся варианты и решает, что проблема в том, что тут просто не латинские буквы
        let isExcelentPassword = isPassword && atLeastEightCharacters && cursiveLetter && capitalLetter && number && acceptableCharacters
        if isExcelentPassword == true {
            reliability.formUnion(.excelentPassword)
        }
        
    }
    
}
