//
//  AnimatableTextField.swift
//  Backit
//
//  Created by Виталий Скриганюк on 29.06.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import SnapKit
import UIKit
import InputMask
import RxSwift
import RxCocoa

class AnimatableTextFieldView: UIView {
    
    private var bag = DisposeBag()
    private var recipientData: RecipientDataCell!
    private var notificationlister = NotifyingMaskedTextFieldDelegate()
    
    private var textField = UITextField()
    private var datePicker = UIDatePicker()
    private var arrowImageView = UIImageView(image: UIImage(named: "defArrowRight"))
    
    private var isButton: Bool = false
    private var isEditing: Bool = false
    
    private let didTextEnterSubject = PublishSubject<RecipientData>()
    private let textIsEditingSubject = PublishSubject<RecipientData>()
    let didRouteSubject =
        PublishSubject<Void>()
    
    var didRouteBack: (() -> Void)!
    
    var didTextEnter: Observable<RecipientData> {
        return didTextEnterSubject.asObserver()
    }
    
    var textIsEditing: Observable<RecipientData> {
        return textIsEditingSubject.asObserver()
    }
    
    var didRoute: Observable<Void> {
        return didRouteSubject.asObserver()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        binding()
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupSubviews() {
        textField.backgroundColor = .white
        textField.delegate = self
        textField.keyboardType = .asciiCapable
        textField.autocapitalizationType = .allCharacters
        
        notificationlister.editingListener = self
        
        self.addSubview(textField)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !isEditing {
            self.textField.setBottomBorder(withColor: .montreal)
        }
    }

    private func setupConstraints() {
        textField.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        layoutSubviews()
    }
    
    private func addButtomStyle(status: Bool) {
        isButton = status
        if status {
            textField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(route)))
            textField.rightViewMode = .always
            textField.rightView = arrowImageView
        } else {
            textField.removeGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(route)))
            textField.rightView = nil
        }
    }
    
    @objc func route() {
        if isButton {
            didRouteSubject.onNext(())
        }
    }
    
    private func binding() {
        
        textField.rx.controlEvent(.editingDidBegin).subscribe(onNext: { [weak self] in
            UIView.animate(withDuration: 0.3) {
                self?.textField.setBottomBorder(withColor: .vilnius)
            }
            }).disposed(by: bag)

        textField.rx.controlEvent(.editingDidEnd).subscribe(onNext: { [weak self ] in
            guard let self = self else { return }
            
            UIView.animate(withDuration: 0.3) {
                self.textField.setBottomBorder(withColor: .montreal)
            }
            guard var text = self.textField.text, text != "" else { return }
            if text.last == " " {
                text.removeLast()
            }
            self.recipientData.recipient.value = text
            self.didTextEnterSubject.onNext(self.recipientData.recipient)
        }).disposed(by: bag)
        
        datePicker.rx.controlEvent(.allEvents).subscribe(onNext: {[weak self] data in
            self?.setDate()
        }).disposed(by: bag)
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        setDate()
    }
    
    private func setupTextFieldOptions() {
        textField.placeholder = recipientData.purseType?.getMaskAndPrefix().placeholder ?? recipientData.placeholder
        if recipientData.text != "check" {
            textField.text = recipientData.text            
        }
        
        switch recipientData.recipient.type {
        case .account: textField.keyboardType = .decimalPad
        case .exp_year:
            textField.keyboardType = .decimalPad
        case .birth:
            datePicker.datePickerMode = .date
            textField.inputView = datePicker
        case .cardHolder_name,.country,.address,.last_name, .first_name, .exp_month:
            break
        }
    }
    
    private func setDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        textField.text = dateFormatter.string(from: datePicker.date)
        
        guard let text = textField.text else { return }
        recipientData.recipient.value = text
        didTextEnterSubject.onNext(recipientData.recipient)
    }
    
    private func setTextEditingObserver() {
        textField.rx.controlEvent(.editingChanged).subscribe(onNext: { [weak self] in
            guard let self = self, let text = self.textField.text, text != "" else { return }
            self.recipientData.recipient.value = text
            self.textIsEditingSubject.onNext(self.recipientData.recipient)
            })
    }
    
    private func setListner(mask: String) {
        notificationlister.delegate = self
        notificationlister.affineFormats = [mask]
        notificationlister.affinityCalculationStrategy = .wholeString
        
        textField.delegate = notificationlister
    }
    
    func setUp(data: RecipientDataCell) {
        recipientData = data
        addButtomStyle(status: data.isButton)
        if let mask = data.mask ?? data.purseType?.getMaskAndPrefix().mask {
            setListner(mask: mask)
        } else {
            setTextEditingObserver()
        }
        setupTextFieldOptions()
    }
}

extension AnimatableTextFieldView: NotifyingMaskedTextFieldDelegateListener {
    func onEditingChanged(inTextField: UITextField) {
        guard let text = inTextField.text, text != "" else { return }
        if text.count == 20 {
            self.textField.text?.removeLast()
        }
        recipientData.recipient.value = text
        textIsEditingSubject.onNext(recipientData.recipient)
        
    }
}

extension AnimatableTextFieldView: UITextFieldDelegate {}

class NotifyingMaskedTextFieldDelegate: MaskedTextFieldDelegate {
    weak var editingListener: NotifyingMaskedTextFieldDelegateListener?
    
    override func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        defer {
            self.editingListener?.onEditingChanged(inTextField: textField)
        }
        return super.textField(textField, shouldChangeCharactersIn: range, replacementString: string)
    }
}

protocol NotifyingMaskedTextFieldDelegateListener: class {
    func onEditingChanged(inTextField: UITextField)
}
