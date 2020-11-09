//
//  RecipientDataTableCell.swift
//  Backit
//
//  Created by Виталий Скриганюк on 28.06.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class RecipientDataTableCell: UITableViewCell {
    
    // Containers View's
    private var containerView = UIView()
    
    // Content View's
    
    var textField = AnimatableTextFieldView()
    var hintLable = UILabel()
    
    var didRouteBack: (() -> Void)?
    var didTextEnter: ((RecipientData) -> Void)?
    var textIsEditing: ((RecipientData) -> Void)?
    
    private var bag = DisposeBag()
    private var isTextEditing: Bool = false
    private var type: RecipientData!
    private var purseType: PurseType!
    private var isButton: Bool = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupSubviws()
        setupConstraints()
        binding()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    

    private func setupSubviws() {
        containerView.addSubview(textField)
        containerView.addSubview(hintLable)

        textField.backgroundColor = .white
        
        hintLable.font = .medium10
        hintLable.textColor = .systemRed
        hintLable.numberOfLines = 0
        
        self.addSubview(containerView)
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3) {
            self.textField.setBottomBorder(withColor: .montreal)
        }
    }
    
    private func binding() {
        textField.didTextEnter.subscribe(onNext: {[weak self] data in
            guard let self = self else { return }
            self.didTextEnter?(data)
            if data.value == "" {
                self.hideHint()
            }
        }).disposed(by: self.bag)
        
        textField.textIsEditing.subscribe(onNext: {[weak self] data in
            guard let self = self else { return }
            self.textIsEditing?(data)
            self.hideHint()
        }).disposed(by: self.bag)

        textField.didRoute.subscribe(onNext: { [weak self] in
            self?.didRouteBack?()
        })
    }
    
    @objc func hideKeyboard() {
        self.textField.endEditing(true)
    }
    
    @objc func changed() {
        self.textField.endEditing(true)
        isTextEditing = false
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(6)
        }
        textField.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(30)
            make.left.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(16)
        }
        hintLable.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(10)
            make.left.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
        
    }
    
    public func showHint() {
        animate {
            self.hintLable.isHidden = false
        }
    }
    public func hideHint() {
        animate {
            self.hintLable.isHidden = true
        }
    }
    
    private func animate(action: @escaping () -> Void) {
        self.view.layoutSubviews()
        UIView.animate(withDuration: 0.5, animations: action)
    }
    
    public func setupCell(data: RecipientDataCell) {
    
        hintLable.isHidden = !data.isHintNeed
        textField.setUp(data: data)
        hintLable.text = data.hint
        self.type = data.recipient
        self.purseType = data.purseType
        
    }
}

struct RecipientData {
    
    var value: String = ""
    var type: DataType
    
    enum DataType: String {
        case account = "Account"
        case exp_month = "exp_month"
        case exp_year = "exp_year"
        case first_name = "first_Name"
        case last_name = "last_Name"
        case birth = "birth"
        case address = "address"
        case cardHolder_name = "cardHolder_Name"
        case country = "country"
    }
}
