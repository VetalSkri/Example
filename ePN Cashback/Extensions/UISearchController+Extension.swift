//
//  UISearchController.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 12/08/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

extension UISearchController {
    
    var hairlineView: UIView? {
        guard let barBackgroundView = self.searchBar.superview?.subviews.filter({ String(describing: type(of: $0)) == "_UIBarBackground" }).first
            else { return nil }
        
        return barBackgroundView.subviews.filter({ $0.bounds.height == 1 / self.traitCollection.displayScale }).first
    }
}

extension UISearchBar {
    private var textField: UITextField? {
        let subViews = self.subviews.flatMap { $0.subviews }
        if #available(iOS 13, *) {
            if let _subViews = subViews.last?.subviews {
                return (_subViews.filter { $0 is UITextField }).first as? UITextField
            }else{
                return nil
            }
        } else {
            return (subViews.filter { $0 is UITextField }).first as? UITextField
        }
    }
    private var searchIcon: UIImage? {
        let subViews = subviews.flatMap { $0.subviews }
        return  ((subViews.filter { $0 is UIImageView }).first as? UIImageView)?.image
    }
    //////
    private func getViewElement<T>(type: T.Type) -> T? {
        let svs = subviews.flatMap { $0.subviews }
        guard let element = (svs.filter { $0 is T }).first as? T else { return nil }
        return element
    }
    func getSearchBarTextField() -> UITextField? {
        return getViewElement(type: UITextField.self)
    }
    func setTextColor(color: UIColor) {
        if let textField = getSearchBarTextField() {
            textField.textColor = color
        }
    }
    func setTextFieldColor(color: UIColor) {
        if let textField = getViewElement(type: UITextField.self) {
            switch searchBarStyle {
            case .minimal:
                textField.layer.backgroundColor = color.cgColor
                textField.layer.cornerRadius = 6
            case .prominent, .default:
                textField.backgroundColor = color
            @unknown default:
                break
            }
        }
    }
    func setPlaceholderTextColor(color: UIColor) {
        if let textField = getSearchBarTextField() {
            textField.attributedPlaceholder = NSAttributedString(string: self.placeholder != nil ? self.placeholder! : "", attributes: [NSAttributedString.Key.foregroundColor: color])
        }
    }
    ///////
    private var activityIndicator: UIActivityIndicatorView? {
        return textField?.leftView?.subviews.compactMap{ $0 as? UIActivityIndicatorView }.first
    }
    // Public API
    var isLoading: Bool {
        get {
            return activityIndicator != nil
        } set {
            let _searchIcon = searchIcon
            if newValue {
                if activityIndicator == nil {
                    let _activityIndicator = UIActivityIndicatorView(style: .gray)
                    _activityIndicator.startAnimating()
                    _activityIndicator.backgroundColor = UIColor.clear
                    let clearImage = UIImage().imageWithPixelSize(size: CGSize.init(width: 14, height: 14)) ?? UIImage()
                    self.setImage(clearImage, for: .search, state: .normal)
                    textField?.leftViewMode = .always
                    textField?.leftView?.addSubview(_activityIndicator)
                    let leftViewSize = CGSize.init(width: 14.0, height: 14.0)
                    _activityIndicator.center = CGPoint(x: leftViewSize.width/2, y: leftViewSize.height/2)
                }
            } else {
                self.setImage(_searchIcon, for: .search, state: .normal)
                activityIndicator?.removeFromSuperview()
            }
        }
    }
}
