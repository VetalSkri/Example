//
//  UITextField.swift
//  Backit
//
//  Created by Виталий Скриганюк on 03.07.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import UIKit

extension UITextField {
    func setCursorToTextfieldEnd() {
        let end = self.endOfDocument
        self.selectedTextRange = self.textRange(from: end, to: end)
    }
}
