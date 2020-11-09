//
//  PromoTableHeaderView.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 22/08/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

protocol PromoTableHeaderViewDelegate: AnyObject {
    func checkButtonWasClicked(withPromo: String)
}

class PromoTableHeaderView: UIView {

    weak var delegate: PromoTableHeaderViewDelegate?
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var promoInputView: UIView!
    @IBOutlet weak var promocodeTextField: UITextField!
    var checkButton = EPNButton(style: .disabled, size: .large1)
    @IBOutlet weak var promoNotFountLabel: UILabel!
    @IBOutlet weak var promoNotFoundTopConstraint: NSLayoutConstraint!  //default - 16
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        self.addSubview(checkButton)
    }
    
    func setupConstraints() {
        checkButton.snp.makeConstraints { (make) in
            make.top.equalTo(containerView.snp.bottom).offset(-23)
            make.left.equalToSuperview().inset(20)
            make.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
    
    func setupView(title: String?, placeholder: String?, checkButtonTitle: String?) {
        promoNotFountLabel.font = .medium15
        promoNotFountLabel.textColor = .zurich
        view.backgroundColor = .zurich
        containerView.backgroundColor = .calgary
        promocodeTextField.attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.minsk, NSAttributedString.Key.font : UIFont.semibold17])
        checkButton.text = checkButtonTitle
        
        checkButton.handler = {[weak self] button in
            self?.checkButtonClicked()
        }
        
        promoInputView.backgroundColor = .zurich
        promoInputView.cornerRadius = CommonStyle.cornerRadius
        promocodeTextField.font = .medium15
        promocodeTextField.textColor = .sydney
        promocodeTextField.tintColor = .sydney
        setupCheckButton()
    }
    
    private func checkButtonClicked() {
        delegate?.checkButtonWasClicked(withPromo: promocodeTextField.text ?? "")
    }
    
    private func setupCheckButton() {
        makeButtonEnabled(isEnable: !(promocodeTextField.text?.isEmpty ?? true))
    }
    
    func makeButtonEnabled(isEnable: Bool) {
            checkButton.style = isEnable ? .primary : .disabled
    }

    func setNotFountVisibility(isHidden: Bool, message: String) {
        promoNotFountLabel.text = (isHidden) ? "" : message
        promoNotFoundTopConstraint.constant = (isHidden) ? 0 : 16
    }
    
    @IBAction func promocodeTextEditing(_ sender: Any) {
        setupCheckButton()
    }
}
