//
//  BottomPopupVC.swift
//  Backit
//
//  Created by Александр Кузьмин on 03/02/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import UIKit

protocol BottomPopupVCDelegate: class {
    func buttonClicked()
}

public struct BottomPopupData {
    var title: String
    var buttonTitle: String
    var imageName: String
}

class BottomPopupVC: UIViewController {
    
    weak var delegate: BottomPopupVCDelegate?
    private var mainTitle = ""
    private var buttonTitle = ""
    private var imageName = ""
    private var isShown = false
    
    //Blur shield
    @IBOutlet weak var blurShield: UIVisualEffectView!
    
    //Bottom container view
    @IBOutlet weak var bottomContainerView: UIView!
    @IBOutlet weak var mainTitleLabel: UILabel!
    
    //Button fields
    var button = EPNButton(style: .overlayOutline, size: .large1)
    
    //Image view
    @IBOutlet weak var imageView: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupConstraints()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !isShown {
            isShown = true
            showWithAnimate()
        }
    }
    
    func configureView(data: BottomPopupData) {
        self.mainTitle = data.title
        self.buttonTitle = data.buttonTitle
        self.imageName = data.imageName
    }
    
    private func setupSubviews() {
        bottomContainerView.addSubview(button)
        button.handler = { [weak self] button in
            self?.buttonClicked()
        }
    }
    
    private func setupConstraints() {
        button.snp.makeConstraints { (make) in
            make.top.equalTo(mainTitleLabel.snp.bottom).offset(40)
            make.right.equalToSuperview().inset(16)
            make.left.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(-600)
            make.height.equalTo(50)
        }
    }
    
    private func setupView() {
        bottomContainerView.backgroundColor = .sydney
        bottomContainerView.cornerRadius = CommonStyle.newCornerRadius
        bottomContainerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        mainTitleLabel.font = .bold17
        mainTitleLabel.textColor = .zurich
        mainTitleLabel.text = mainTitle
        
        button.text = buttonTitle
        
        imageView.image = UIImage(named: imageName)
        blurShield.alpha = 0.0
        
    }
    
    private func showWithAnimate() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.blurShield.alpha = 1.0
            self?.button.snp.remakeConstraints { (make) in
                make.top.equalTo(self!.mainTitleLabel.snp.bottom).offset(40)
                make.right.equalToSuperview().inset(16)
                make.left.equalToSuperview().inset(16)
                make.bottom.equalToSuperview().inset(40)
                make.height.equalTo(50)
            }
            self?.view.layoutIfNeeded()
        }
    }
    
    private func buttonClicked() {
        delegate?.buttonClicked()
        dismiss(animated: true, completion: nil)
    }
    
}
