//
//  NewCommonPurseVC.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 06/08/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit
import InputMask
import TransitionButton

class NewCommonPurseVC: UIViewController {

    var viewModel: NewCommonPurseProtocol!
    private var purseNumberListener = MaskedTextFieldDelegate()
    private var accessoryView: UIView!
    private var isFirstLayoutCall: Bool = true
    
    @IBOutlet weak var purseContainerView: UIView!
    @IBOutlet weak var enterDataLabel: UILabel!
    @IBOutlet weak var purseNumberLabel: UILabel!
    @IBOutlet weak var prefixLabel: UILabel!
    @IBOutlet weak var purseNumberTextField: UITextField!
    @IBOutlet weak var purseLogoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        if isFirstLayoutCall {
            setupView()
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

    private func setupView() {
        setupKeyboardType()
        
        self.accessoryView = TransitionButton(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 45))
        self.accessoryView.backgroundColor = .sydney
        (self.accessoryView as! UIButton).setTitle(viewModel.addText, for: .normal)
        (self.accessoryView as! UIButton).addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)
        (self.accessoryView as! UIButton).titleLabel?.font = .semibold17
        (self.accessoryView as! UIButton).titleLabel?.textColor = .zurich
        (self.accessoryView as! UIButton).isEnabled = false
        (self.accessoryView as! UIButton).alpha = 0.6
        self.purseNumberTextField.inputAccessoryView = self.accessoryView
        
        view.backgroundColor = .zurich
        purseContainerView.cornerRadius = CommonStyle.cornerRadius
        purseContainerView.borderWidth = CommonStyle.borderWidth
        purseContainerView.borderColor = .montreal
        purseContainerView.backgroundColor = .zurich
        enterDataLabel.font = .bold17
        enterDataLabel.textColor = .sydney
        enterDataLabel.text = "2. \(viewModel.enterTheDataText)"
        purseNumberLabel.font = .medium15
        purseNumberLabel.textColor = .sydney
        prefixLabel.font = .medium15
        purseNumberLabel.text = NSLocalizedString("Wallet number", comment: "")
        prefixLabel.textColor = .sydney
        purseNumberTextField.font = .medium15
        purseNumberTextField.textColor = .sydney
        purseLogoImageView.image = UIImage(named: LocalSymbolsAndAbbreviations.getPurseChooseLogo(forType: viewModel.purseType))
        prefixLabel.text = viewModel.getMaskAndPrefix().prefix
        purseNumberTextField.placeholder = viewModel.getMaskAndPrefix().placeholder
        purseNumberListener.affinityCalculationStrategy = .wholeString
        purseNumberListener.affineFormats = [viewModel.getMaskAndPrefix().mask]
        purseNumberListener.delegate = self
        if !viewModel.getMaskAndPrefix().mask.isEmpty {
            purseNumberTextField.delegate = purseNumberListener
        }
        if viewModel.purseType == PurseType.epayments {
            purseNumberTextField.addTarget(self, action: #selector(purseTextDidChanged), for: .editingChanged)
        }
        purseNumberTextField.becomeFirstResponder()
    }
    
    private func setupKeyboardType() {
        switch viewModel.purseType! {
        case .beeline, .megafon, .tele2, .mts, .wmr, .wmz, .yandexMoney:
            purseNumberTextField.keyboardType = .numberPad
            break
        case .qiwi:
            purseNumberTextField.keyboardType = .phonePad
            break
        default:
            purseNumberTextField.keyboardType = .default
            break
        }
    }
    
    private func updateAddButtonState() {
        let isButtonEnabled = viewModel.addButtonEnabled()
        (self.accessoryView as! UIButton).isEnabled = isButtonEnabled
        (self.accessoryView as! UIButton).alpha = (isButtonEnabled) ? 1 : 0.6
    }
    
    @objc func backButtonClicked() {
        viewModel.pop()
    }
    
    @objc func addButtonClicked() {
        (self.accessoryView as! TransitionButton).startAnimation()
        viewModel.addButtonClicked { [weak self] in
            (self?.accessoryView as! TransitionButton).stopAnimation(animationStyle: .normal, revertAfterDelay: 0.0, completion: nil)
        }
    }
    
    @objc func purseTextDidChanged() {
        let text = purseNumberTextField.text ?? ""
        let enabled = (Util.checkStringIsEmail(string: text) || Util.checkStringIsPhone(string: text) || Util.checkStringIsEpaymentsId(string: text))
        viewModel.setPurseValue(value: text)
        (self.accessoryView as! UIButton).isEnabled = enabled
        (self.accessoryView as! UIButton).alpha = (enabled) ? 1 : 0.6
    }
}

extension NewCommonPurseVC: MaskedTextFieldDelegateListener {
    open func textField( _ textField: UITextField, didFillMandatoryCharacters complete: Bool, didExtractValue value: String) {
        self.viewModel.setPurseValue(value: (complete && !value.isEmpty) ? value : nil )
        updateAddButtonState()
    }
}
