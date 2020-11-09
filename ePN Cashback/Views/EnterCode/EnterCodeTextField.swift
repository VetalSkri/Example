//
//  EnterCodeTextField.swift
//  Backit
//
//  Created by Elina Batyrova on 27.08.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import UIKit

class EnterCodeTextField: UITextField {
    
    // MARK: - Instance Methods
    
    override func deleteBackward() {
        if self.text?.count == 0 {
            findPrevious()
        } else {
            super.deleteBackward()
        }
    }
    
    func findPrevious() {
        let previousTextFieldTag = self.tag - 1
        
        if let previousTextField = self.superview?.viewWithTag(previousTextFieldTag) as? UITextField {
            previousTextField.becomeFirstResponder()
        }
    }
}
