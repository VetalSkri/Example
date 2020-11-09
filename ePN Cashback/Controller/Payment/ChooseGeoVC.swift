//
//  ChooseCountryVC.swift
//  Backit
//
//  Created by Виталий Скриганюк on 25.06.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import ProgressHUD

class ChooseGeoVC: UIViewController {
    
    // Containers View's
    private let containerView = UIView()
    private let businesView = UIView()
    private let infoView = UIView()
    private let emptyDataView = UIView()
    
    // Content View's
    private let searchTextField = UITextField()
    private let tableView = UITableView()
    private let emptyDataImageView = UIImageView(image: UIImage(named: "sourceResponse"))
    private let emptyDataLabel = UILabel()
    private let refreshControl = UIRefreshControl()
    
    private let bag = DisposeBag()
    
    var viewModel: ChooseCountryType! = nil
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        
        ProgressHUD.show()
        
        setupNavigationBar()
        setupSubviews()
        setupConstraints()
        setupScrollViewPullToRefresh()
        tableView.setupStyle()
        viewModel.loadData()
        binding()
        view.layoutIfNeeded()
        searchTextField.setBottomBorder(withColor: .montreal)
        hideKeyboardScroll(table: tableView)
        
    }
    
    deinit {
        unsubscribeNotificationCenter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (self.navigationController as! PaymentsNavigationController).isHideBottomView(status: true)
    }
    
    private func setupNavigationBar() {
        
        navigationController?.navigationBar.shadowColor = .red
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .zurich
        navigationController?.navigationBar.shadowImage = nil
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.sydney , NSAttributedString.Key.font : UIFont.semibold15]
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(backButtonClicked))
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func unsubscribeNotificationCenter() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func backButtonClicked() {
        viewModel.pop()
    }
    @objc func refresh(sender:AnyObject) {
        viewModel.loadData()
    }
    
    @objc func keyboardWillAppear(_ notification: NSNotification) {
        guard let userinfo = notification.userInfo,
            let duration = userinfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
            let finalRect = userinfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: duration) {
            self.businesView.snp.makeConstraints { make in
                make.top.equalTo(self.infoView.snp.bottom).offset(16)
                make.left.equalToSuperview()
                make.right.equalToSuperview()
                make.bottom.equalToSuperview().inset(finalRect.height)
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        guard let userinfo = notification.userInfo,
            let duration = userinfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
            let finalRect = userinfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: duration) {
            self.businesView.snp.remakeConstraints { make in
                make.left.equalToSuperview()
                make.right.equalToSuperview()
                make.bottom.equalToSuperview()
                make.top.equalTo(self.infoView.snp.bottom).offset(16)
            }
        }
    }

    
    private func setupScrollViewPullToRefresh() {
    refreshControl.tintColor = .sydney
    refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        self.tableView.addSubview(refreshControl)
    }
    
    private func setupSubviews() {
        containerView.addSubview(infoView)
        containerView.addSubview(businesView)
        
        infoView.addSubview(searchTextField)
        
        searchTextField.placeholder = viewModel.selectViewType.placeholder
        
        searchTextField.backgroundColor = .white
        searchTextField.addTarget(self, action: #selector(touched), for: .editingDidBegin)
        searchTextField.addTarget(self, action: #selector(changed), for: .editingDidEnd)
        
        title = viewModel.selectViewType.searchLable
        
        businesView.addSubview(tableView)
        businesView.addSubview(emptyDataView)
        
        emptyDataView.isHidden = true
        
        emptyDataView.addSubview(emptyDataImageView)
        emptyDataView.addSubview(emptyDataLabel)
        
        emptyDataImageView.contentMode = .scaleAspectFit
        
        emptyDataLabel.text = NSLocalizedString("Nothing was found", comment: "")
        emptyDataLabel.textAlignment = .center
        
        tableView.register(CountryTableCell.self, forCellReuseIdentifier: "CountryTableCell")
        
        self.view.addSubview(containerView)
    }
    
    @objc func changed() {
           self.searchTextField.endEditing(true)
        self.view.layoutIfNeeded()
           UIView.animate(withDuration: 0.3) {
               self.searchTextField.setBottomBorder(withColor: .montreal)
           }
       }
       
       @objc func touched() {
        self.view.layoutIfNeeded()
           UIView.animate(withDuration: 0.3) {
               self.searchTextField.setBottomBorder(withColor: .vilnius)
           }
       }
       
    
    private func setupConstraints() {
        self.view.layoutIfNeeded()
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        infoView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.greaterThanOrEqualTo(0)
        }
        searchTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.height.equalTo(30)
            make.left.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(5)
        }
        businesView.snp.makeConstraints { make in
            make.top.equalTo(infoView.snp.bottom).offset(16)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        emptyDataView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(33)
            make.right.equalToSuperview().inset(33)
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        emptyDataImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        emptyDataLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyDataImageView.snp.bottom).offset(15)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func binding() {
    
        searchTextField.rx.text.subscribe(onNext: { next in
                self.viewModel.searchCountry(searchName: next ?? "")
        }).disposed(by: bag)
        
        viewModel.loading.subscribeOn(MainScheduler.instance).subscribe(onNext: { event in
                ProgressHUD.dismiss()
            self.refreshControl.endRefreshing()
        }).disposed(by: bag)
        
        viewModel.isEmptyResponse.subscribeOn(MainScheduler.instance).subscribe(onNext: { [weak self] event in
            self?.tableView.isHidden = event
            self?.emptyDataView.isHidden = !event
        }).disposed(by: bag)
        
        viewModel?.showAlert.subscribeOn(MainScheduler.instance).subscribe(onNext: {[weak self] in
            guard self != nil else { return }
            Alert.showErrorToast(by: ($0 as NSError).code)
            }).disposed(by: bag)        
        
        viewModel.country.bind(to: tableView.rx.items(cellIdentifier: "CountryTableCell", cellType: CountryTableCell.self)) { [self]row, geo, cell in
            cell.setupCell(data: geo, delegate: self)
        }.disposed(by: bag)
    }
}
extension ChooseGeoVC: CountryTableCellDelegate {
    func selected(geo:SearchGeoDataResponse) {
        viewModel.selected(geo: geo)
    }
}
