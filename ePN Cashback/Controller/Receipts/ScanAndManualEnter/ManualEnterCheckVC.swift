//
//  ManualEnterCheckVC.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 18/04/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

class ManualEnterCheckVC: UIViewController {

    @IBOutlet weak var enterDateTime: EPNCustomInputView!
    @IBOutlet weak var enterCost: EPNCustomInputView!
    @IBOutlet weak var enterFN: EPNCustomInputView!
    @IBOutlet weak var enterFD: EPNCustomInputView!
    @IBOutlet weak var enterFP: EPNCustomInputView!
    @IBOutlet weak var sendButton: EPNButton!
    @IBOutlet weak var hintLinkLabel: UILabel!
    @IBOutlet weak var dashedView: UIView!
    var viewModel: ManualEnterCheckModelType!
    
    private var isFirstLayout = true
    private let hintIdentifier = "HintCheckOfflineCBVC"
    private var isKeyboardVisible = false
    private let constantConstraint = CGFloat(25)
    private var keyboardHeight: CGFloat = 0
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        setUpNavigationBar()
        setupMain()
    }
    
    override func viewDidLayoutSubviews() {
        if isFirstLayout {
            isFirstLayout = false
            drawDashedLine()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func drawDashedLine() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.minsk.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [4, 4]

        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 0, y: 0), CGPoint(x: dashedView.frame.size.width, y: 0)])
        shapeLayer.path = path
        dashedView.layer.addSublayer(shapeLayer)
    }

    func setUpNavigationBar() {
        navigationController?.navigationBar.isHidden = false
        title = viewModel.title
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"back")!.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(closeButtonTapped))
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = .zurich
    }
    
    //TODO: change these shit later on the best decision
    
    func setupMain() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(showHint))
        hintLinkLabel.text = NSLocalizedString("How to find data in a check?", comment: "")
        hintLinkLabel.font = .semibold13
        hintLinkLabel.textColor = .sydney
        hintLinkLabel.isUserInteractionEnabled = true
        hintLinkLabel.addGestureRecognizer(tap)
        
        sendButton.style = .primary
        sendButton.text = viewModel.buttonText
        enterDateTime.type = .datepicker
        enterCost.type = .cost
        enterFN.type = .numbers
        enterFD.type = .numbers
        enterFP.type = .numbers
        
        enterDateTime.tag = 1
        enterCost.tag = 2
        enterFN.tag = 3
        enterFD.tag = 4
        enterFP.tag = 5
        
        enterDateTime.delegate = self
        enterCost.delegate = self
        enterFN.delegate = self
        enterFD.delegate = self
        enterFP.delegate = self
        
        setAccessoryViewFor(textField: enterDateTime)
        setAccessoryViewFor(textField: enterCost)
        setAccessoryViewFor(textField: enterFN)
        setAccessoryViewFor(textField: enterFD)
        setAccessoryViewFor(textField: enterFP)
        
        enterDateTime.placeholder = viewModel.dateTimePlaceholderText
        enterCost.placeholder = viewModel.costPlaceholderText
        enterFN.placeholder = viewModel.fnPlaceholderText
        enterFD.placeholder = viewModel.fdPlaceholderText
        enterFP.placeholder = viewModel.fpPlaceholderText
        
        enterDateTime.hintText = viewModel.dateTimeHintText
        enterCost.hintText = viewModel.costHintText
        enterFN.hintText = viewModel.fnHintText
        enterFD.hintText = viewModel.fdHintText
        enterFP.hintText = viewModel.fpHintText
        
        enterDateTime.hintWillAppear = { [weak self] in
            self?.checkingConstraint(true)
        }
        
        enterCost.hintWillAppear = {  [weak self] in
            self?.checkingConstraint(true)
        }
        
        enterFN.hintWillAppear = { [weak self] in
            self?.checkingConstraint(true)
        }
        
        enterFD.hintWillAppear = { [weak self] in
            self?.checkingConstraint(true)
        }
        
        enterFP.hintWillAppear = { [weak self] in
            self?.checkingConstraint(true)
        }
        
        enterDateTime.hintWillDisappear = { [weak self] in
            self?.checkingConstraint(false)
        }
        
        enterCost.hintWillDisappear = { [weak self] in
            self?.checkingConstraint(false)
        }
        
        enterFN.hintWillDisappear = { [weak self] in
            self?.checkingConstraint(false)
        }
        
        enterFD.hintWillDisappear = { [weak self] in
            self?.checkingConstraint(false)
        }
        
        enterFP.hintWillDisappear = { [weak self] in
            self?.checkingConstraint(false)
        }
        
        sendButton.handler = { [weak self] (button) in
            guard let strongSelf = self else { return }
            let dateTime = strongSelf.enterDateTime.text ?? ""
            let cost = strongSelf.enterCost.text?.replacingOccurrences(of: ",", with: ".") ?? ""
            let fn = strongSelf.enterFN.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let fd = strongSelf.enterFD.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let fp = strongSelf.enterFP.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            
            if !(dateTime.isEmpty || cost.isEmpty || fn.isEmpty || fd.isEmpty || fp.isEmpty) {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy h:mm a"
                let myDate = dateFormatter.date(from: dateTime)!
                
                dateFormatter.dateFormat = "yyyyMMdd'T'HH:mm:ss"
                var somedateString = dateFormatter.string(from: myDate).replacingOccurrences(of: ":", with: "")
                somedateString = somedateString.replacingOccurrences(of: " ПП", with: "")
                somedateString = somedateString.replacingOccurrences(of: " ДП", with: "")
                
                let stringResultOfCheck = "t=\(somedateString)&s=\(cost)&fn=\(fn)&i=\(fd)&fp=\(fp)&n=1"
                print("The result is \(stringResultOfCheck)")
                strongSelf.viewModel.goOnClose(qrString: stringResultOfCheck)
            } else {
                strongSelf.view.endEditing(true)
                strongSelf.enterDateTime.checkTextField()
                strongSelf.enterCost.checkTextField()
                strongSelf.enterFN.checkTextField()
                strongSelf.enterFD.checkTextField()
                strongSelf.enterFP.checkTextField()
            }
        }
        updateSendButtonEnableState()
    }
    
    @objc func showHint() {
        viewModel.goOnHint()
    }
    
    func checkingConstraint(_ isIncrease: Bool) {
        let bottomPositionScrollView = scrollView.frame.maxY
        let topPositionOfKeyboard = self.view.frame.height - keyboardHeight
        if isIncrease && bottomPositionScrollView + 23 > topPositionOfKeyboard {
            scrollView.contentInset.bottom += 23
        } else if !isIncrease && bottomPositionScrollView > topPositionOfKeyboard {
            scrollView.contentInset.bottom -= 23
        }
    }
    
    @objc func closeButtonTapped() {
        viewModel.goOnScan()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    @objc func keyboardWillAppear(_ notification: NSNotification) {
        guard let userinfo = notification.userInfo,
        let duration = userinfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
        let _ = userinfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let bottomConstraint = self.view.frame.height - scrollView.frame.maxY
        guard let userInfo = notification.userInfo, let frame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        keyboardHeight = frame.height
        UIView.animate(withDuration: duration, animations: { [unowned self] in
            let padding = (frame.height + 44) - bottomConstraint
            if padding > 0 && !self.isKeyboardVisible {
                self.scrollView.contentInset.bottom += padding
                self.isKeyboardVisible = true
            }
        })

    }

    @objc func keyboardWillHide(_ notification: NSNotification) {
        isKeyboardVisible = false
        guard let userinfo = notification.userInfo,
            let duration = userinfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
            let _ = userinfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        keyboardHeight = 0
        UIView.animate(withDuration: duration) { [unowned self] in
            self.scrollView.contentInset = UIEdgeInsets.zero
        }
    }
    
    private func updateSendButtonEnableState() {
        let isEnable = enterDateTime.text?.count ?? 0 > 0 && enterCost.text?.count ?? 0 > 0 && enterFN.text?.count ?? 0 > 0 && enterFD.text?.count ?? 0 > 0 && enterFP.text?.count ?? 0 > 0
        sendButton.isEnable = isEnable
        sendButton.alpha = isEnable ? 1.0 : 0.5
    }
    
    func setAccessoryViewFor(textField : EPNCustomInputView) {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        // Adds the buttons
        
        // Add previousButton
        let prevButton = UIBarButtonItem(title: "<", style: .plain, target: self, action: #selector(previousPressed(sender:)))
        prevButton.tag = textField.tag
        if getPreviousResponderFor(tag: textField.tag) == nil {
            prevButton.isEnabled = false
        }
        
        // Add nextButton
        let nextButton = UIBarButtonItem(title: ">", style: .plain, target: self, action: #selector(nextPressed(sender:)))
        nextButton.tag = textField.tag
        if getNextResponderFor(tag: textField.tag) == nil {
            nextButton.title = "Done"
        }
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([prevButton,spaceButton,nextButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.getTextField().inputAccessoryView = toolBar
    }
    
    @objc func nextPressed(sender : UIBarButtonItem) {
        if let nextResponder = getNextResponderFor(tag: sender.tag) {
            nextResponder.firstResponder()
        } else {
            self.view.endEditing(true)
        }
        updateSendButtonEnableState()
        
    }
    
    @objc func previousPressed(sender : UIBarButtonItem) {
        if let previousResponder = getPreviousResponderFor(tag : sender.tag)  {
            previousResponder.firstResponder()
        }
    }
    
    func getNextResponderFor(tag : Int) -> EPNCustomInputView? {
        return self.view.viewWithTag(tag + 1) as? EPNCustomInputView
    }
    
    func getPreviousResponderFor(tag : Int) -> EPNCustomInputView? {
        return self.view.viewWithTag(tag - 1) as? EPNCustomInputView
    }
}

extension ManualEnterCheckVC: EPNCustomInputViewDelegate {
    
    func textEditing() {
        updateSendButtonEnableState()
    }
    
}
