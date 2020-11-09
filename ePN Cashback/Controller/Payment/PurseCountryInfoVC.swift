//
//  PurseCountryInfoVC.swift
//  Backit
//
//  Created by Виталий Скриганюк on 26.06.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//
import UIKit
import RxSwift
import RxCocoa
import SnapKit
import ProgressHUD

class PurseCountryInfoVC: UIViewController {
    
    // Containers View's
    private let containerView = UIView()
    private let businesView = UIView()
    private let infoView = UIView()
    private weak var bottomView: BottomPaymentView?

    // Content View's
    private let countryLabel = UILabel()
    private let tableView = UITableView()
    private let continueButton = UIButton()
    
    private let bag = DisposeBag()
    
    var viewModel: PurseCountryInfoType!
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        self.title = NSLocalizedString("Hint", comment: "")
        
        setBottomView()
        setupSubviews()
        setupConstraints()
        tableView.setupStyle()
        setupNavigationBar()
        binding()
        viewModel.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadData()
        (self.navigationController as! PaymentsNavigationController).isHideBottomView(status: false)
    }
    
    
    private func setupNavigationBar() {
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .zurich
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.sydney , NSAttributedString.Key.font : UIFont.semibold17]
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(backButtonClicked))
    }
    
    @objc func backButtonClicked() {
        viewModel.pop()
    }
    
    private func setBottomView() {
        self.bottomView = (self.navigationController as! PaymentsNavigationController).bottomView
    }
    
    private func setupSubviews() {
        containerView.addSubview(infoView)
        containerView.addSubview(businesView)
        
        infoView.addSubview(countryLabel)
        
        countryLabel.textColor = .black
        countryLabel.numberOfLines = 0
        countryLabel.font = .bold20
        
        businesView.addSubview(tableView)
        tableView.register(PurseCountryInfoTableCell.self, forCellReuseIdentifier: "PurseCountryInfoTableCell")
        tableView.setupStyle()
        tableView.isScrollEnabled = false
        
        self.view.addSubview(containerView)
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        infoView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        countryLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.left.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(80)
            make.bottom.equalToSuperview()
        }
        businesView.snp.makeConstraints { make in
            make.top.equalTo(infoView.snp.bottom).offset(32)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func isHideBottomView(status: Bool) {
        (self.navigationController as! PaymentsNavigationController).isHideBottomView(status: status)
    }
    
    private func binding() {
        viewModel.info.bind(to: tableView.rx.items(cellIdentifier: "PurseCountryInfoTableCell", cellType: PurseCountryInfoTableCell.self)){ row, info, cell in
            cell.setupCell(data: info)
        }.disposed(by: bag)
        
        viewModel.titleLabel.bind(to: countryLabel.rx.text)
            .disposed(by: bag)
        
        viewModel?.fieldsIsFull.subscribeOn(MainScheduler.instance).subscribe(onNext:{ [weak self ] in
            guard let bottomView = self?.bottomView else { return }
            bottomView.updateProgress(status: $0)
        }).disposed(by: bag)
        
        viewModel?.bottomViewInfo.subscribeOn(MainScheduler.instance).subscribe(onNext: { [weak self] in
            guard let bottomView = self?.bottomView else { return }
            guard !$0.dismiss else {
                self?.isHideBottomView(status: true)
                return
            }
            bottomView.setupView(data: $0, delegate: self!)
            
        }).disposed(by: bag)
    }
}

extension PurseCountryInfoVC :BottomPaymentViewDelegate {
    func forward() {
        viewModel.forward()
    }
}
