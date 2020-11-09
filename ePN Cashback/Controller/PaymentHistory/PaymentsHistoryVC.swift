//
//  PaymentsHistoryVC.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 04/02/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit
import ProgressHUD

class PaymentsHistoryVC: UIViewController {

    var viewModel: PaymentsHistoryModelType!
    var needRefresh = false
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicatorOfBottomPaging: UIActivityIndicatorView!
    
    private var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = .sydney
        refreshControl.addTarget(self, action:
            #selector(refreshPayments(_:)),
                                 for: UIControl.Event.valueChanged)
        
        self.indicatorOfBottomPaging.isHidden = true
        tableView.sectionIndexBackgroundColor = .clear
        tableView.backgroundColor = .zurich
        self.tableView.addSubview(refreshControl)
        self.view.backgroundColor = .zurich
        setUpNavigationBar()
        
        ///Send event to analytic about open PaymentsHistory
        Analytics.paymentsHistoryEventPressed()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        refreshControl.endRefreshing()
        ProgressHUD.dismiss()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshControl.endRefreshing()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (viewModel.cacheLifeTimeIsExpired() || needRefresh) {
            ProgressHUD.show()
            loadPayments()
        }
    }

    func setUpNavigationBar() {
        navigationController?.navigationBar.barTintColor = .zurich
        
        title = viewModel.headTitle
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.sydney , NSAttributedString.Key.font : UIFont.semibold17]
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"back")!.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }

    @objc func backButtonTapped() {
        viewModel.goOnBack()
    }
    
    @objc private func refreshPayments(_ sender: Any) {
        loadPayments()
    }
    

    func loadPayments() {
        viewModel.loadPaymentsHistory(completion: { [weak self] in
            OperationQueue.main.addOperation { [weak self] in
                self?.tableView.reloadData()
                self?.refreshControl.endRefreshing()
                ProgressHUD.dismiss()
            }
            }, failure: { [weak self] () in
                ProgressHUD.dismiss()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                    self?.refreshControl.endRefreshing()
                }
        })
    }
    
}

extension PaymentsHistoryVC: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 48))
        let headLabel: UILabel = UILabel()
        headerView.addSubview(headLabel)
        headLabel.translatesAutoresizingMaskIntoConstraints = false
        headLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20).isActive = true
        headLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 20).isActive = true
        headLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -10).isActive = true
        headLabel.textColor = .sydney
        headLabel.text = viewModel.titleOfSection(inSection: section)
        headLabel.font = .semibold13
        headerView.backgroundColor = .zurich
        return headerView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections(in: tableView, count: viewModel.numberOfSections())
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.titleOfSection(inSection: section)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(fromSection: section)
    }
    
    //TODO: - need to think about this and how to show empty result
    func numberOfSections(in tableView: UITableView, count numOfSections: Int) -> Int {
        if numOfSections > 0 {
            tableView.backgroundView = nil
        } else {
            //TODO: - add status of empty tableview that to display different types information
            
            setupContainer(inTableView: tableView)
        }
        return numOfSections
    }
    
    func setupContainer(inTableView tableView: UITableView) {
        let type = viewModel.getTypeOfResponse()
        
        let container: UIView = UIView(frame: CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.size.width, height: tableView.frame.size.height))
        container.backgroundColor = .zurich
        switch type {
            case .new:
                let imageView: UIImageView = UIImageView()
                let textLabel: EPNLabel = EPNLabel(style: .helperText)
                
                let emptyView = UIView()
                emptyView.translatesAutoresizingMaskIntoConstraints = false
                container.addSubview(emptyView)
                emptyView.centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: 0).isActive = true
                emptyView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 0).isActive = true
                emptyView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 0).isActive = true
                
                textLabel.text = viewModel.getTextForEmptyPage()
                textLabel.font = .medium15
                textLabel.numberOfLines = 0
                textLabel.textAlignment = .center
                
                imageView.image = UIImage(named: "noFound")
                imageView.contentMode = .scaleAspectFit
                
                emptyView.addSubview(imageView)
                emptyView.addSubview(textLabel)
                
                imageView.translatesAutoresizingMaskIntoConstraints = false
                imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
                imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, constant: 0).isActive = true
                imageView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor, constant: 0).isActive = true
                imageView.topAnchor.constraint(equalTo: emptyView.topAnchor, constant: 0).isActive = true
                
                textLabel.translatesAutoresizingMaskIntoConstraints = false
                textLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
                textLabel.bottomAnchor.constraint(equalTo: emptyView.bottomAnchor, constant: 0).isActive = true
                textLabel.leadingAnchor.constraint(equalTo: emptyView.leadingAnchor, constant: 30).isActive = true
                textLabel.trailingAnchor.constraint(equalTo: emptyView.trailingAnchor, constant: -30).isActive = true
            
            
            default:
                break
        }
        tableView.backgroundView = container
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "paymentCell", for: indexPath) as! PaymentTableViewCell
        
        cell.viewModel = viewModel.cellViewModel(forIndexPath: indexPath)
        if viewModel.isPagingPayments(atIndexPath: indexPath) {
            DispatchQueue.main.async {
                self.indicatorOfBottomPaging.isHidden = false
                self.indicatorOfBottomPaging.startAnimating()
            }
            viewModel.pagingPaymentsHistory(completion: { [weak self] in
                OperationQueue.main.addOperation { [weak self] in
                    self?.indicatorOfBottomPaging.isHidden = true
                    self?.indicatorOfBottomPaging.stopAnimating()
                    self?.tableView.reloadData()
                }
                }, failure: { [weak self] () in
                    OperationQueue.main.addOperation { [weak self] in
                        self?.indicatorOfBottomPaging.isHidden = true
                        self?.indicatorOfBottomPaging.stopAnimating()
                    }
            })
            
        }
        return cell
    }
    
}


