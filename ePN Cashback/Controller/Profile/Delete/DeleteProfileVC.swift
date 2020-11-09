//
//  DeleteProfileVC.swift
//  Backit
//
//  Created by Ivan Nikitin on 10/03/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import UIKit
import XCoordinator
import TransitionButton

class DeleteProfileVC: UIViewController {

    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var textInfoLabel: UILabel!
    @IBOutlet weak var underLineView: UIView!
    @IBOutlet weak var nextButton: TransitionButton!
    @IBOutlet weak var warningImageView: UIImageView!
    @IBOutlet weak var topSeparatorView: UIView!
    
    
    var viewModel: DeleteProfileViewModel!
    let confirmCode = "08040116"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        initUIView()
    }
    
    private func setupNavigation() {
        title = NSLocalizedString(NSLocalizedString("delete_profile", comment: ""), comment: "")
        navigationController?.navigationBar.barTintColor = .zurich
        navigationController?.navigationBar.isTranslucent = false
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named:"back")!.withRenderingMode(.alwaysOriginal), for: .normal)
        backButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    @objc func backButtonTapped() {
        viewModel.goOnBack()
    }
    
    func bindViewModel(viewModel: DeleteProfileViewModel) {
        self.viewModel = viewModel
    }
    
    private func initUIView() {
        topSeparatorView.backgroundColor = .montreal
        codeTextField.placeholder = NSLocalizedString("Control line", comment: "")
        textInfoLabel.font = .medium13
        textInfoLabel.textColor = .london
        let descriptionText = NSLocalizedString("Enter the control line 08040116 to delete your account", comment: "")
        let attributedText = NSMutableAttributedString(string: descriptionText+" "+confirmCode)
        attributedText.addAttributes([NSAttributedString.Key.font: UIFont.medium13], range: NSRange(location: 0, length: descriptionText.count))
        attributedText.addAttributes([NSAttributedString.Key.font: UIFont.semibold13], range: NSRange(location: descriptionText.count+1, length: confirmCode.count))
        textInfoLabel.attributedText = attributedText
        nextButton.setupButtonStyle(with: .black)
        nextButton.setTitle(NSLocalizedString("Delete account", comment: ""), for: .normal)
        underLineView.backgroundColor = .montreal
        codeTextField.becomeFirstResponder()
    }
    
    @IBAction func continueTapped(_ sender: Any) {
        if codeTextField.text != "08040116" {
            view.endEditing(true)
            Alert.showErrorToast(by: NSLocalizedString("Wrong confirmation code", comment: ""))
            self.underLineView.backgroundColor = .prague
            self.warningImageView.isHidden = false
            return
        }
        nextButton.startAnimation()
        self.view.endEditing(true)
        viewModel.deleteAccount(secretCode: codeTextField.text ?? "") { [weak self] (errorCode) in
            self?.nextButton.stopAnimation(animationStyle: .shake, revertAfterDelay: 0.3, completion: nil)
            Alert.showErrorToast(by: errorCode)
        }
    }
    
    @IBAction func textFieldBeginEditing(_ sender: Any) {
        self.warningImageView.isHidden = true
        self.underLineView.backgroundColor = .vilnius
    }
    
    @IBAction func textFieldEndEditing(_ sender: Any) {
        self.underLineView.backgroundColor = .montreal
    }
    
}
