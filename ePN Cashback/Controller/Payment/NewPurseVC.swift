//
//  NewPurseVC.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 30/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit
import InputMask
import TransitionButton

class NewPurseVC: UIViewController {

    @IBOutlet weak var latinWarningMessageLabel: UILabel!
    private var cardNumberListener: MaskedTextFieldDelegate!
    private var validityListener: MaskedTextFieldDelegate!
    var viewModel: NewPurseProtocol!
    private var isFirstLayoutCall = true
    private var accessoryView: UIView!
    @IBOutlet weak var secondStepLabel: UILabel!
    //Card fields
    @IBOutlet weak var cardContainerView: UIView!
    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var validityLabel: UILabel!
    @IBOutlet weak var validityTextField: UITextField!
    @IBOutlet weak var cardHolderLabel: UILabel!
    @IBOutlet weak var cardHolderTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardNumberListener = MaskedTextFieldDelegate()
        validityListener = MaskedTextFieldDelegate()
        setupNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        if isFirstLayoutCall {
            commonSetup()
            setupViewForCardType()
            isFirstLayoutCall = false
        }
    }
    
    private func setupNavigationBar() {
        title = viewModel.title
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .zurich
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.sydney , NSAttributedString.Key.font : UIFont.semibold17]
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(backButtonClicked))
    }
    
    @objc func backButtonClicked() {
        viewModel.pop()
    }
    
    private func commonSetup() {
        self.accessoryView = TransitionButton(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 45))
        self.accessoryView.backgroundColor = .sydney
        (self.accessoryView as! UIButton).setTitle(viewModel.addText, for: .normal)
        (self.accessoryView as! UIButton).addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)
        (self.accessoryView as! UIButton).titleLabel?.font = .semibold17
        (self.accessoryView as! UIButton).titleLabel?.textColor = .zurich
        (self.accessoryView as! UIButton).isEnabled = false
        (self.accessoryView as! UIButton).alpha = 0.6
        cardNumberTextField.inputAccessoryView = self.accessoryView
        cardHolderTextField.inputAccessoryView = self.accessoryView
        validityTextField.inputAccessoryView = self.accessoryView
        self.secondStepLabel.font = .bold17
        self.secondStepLabel.textColor = .sydney
        self.secondStepLabel.text = "2. \(viewModel.enterTheDataText)"
        view.backgroundColor = .zurich
        latinWarningMessageLabel.font = .medium15
        latinWarningMessageLabel.textColor = .prague
        latinWarningMessageLabel.text = viewModel.onlyLatinLettersWarningText
        cardNumberTextField.becomeFirstResponder()
        cardContainerView.cornerRadius = CommonStyle.cornerRadius
        cardContainerView.borderWidth = CommonStyle.borderWidth
        cardContainerView.borderColor = .montreal
    }
    
    private func setupViewForCardType() {
        cardContainerView.isHidden = false
        cardNumberLabel.font = .medium15
        cardNumberLabel.textColor = .sydney
        cardNumberLabel.text = viewModel.cardNumberText
        cardNumberTextField.font = .semibold17
        cardNumberTextField.textColor = .sydney
        cardHolderLabel.font = .medium15
        cardHolderLabel.textColor = .sydney
        cardHolderTextField.font = .medium15
        cardHolderTextField.textColor = .sydney
        validityLabel.font = .medium15
        validityLabel.textColor = .sydney
        validityTextField.font = .medium15
        validityTextField.textColor = .sydney
        validityLabel.text = viewModel.validPeriodText
        cardHolderLabel.text = viewModel.cardOwnerText
        cardNumberListener.affinityCalculationStrategy = .prefix
        cardNumberListener.affineFormats = [viewModel.getMaskAndPrefix().mask]
        cardNumberTextField.placeholder = viewModel.getMaskAndPrefix().placeholder
        cardNumberListener.delegate = self
        cardNumberTextField.delegate = cardNumberListener
        validityListener.affinityCalculationStrategy = .prefix
        validityListener.affineFormats = ["[00]{/}[00]"]
        validityListener.delegate = self
        validityTextField.delegate = validityListener
    }
    
    @objc func addButtonClicked() {
        (self.accessoryView as! TransitionButton).startAnimation()
        viewModel.addButtonClicked { [weak self] in
            (self?.accessoryView as! TransitionButton).stopAnimation(animationStyle: .normal, revertAfterDelay: 0.0, completion: nil)
        }
    }
    
    @IBAction func cardHolderTextFieldValueChanged(_ sender: Any) {
        if (cardHolderTextField.text != nil && cardHolderTextField.text!.count > 0 && !(cardHolderTextField.text!.first! >= "a" && cardHolderTextField.text!.first! <= "z") && !(cardHolderTextField.text!.first! >= "A" && cardHolderTextField.text!.first! <= "Z")) {
            self.latinWarningMessageLabel.isHidden = false
            self.cardHolderLabel.textColor = .prague
            return
        }
        self.latinWarningMessageLabel.isHidden = true
        self.cardHolderLabel.textColor = .sydney
        viewModel.setCardHolderName(holderName: (cardHolderTextField.text?.isEmpty ?? true) ? nil : cardHolderTextField.text)
        updateAddButtonState()
    }
    
    private func updateAddButtonState() {
        let isButtonEnabled = viewModel.addButtonEnabled()
        (self.accessoryView as! UIButton).isEnabled = isButtonEnabled
        (self.accessoryView as! UIButton).alpha = (isButtonEnabled) ? 1 : 0.6
    }
}

extension NewPurseVC: MaskedTextFieldDelegateListener {
    open func textField( _ textField: UITextField, didFillMandatoryCharacters complete: Bool, didExtractValue value: String) {
        if textField == cardNumberTextField {
            viewModel.setCardNumber(number: (complete) ? value : nil)
        } else if textField == validityTextField {
            viewModel.setCardExpiredDate(expiredDate: (complete) ? value : nil)
        }
        updateAddButtonState()
    }
}
