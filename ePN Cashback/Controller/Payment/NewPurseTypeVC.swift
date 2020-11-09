//
//  NewPurseTypeVC.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 30/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit
import SnapKit
import ProgressHUD
import RxSwift
import RxCocoa

final class NewPurseTypeVC: UIViewController {

    var viewModel: NewPurseType!
    private let refreshControl = UIRefreshControl()
    private var isFirstLayout = true
    private let purseTypeCellIdentifier = "purseTypeCellId"
    
    // Containers View's
    private let containerView = UIView()
    private let businesView = UIView()
    
    // Content View's
    private let tableView = UITableView()
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(PurseTypeTableCell.self, forCellReuseIdentifier: "PurseTypeTableCell")
        
        setupView()
        setupBinding()
        setupSubviews()
        setupConstraints()
        setupNavigationBar()
        tableView.setupStyle()
        setupScrollViewPullToRefresh()
    }
    
    override func viewDidLayoutSubviews() {
        if isFirstLayout {
            isFirstLayout = false
            ProgressHUD.show()
            loadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (self.navigationController as! PaymentsNavigationController).isHideBottomView(status: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        ProgressHUD.dismiss()
    }
    
    private func setupScrollViewPullToRefresh() {
        refreshControl.tintColor = .sydney
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        self.tableView.addSubview(refreshControl)
    }
    
    private func setupSubviews() {
        containerView.addSubview(businesView)
        title = NSLocalizedString("Where to transfer money to?", comment: "")
        businesView.addSubview(tableView)
        tableView.backgroundColor = .clear
        
        self.view.addSubview(containerView)
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        businesView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupBinding() {
        viewModel.errorConnectionLost.observeOn(MainScheduler.instance).subscribe(onNext: { [weak self] in
            
        })
        viewModel.purse.observeOn(MainScheduler.instance).bind(to: tableView.rx.items(cellIdentifier: "PurseTypeTableCell", cellType: PurseTypeTableCell.self)){ row, purseData, cell in
            
            cell.setupCell(purse: purseData, index: row)
            cell.delegate = self
            
        }.disposed(by: bag)
        tableView.rx.itemSelected.subscribe(onNext: {
            let purse = self.viewModel.purse(ofIndexPath: $0)
            if (purse.purseType == PurseType.khabensky) {
                ProgressHUD.show()
                self.viewModel.addCharityPurse {
                    OperationQueue.main.addOperation {
                        ProgressHUD.dismiss()
                    }
                }
                return
            }
            self.viewModel.selectPurseType(withIndexPath: $0)
            }).disposed(by: bag)
    }
    
    private func setupView() {
        self.view.backgroundColor = .zurich
    }
    
    @objc func refresh(sender:AnyObject)
    {
        loadData()
    }
    
    private func loadData() {
        viewModel.loadData(success: { [weak self] in
            OperationQueue.main.addOperation { [weak self] in
                ProgressHUD.dismiss()
                self?.tableView.reloadData()
                self?.refreshControl.endRefreshing()
            }
        }) { [weak self] () in
            OperationQueue.main.addOperation { [weak self] in
                ProgressHUD.dismiss()
                self?.refreshControl.endRefreshing()
            }
        }
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .zurich
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.sydney , NSAttributedString.Key.font : UIFont.semibold15]
        navigationController?.navigationBar.shadowImage = UIColor(hex: "F0F0F0")?.toImage()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(backButtonClicked))
    }
    
    @objc func backButtonClicked() {
        viewModel.pop()
    }
}

extension NewPurseTypeVC: PurseTypeCellDelegate {
    func reloadCell(index: Int) {
        self.tableView.beginUpdates()
        self.tableView.reloadRows(at: [IndexPath(item: index, section: 0)], with: .automatic)
        self.tableView.endUpdates()
    }
}
