//
//  UIBackitButton.swift
//  Backit
//
//  Created by Ivan Nikitin on 28/02/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import UIKit
import TransitionButton

public enum BackitButtonStyle: Int {
    case black = 1
    case white = 2
    case disabled = 3
    case blackBorder = 4
    case blackBorderDisabled = 5
}

public extension TransitionButton {
    
    func changeButtonStyle(_ style: BackitButtonStyle) {
        switch style {
        case .black:
            self.backgroundColor = .moscow
            self.setTitleColor(.zurich, for: .normal)
            self.layer.cornerRadius = 2
            self.borderWidth = 0
            self.borderColor = .moscow
            self.isEnabled = true
        case .white:
            self.backgroundColor = .paris
            self.setTitleColor(.sydney, for: .normal)
            self.layer.cornerRadius = 2
            self.borderWidth = 0
            self.borderColor = .paris
            self.isEnabled = true
        case .disabled:
            self.backgroundColor = .paris
            self.setTitleColor(.minsk, for: .normal)
            self.layer.cornerRadius = 2
            self.borderWidth = 0
            self.borderColor = .paris
            self.isEnabled = false
        case .blackBorder:
            self.backgroundColor = .moscow
            self.setTitleColor(.zurich, for: .normal)
            self.layer.cornerRadius = 2
            self.borderWidth = 1
            self.borderColor = .london
            self.isEnabled = true
        case .blackBorderDisabled:
            self.backgroundColor = .moscow
            self.setTitleColor(.london, for: .normal)
            self.layer.cornerRadius = 2
            self.borderWidth = 1
            self.borderColor = .london
            self.isEnabled = false
        }
    }
    
    func setupButtonStyle(with style: BackitButtonStyle) {
        self.titleLabel?.font = .semibold15
        changeButtonStyle(style)
    }
}

