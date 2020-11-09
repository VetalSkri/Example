//
//  SnapBar.swift
//  Backit
//
//  Created by Ivan Nikitin on 11/10/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

class SnapBar {
        
    private var view: UIView
    
    init(superView: UIView){
        self.view = superView
    }
    
    private lazy var snapbar: UIView = {
        let containerView = UIView()
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = CommonStyle.cornerRadius
        containerView.backgroundColor = .sydney
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.tag = 99
        return containerView
    }()
    
    private lazy var labelForSnapbar: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.text = NSLocalizedString("title_snapbar", comment: "")
        label.textColor = .zurich
        label.font = UIFont.bold20
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.1
        return label
    }()
    
    private lazy var lowLabelForSnapbar: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.text = NSLocalizedString("low_title_snapbar", comment: "")
        label.textColor = .zurich
        label.font = UIFont.medium13
        return label
    }()
    
    private lazy var imageForSnapbar: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Pes")
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var closeButtonSnapbar: EPNCloseButton = {
        let closeButton = EPNCloseButton()
        return closeButton
    }()
    
    func showInfoPopup() {
        
        self.view.addSubview(snapbar)
        setupViewConstraint(infoView: snapbar)
        snapbar.addSubview(closeButtonSnapbar)
        snapbar.addSubview(imageForSnapbar)
        snapbar.addSubview(labelForSnapbar)
        snapbar.addSubview(lowLabelForSnapbar)
        setupCloseButtonConstraint()
        setupLabelConstraint()
        setupLowLabelConstraint()
        setupImageConstraint()
        let tapToClose = UITapGestureRecognizer(target: self, action: #selector(closeSnapbar))
        closeButtonSnapbar.addGestureRecognizer(tapToClose)
        
        let tapToShowDetail = UITapGestureRecognizer(target: self, action: #selector(showDetailInfo(_:)))
        snapbar.addGestureRecognizer(tapToShowDetail)
    }
    
    @objc func closeSnapbar() {
        Session.shared.isNewUpdate = false
        if let popup = self.view.viewWithTag(99) {
            popup.removeFromSuperview()
        }
    }
    
    @objc func showDetailInfo(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.4, animations: { [weak self] in
            self?.snapbar.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { [weak self] (_) in
            self?.snapbar.transform = .identity
            self?.closeSnapbar()
            let url = URL(string: Util.landingURL)!
            UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]))
        }
    }
    
    private func setupViewConstraint(infoView: UIView) {
        infoView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        infoView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        infoView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        infoView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    fileprivate func setupLabelConstraint() {
        labelForSnapbar.topAnchor.constraint(equalTo: snapbar.topAnchor, constant: 15).isActive = true
        labelForSnapbar.leadingAnchor.constraint(equalTo: snapbar.leadingAnchor, constant: 15).isActive = true
        labelForSnapbar.trailingAnchor.constraint(equalTo: imageForSnapbar.leadingAnchor, constant: 0).isActive = true
    }
    fileprivate func setupLowLabelConstraint() {
        lowLabelForSnapbar.topAnchor.constraint(equalTo: labelForSnapbar.bottomAnchor, constant: 5).isActive = true
        lowLabelForSnapbar.leadingAnchor.constraint(equalTo: snapbar.leadingAnchor, constant: 15).isActive = true
        lowLabelForSnapbar.trailingAnchor.constraint(equalTo: imageForSnapbar.leadingAnchor, constant: 0).isActive = true
        lowLabelForSnapbar.bottomAnchor.constraint(equalTo: snapbar.bottomAnchor, constant: -10).isActive = true
    }

    fileprivate func setupImageConstraint() {
        imageForSnapbar.topAnchor.constraint(equalTo: snapbar.topAnchor, constant: 5).isActive = true
        imageForSnapbar.trailingAnchor.constraint(equalTo: snapbar.trailingAnchor, constant: -5).isActive = true
        imageForSnapbar.widthAnchor.constraint(equalTo: imageForSnapbar.heightAnchor).isActive = true
        imageForSnapbar.bottomAnchor.constraint(equalTo: snapbar.bottomAnchor, constant: -5).isActive = true
    }
    
    fileprivate func setupCloseButtonConstraint() {
        closeButtonSnapbar.translatesAutoresizingMaskIntoConstraints = false
        closeButtonSnapbar.topAnchor.constraint(equalTo: snapbar.topAnchor, constant: 10).isActive = true
        closeButtonSnapbar.trailingAnchor.constraint(equalTo: snapbar.trailingAnchor, constant: -10).isActive = true
    }
    
}
// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
   return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}

