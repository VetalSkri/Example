//
//  LocationViewController.swift
//  Backit
//
//  Created by Elina Batyrova on 13.08.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import ProgressHUD

class LocationViewController: UIViewController {
    
    // MARK: - Nested Types
    
    private enum Identifiers {
        static let locationCell = "LocationTableViewCell"
    }
    
    // MARK: - Instance Properties
    
    var viewModel: LocationViewModelProtocol!
    
    // MARK: -
    
    private let tableView = UITableView()
    private let searchTextField = UITextField()
    private let separatorView = UIView()
    
    private let emptyStateView = UIView()
    private let emptyStateContentHandler = UIView()
    private let emptyStateImageView = UIImageView(image: UIImage(named: "sourceResponse"))
    private let emptyStateTitleLabel = UILabel()
    
    private let bag = DisposeBag()
    
    // MARK: - Instance Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigationBar()
        self.setupView()
        self.setupConstraints()
        self.binding()
        self.viewModel.loadData()
        self.hideKeyboardScroll(table: tableView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        searchTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        ProgressHUD.dismiss()
        
        searchTextField.resignFirstResponder()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        tableView.separatorStyle = .none
        tableView.register(LocationTableViewCell.self, forCellReuseIdentifier: Identifiers.locationCell)
        
        searchTextField.placeholder = viewModel.searchTextFieldPlaceholder
        searchTextField.font = UIFont.medium15
        
        separatorView.backgroundColor = .vilnius
        
        emptyStateTitleLabel.text = viewModel.emptyStateViewTitle
        emptyStateTitleLabel.font = .semibold15
        emptyStateTitleLabel.textColor = .sydney
        
        emptyStateView.backgroundColor = .white
        emptyStateView.isHidden = true
        
        emptyStateContentHandler.addSubview(emptyStateImageView)
        emptyStateContentHandler.addSubview(emptyStateTitleLabel)
        
        emptyStateView.addSubview(emptyStateContentHandler)
        
        view.addSubview(tableView)
        view.addSubview(searchTextField)
        view.addSubview(separatorView)
        view.addSubview(emptyStateView)
    }
    
    private func setupConstraints() {
        searchTextField.snp.makeConstraints({ maker in
            maker.top.equalToSuperview().inset(32)
            maker.leading.equalToSuperview().inset(24)
            maker.trailing.equalToSuperview().inset(24)
        })
        
        separatorView.snp.makeConstraints({ maker in
            maker.top.equalTo(searchTextField.snp.bottom).inset(-8)
            maker.height.equalTo(1)
            maker.leading.equalTo(searchTextField.snp.leading)
            maker.trailing.equalToSuperview()
        })
        
        tableView.snp.makeConstraints({ maker in
            maker.top.equalTo(separatorView.snp.bottom).inset(-16)
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.bottom.equalToSuperview()
        })
        
        emptyStateView.snp.makeConstraints({ maker in
            maker.top.equalTo(separatorView.snp.bottom)
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.bottom.equalToSuperview()
        })
        
        emptyStateContentHandler.snp.makeConstraints({ maker in
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview()
        })
        
        emptyStateImageView.snp.makeConstraints({ maker in
            maker.top.equalToSuperview()
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.centerX.equalToSuperview()
        })
        
        emptyStateTitleLabel.snp.makeConstraints({ maker in
            maker.top.equalTo(emptyStateImageView.snp.bottom).inset(-24)
            maker.bottom.equalToSuperview()
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
        })
    }
    
    private func setupNavigationBar() {
        navigationItem.title = viewModel.title
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: viewModel.backButtonTitle, style: .plain, target: self, action: #selector(onBackButtonTouchUpInside(sender:)))
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.medium15], for: .normal)
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.medium15], for: .selected)
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.semibold15]
    }
    
    private func binding() {
        viewModel.isLoading.subscribeOn(MainScheduler.instance).subscribe(onNext: { isLoading in
            isLoading ? ProgressHUD.show() : ProgressHUD.dismiss()
        }).disposed(by: bag)
        
        viewModel.isEmptyData.subscribeOn(MainScheduler.instance).subscribe(onNext: { [weak self] isEmptyData in
            self?.emptyStateView.isHidden = !isEmptyData
        }).disposed(by: bag)
        
        viewModel.tableData.bind(to: tableView.rx.items(cellIdentifier: Identifiers.locationCell, cellType: LocationTableViewCell.self)) { [weak self] row, data, cell in
            guard let `self` = self else {
                return
            }
            
            cell.configureCell(data: data, delegate: self)
        }.disposed(by: bag)
        
        viewModel.error.subscribeOn(MainScheduler.instance).subscribe(onNext: { error in
            ProgressHUD.dismiss()
            Alert.showErrorAlert(by: error)
        }).disposed(by: bag)
    
        searchTextField.rx.controlEvent([.editingChanged]).asObservable().subscribe(onNext: { [weak self] in
            guard let `self` = self else {
                return
            }
            
            self.viewModel.searchData(text: self.searchTextField.text ?? "")
        }).disposed(by: bag)
    }
    
    @objc private func onBackButtonTouchUpInside(sender: Any) {
        viewModel.goBack()
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight: Int = Int(keyboardSize.height)
            
            UIView.animate(withDuration: 0.25, animations: { [weak self] in
                guard let `self` = self else {
                    return
                }
                
                self.tableView.snp.remakeConstraints({ maker in
                    maker.top.equalTo(self.separatorView.snp.bottom).inset(-16)
                    maker.leading.equalToSuperview()
                    maker.trailing.equalToSuperview()
                    maker.bottom.equalToSuperview().inset(keyboardHeight)
                })
                
                self.emptyStateView.snp.remakeConstraints({ maker in
                    maker.top.equalTo(self.separatorView.snp.bottom)
                    maker.leading.equalToSuperview()
                    maker.trailing.equalToSuperview()
                    maker.bottom.equalToSuperview().inset(keyboardHeight)
                })
                
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.25, animations: {
            self.tableView.snp.remakeConstraints({ maker in
                maker.top.equalTo(self.separatorView.snp.bottom).inset(-16)
                maker.leading.equalToSuperview()
                maker.trailing.equalToSuperview()
                maker.bottom.equalToSuperview()
            })
            
            self.emptyStateView.snp.remakeConstraints({ maker in
                maker.top.equalTo(self.separatorView.snp.bottom).inset(-16)
                maker.leading.equalToSuperview()
                maker.trailing.equalToSuperview()
                maker.bottom.equalToSuperview()
            })
            
            self.view.layoutIfNeeded()
        })
    }
}

// MARK: - LocationTableViewCellDelegate

protocol LocationTableViewCellDelegate: AnyObject {
    
    // MARK: - Instance Methods
    
    func didSelectCellWith(data: LocationCellData)
}

extension LocationViewController: LocationTableViewCellDelegate {
    
    // MARK: - Instance Methods
    
    func didSelectCellWith(data: LocationCellData) {
        searchTextField.resignFirstResponder()
        
        viewModel.didSelect(data: data)
    }
}
