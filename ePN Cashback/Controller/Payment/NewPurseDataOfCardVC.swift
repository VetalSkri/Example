//
//  NewPurseDataOfCardVC.swift
//  Backit
//
//  Created by Виталий Скриганюк on 27.06.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import ProgressHUD

class NewPurseDataOfCardVC: UIViewController {
    
    // Containers View's
    private let containerView = UIView()
    private let businesView = UIView()
    private let infoView = UIView()
    private let logoView = PurseLogoView()
    private weak var bottomView: BottomPaymentView?
    // Content View's
    private let tableView = UITableView()
    
    private let bag = DisposeBag()
    private var tap : UITapGestureRecognizer!
        
    var viewModel: NewPurseDataOfCardType? = nil
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        
        setBottomView()
        setupSubviews()
        setupConstraints()
        tableView.setupStyle()
        setupNavigationBar()
        binding()
        viewModel?.loadData()
    
        tap = UITapGestureRecognizer(target: self, action: #selector(touchedOutside(_:)))
        self.view.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    deinit {
        unsubscribeNotificationCenter()
    }
    
    private func unsubscribeNotificationCenter() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func touchedOutside(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillAppear(_ notification: NSNotification) {
        guard let userinfo = notification.userInfo,
            let duration = userinfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
            let finalRect = userinfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        self.view.layoutIfNeeded()
        tableView.isScrollEnabled = true
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: finalRect.height, right: 0)
                       
        guard let paymentsNav = (self.navigationController as? PaymentsNavigationController) else { return }
        paymentsNav.isKeyBoardHide(status: false, duration: duration, finalRect: finalRect)
    }

    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        guard let userinfo = notification.userInfo,
            let duration = userinfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
            let _ = userinfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        self.view.layoutIfNeeded()
        tableView.isScrollEnabled = false
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        guard let paymentsNav = (self.navigationController as? PaymentsNavigationController) else { return }
        paymentsNav.isKeyBoardHide(status: true, finalRect: nil)
    }
        
    private func setBottomView() {
        self.bottomView = (self.navigationController as! PaymentsNavigationController).bottomView
    }
    
    private func isHideBottomView(status: Bool) {
        (self.navigationController as! PaymentsNavigationController).isHideBottomView(status: status)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isHideBottomView(status: false)
        viewModel?.loadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.view.endEditing(true)
    }

    private func setupNavigationBar() {
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .zurich
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.sydney , NSAttributedString.Key.font : UIFont.semibold17]
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(backButtonClicked))
    }
    
    @objc func backButtonClicked() {
        viewModel?.pop()
    }
    @objc func refresh(sender:AnyObject) {
        viewModel?.loadData()
    }
    
    private func setupSubviews() {
        containerView.addSubview(businesView)
    
        infoView.addSubview(logoView)
        
        let item = UIBarButtonItem(customView: infoView)
        
        self.navigationItem.rightBarButtonItem = item
        self.view.layoutIfNeeded()
            
        businesView.addSubview(tableView)
        
        tableView.setupStyle()
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.register(RecipientDataTableCell.self, forCellReuseIdentifier: "RecipientDataTableCell")
        
        self.view.addSubview(containerView)
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        logoView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalTo(44)
            make.height.equalTo(24)
            make.bottom.equalToSuperview()
        }
        logoView.containerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        logoView.singleImageView.snp.makeConstraints { (make) in
            make.height.equalTo(20)
            make.width.equalTo(20)
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        logoView.visaImageView.snp.makeConstraints { (make) in
            make.top.equalTo(logoView.stackImageView.snp.bottom)
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
            make.left.equalToSuperview()
        }
        logoView.stackImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
//            make.right.equalToSuperview()
            make.left.equalToSuperview()
        }
        businesView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(69)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(4)
        }
    }
    
    private func binding() {
        viewModel?.loading.subscribeOn(MainScheduler.instance).subscribe(onNext: { event in
                ProgressHUD.dismiss()
        }).disposed(by: bag)
        
        viewModel?.showAlert.subscribeOn(MainScheduler.instance).subscribe(onNext: {[weak self] in
            guard self != nil else { return }
            Alert.showErrorToast(by: ($0 as NSError).code)
            }).disposed(by: bag)
        
        viewModel?.isLogoNeded.subscribeOn(MainScheduler.instance).subscribe(onNext: { [weak self] in
            self?.logoView.isHidden = $0
            }).disposed(by: bag)
        
        
        viewModel?.titleLabel.subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            self.title = text
        }).disposed(by: bag)
        
        viewModel?.recipentData.bind(to: tableView.rx.items(cellIdentifier: "RecipientDataTableCell", cellType: RecipientDataTableCell.self)) {[weak self] row, info ,cell in
             guard self != nil else { return }
            cell.setupCell(data: info)
            
            cell.didTextEnter = { [weak self] data in
                guard self != nil else { return }
                if self!.viewModel!.checkFields(value: data.value, type: data) {
                    cell.hideHint()
                } else {
                    cell.showHint()
                }
                self?.viewModel?.unableDisableButton()
            }
            
            cell.textIsEditing = { [weak self] data in
                guard self != nil else { return }
                self?.viewModel?.setFields(value: data.value, recipient: data)
                self?.viewModel?.unableDisableButton()
            }
        
            cell.didRouteBack = { [weak self] in
                self?.viewModel?.getCounty()
            }
            
        }.disposed(by: bag)
        
        viewModel?.singleLogo.subscribeOn(MainScheduler.instance).subscribe(onNext: { [weak self] in
//            self?.logoView.setup(type: .single, image: $0)
            switch $0 {
            case .wmz:
                self?.logoView.singleImageView.snp.remakeConstraints({ (make) in
                    make.right.equalToSuperview()
                    make.centerY.equalToSuperview()
                    make.height.equalTo(30)
                    make.width.equalTo(30)
                })
                
                self?.view.layoutIfNeeded()
            case .cardUrk, .cardpayUsd, .cardUrkV2:
                self?.logoView.singleImageView.snp.remakeConstraints({ (make) in
                        make.right.equalToSuperview()
                        make.centerY.equalToSuperview()
                        make.height.equalTo(40)
                        make.width.equalTo(53)
                    })
                self?.view.layoutIfNeeded()
            case .cardpay:
                self?.logoView.singleImageView.snp.remakeConstraints({ (make) in
                    make.right.equalToSuperview()
                    make.centerY.equalToSuperview()
                    make.height.equalTo(24)
                    make.width.equalTo(44)
                })
                self?.view.layoutIfNeeded()
            default:
                break
            }
            if $0 == PurseType.cardpay {
                self?.logoView.setup(type: .single, image: UIImage(named:"allCards"))
            } else {
                if $0 == PurseType.wmz {
                    self?.logoView.setup(type: .single, image: UIImage(named: "webMoneySmallNew"))
                } else {
                    self?.logoView.setup(type: .single, image: UIImage(named: LocalSymbolsAndAbbreviations.getPurseChooseLogo(forType: $0)))
                }
            }
        }).disposed(by: bag)
        
        viewModel?.bottomViewInfo.subscribeOn(MainScheduler.instance).subscribe(onNext: { [weak self] in
            guard let bottomView = self?.bottomView else { return }
            guard !$0.dismiss else {
                self?.isHideBottomView(status: true)
                return
            }
            bottomView.setupView(data: $0, delegate: self!)
        }).disposed(by: bag)
        
        viewModel?.isProgressOn.subscribeOn(MainScheduler.instance).subscribe(onNext: { [weak self] in
            guard let bottomView = self?.bottomView else { return }
            bottomView.progressAnimate(status: $0)
            
        }).disposed(by: bag)
        
        viewModel?.fieldsIsFull.subscribeOn(MainScheduler.instance).subscribe(onNext:{ [weak self ] in
            guard let bottomView = self?.bottomView else { return }
            bottomView.updateProgress(status: $0)
            }).disposed(by: bag)
    }
}

extension NewPurseDataOfCardVC: BottomPaymentViewDelegate {
    func forward() {
        (self.navigationController as! PaymentsNavigationController).isKeyBoardHide(status: true, finalRect: nil)
        self.view.endEditing(true)
        viewModel?.forward()
    }
}

