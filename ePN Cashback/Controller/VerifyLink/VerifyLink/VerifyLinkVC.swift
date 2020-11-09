//
//  VerifyLinkVC.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 22/03/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

class VerifyLinkVC: UIViewController {

    var viewModel: VerifyLinkModelType!
    
    @IBOutlet weak var inputContainerView: UIView!
    @IBOutlet weak var linkTextView: PlaceholderTextView!
    @IBOutlet weak var checkButton: EPNButton!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var pasteButtonContainerView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMainView()
        checkButton.buttonSize = .large2
        ///Send event to analytic about open VerifyLink
        PriceDynamicsAnalytics.verifyLinkOpen()
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setPasteButtonEnable(isEnable: !(UIPasteboard.general.string?.isEmpty ?? true))
        setUpNavigationBar()
    }
    
    @objc func appDidBecomeActive() {
        setPasteButtonEnable(isEnable: !(UIPasteboard.general.string?.isEmpty ?? true))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        linkTextView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func setUpNavigationBar() {
        title = viewModel.headTitle
        navigationController?.navigationBar.barTintColor = .zurich
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.sydney , NSAttributedString.Key.font : UIFont.semibold17]
        
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "back")!.withRenderingMode(.alwaysOriginal), for: .normal)
        backButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.largeTitleDisplayMode = .never
    }
    
    @objc func backButtonTapped() {
        viewModel.goOnBack()
    }
    
    func setUpMainView() {
        self.view.backgroundColor = .zurich
        textLabel.font = .medium15
        textLabel.textColor = .london
        textLabel.numberOfLines = 0
        textLabel.text = viewModel.infoText

        inputContainerView.cornerRadius = 5
        inputContainerView.backgroundColor = .paris
        
        linkTextView.delegate = self
        linkTextView.keyboardType = .default
        linkTextView.font = .medium15
        linkTextView.textColor = .sydney
        linkTextView.autocorrectionType = .no
        linkTextView.placeholder = viewModel.getPlaceholderText
        linkTextView.placeholderColor = .minsk
        
        checkButton.style = .disabled
        checkButton.text = viewModel.buttonText
        checkButton.handler = { [weak self] (button) in
            self?.setCheckButtonEnable(isEnable: false)
            PriceDynamicsAnalytics.checkClicked()
            self?.viewModel.setLink(urlLink: self?.linkTextView.text)
            self?.viewModel.verifyTheLink(completion: { [weak self] in
                OperationQueue.main.addOperation { [weak self] in
                    self?.setCheckButtonEnable(isEnable: true)
                    self?.viewModel.goOnResultOfVerifyLink()
                }
                }, failure: { [weak self] (failureMessage) in
                    print("The Error message, which should been arrived for user \(failureMessage)")
                    OperationQueue.main.addOperation { [weak self] in
                        self?.setCheckButtonEnable(isEnable: true)
                        guard let self = self else { return }
                        if failureMessage == 422001 || failureMessage == 404002  {
                            self.viewModel.goOnIncorrectLinkResult()
                        } else {
                            Alert.showErrorAlert(by: failureMessage, on: self)
                        }
                    }
            })
        }
    }
    
    fileprivate func setCheckButtonEnable(isEnable: Bool) {
        self.checkButton.isEnable = isEnable
        self.checkButton.alpha = isEnable ? 1 : 0.6
    }
    
    
    @IBAction func clearTextFieldButtonClicked(_ sender: Any) {
        linkTextView.text = ""
        invalidateCheckButtonStyle()
    }
    
    @IBAction func pasteTextButtonClicked(_ sender: Any) {
        linkTextView.text = UIPasteboard.general.string
        invalidateCheckButtonStyle()
    }
    
    private func setPasteButtonEnable(isEnable: Bool) {
        self.pasteButtonContainerView.isUserInteractionEnabled = isEnable
        self.pasteButtonContainerView.alpha = isEnable ? 1 : 0.4
    }
    
}

extension VerifyLinkVC: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        invalidateCheckButtonStyle()
    }
    
    private func invalidateCheckButtonStyle() {
        if let currentLink = linkTextView.text , currentLink.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false  {
            checkButton.style = .primary
        } else {
            checkButton.style = .disabled
        }
    }
    
}
