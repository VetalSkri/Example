//
//  OrdersVC.swift
//  Backit
//
//  Created by Александр Кузьмин on 02/03/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay

class OrdersVC: UIViewController {

    var viewModel: OrdersViewModel!
    private let disposeBag = DisposeBag()
    private let orderCellId = "orderCellId"
    private let orderSkeletonCellId = "orderSkeletonCellId"
    private let refreshControl = UIRefreshControl()
    private var filterView: OrderFastFilterView!
    private var searchController: UISearchController!
    private var filterBarButton: UIBarButtonItem!
    private let filterButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
    private let lastContentOffset: CGFloat = 0.0
    
    //Main container view
    @IBOutlet weak var mainContainerView: UIView!
    
    //TableView
    @IBOutlet weak var tableView: UITableView!
    private var pagingActivityIndicatorView: UIActivityIndicatorView!
    
    //NoOrders fields
    @IBOutlet weak var noOrdersContainerView: UIView!
    @IBOutlet weak var noOrdersTitleLabel: UILabel!
    @IBOutlet weak var noOrdersDescriptionLabel: UILabel!
    @IBOutlet weak var noOrderLinkLabel: UILabel!
    @IBOutlet weak var noOrderLinkDashedView: UIView!
    
    //Cancel filters
    @IBOutlet weak var cancelFilterContainerView: UIView!
    @IBOutlet weak var cancelFilterTitleLabel: UILabel!
    @IBOutlet weak var cancelFilterButton: UIButton!
    
    //Order no found link view
    @IBOutlet weak var noFoundBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var noFoundLinkContainerView: UIView!
    @IBOutlet weak var noFoundGradientView: EPNGradientView!
    @IBOutlet weak var noFoundLinkLabel: UILabel!
    @IBOutlet weak var noFoundDashedView: UIView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindVM()
        setUpNavigationBar()
        viewModel.getOrders(refresh: false)
    }
    
    func setUpNavigationBar() {
        title = NSLocalizedString("OrdersTitle", comment: "")
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        setLargeTitleDisplayMode(.never)
        navigationController?.navigationBar.barTintColor = .zurich
        navigationItem.hidesSearchBarWhenScrolling = false
        filterButton.setImage(UIImage(named: "verticalFilter")?.withRenderingMode(.alwaysOriginal), for: .normal)
        filterButton.addTarget(self, action:#selector(filterTapped) , for: .touchUpInside)
        filterButton.setTitle(nil, for: .normal)
        filterBarButton = UIBarButtonItem(customView: filterButton)
        navigationItem.rightBarButtonItems = [filterBarButton]
        setupSearch()
    }
    
    @objc private func filterTapped() {
        viewModel.openFilter()
    }
    
    override func viewWillLayoutSubviews() {
        navigationController?.navigationBar.setBackgroundImage(UIColor.white.toImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    private func setupSearch() {
        
        let searchVC = SearchOrderTableVC.controllerFromStoryboard(.orders)
        searchVC.viewModel = SearchOrderViewModel(router: viewModel.getRouter())
        searchController = UISearchController(searchResultsController: searchVC)
        searchController.searchResultsUpdater = searchVC
        searchController.searchBar.delegate = searchVC
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.dimsBackgroundDuringPresentation = false
        self.definesPresentationContext = true
        let textFieldInsideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.placeholder = NSLocalizedString("Order number", comment: "")
        textFieldInsideSearchBar?.font = .medium15
        textFieldInsideSearchBar?.textColor = .sydney
        textFieldInsideSearchBar?.tintColor = .sydney
        searchController.dimsBackgroundDuringPresentation = false
        if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            if let backgroundview = textfield.subviews.first {
                backgroundview.backgroundColor = .clear
                backgroundview.layer.cornerRadius = 10
                backgroundview.clipsToBounds = true
            }
        }
        navigationItem.searchController = searchController
        setupSearchAttributes()
    }
    
    private func setupSearchAttributes() {
        let attributes = [
            NSAttributedString.Key.foregroundColor : UIColor.minsk,
            NSAttributedString.Key.font : UIFont.semibold17
        ]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributes, for: .normal)
    }
    
    private func bindVM() {
        
        viewModel.orders.asObservable().subscribe { [weak self] (event) in
            if self?.refreshControl.isRefreshing ?? false {
                self?.refreshControl.endRefreshing()
            }
            self?.tableView.reloadData()
            if (self?.viewModel.orders.value.count ?? 0 == 0) && (self?.viewModel.state.value ?? OrderPageState.allIsLoadeds == OrderPageState.allIsLoadeds) {
                if !(self?.viewModel.hasActiveFilters() ?? false) {
                    self?.showNoOrdersView()
                } else {
                    self?.showCancelFilterView()
                }
            }
        }.disposed(by: disposeBag)
        
        viewModel.state.asObservable().observeOn(MainScheduler.instance).subscribe { [weak self] (event) in
            if let pageState = event.element {
                switch pageState {
                case .allIsLoadeds:
                    self?.pagingActivityIndicatorView.stopAnimating()
                    break
                case .firstLoad:
                    self?.pagingActivityIndicatorView.stopAnimating()
                    self?.tableView.reloadData()
                    break
                case .paging:
                    self?.pagingActivityIndicatorView.startAnimating()
                    break
                case .error:
                    self?.pagingActivityIndicatorView.stopAnimating()
                    self?.tableView.reloadData()
                    if self?.refreshControl.isRefreshing ?? false {
                        self?.refreshControl.endRefreshing()
                    }
                    break
                }
            }
        }.disposed(by: disposeBag)
        viewModel.hasFilter.asObservable().observeOn(MainScheduler.instance).subscribe { [weak self] (event) in
            self?.cancelFilterContainerView.isHidden = true
            self?.tableView.isScrollEnabled = true
            self?.filterButton.setImage(UIImage(named: (self?.viewModel.hasActiveCommonFilters() ?? false) ? "activeVerticalFilter" : "verticalFilter"), for: .normal)
        }.disposed(by: disposeBag)
    }
    
    private func showNoOrdersView() {
        UIView.animate(withDuration: 0.6) { [weak self] in
            self?.tableView.alpha = 0.0
            self?.tableView.isHidden = true
            self?.setShowBottomLink(isShow: false)
            self?.noOrdersContainerView.isHidden = false
            self?.noOrdersContainerView.alpha = 1.0
            self?.navigationItem.searchController = nil
            self?.navigationItem.rightBarButtonItems = []
        }
    }
    
    private func showCancelFilterView() {
        self.cancelFilterContainerView.isHidden = false
        self.tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        self.tableView.isScrollEnabled = false
        self.setShowBottomLink(isShow: true)
    }
    
    private func setupView() {
        filterView = OrderFastFilterView.instanceFromNib()
        filterView.delegate = self
        filterView.translatesAutoresizingMaskIntoConstraints = false
        
        pagingActivityIndicatorView = UIActivityIndicatorView(style: .gray)
        pagingActivityIndicatorView.frame = CGRect(x: 0, y: 0, width: 0, height: 40)
        pagingActivityIndicatorView.color = .sydney
        
        view.backgroundColor = .zurich
        
        tableView.register(UINib(nibName: "OrderTableViewCell", bundle: nil), forCellReuseIdentifier: orderCellId)
        tableView.register(UINib(nibName: "OrderSkeletonTableViewCell", bundle: nil), forCellReuseIdentifier: orderSkeletonCellId)
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 130
        tableView.tableFooterView = pagingActivityIndicatorView
        tableView.tableHeaderView = filterView
        filterView.centerXAnchor.constraint(equalTo: self.tableView.centerXAnchor).isActive = true
        filterView.widthAnchor.constraint(equalTo: self.tableView.widthAnchor).isActive = true
        filterView.topAnchor.constraint(equalTo: self.tableView.topAnchor).isActive = true
        //filterView.layoutIfNeeded()
        
        refreshControl.tintColor = .sydney
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        tableView.refreshControl = refreshControl
        
        noOrdersContainerView.backgroundColor = .zurich
        noOrdersTitleLabel.font = .bold17
        noOrdersTitleLabel.textColor = .sydney
        noOrdersTitleLabel.text = NSLocalizedString("You have no orders yet", comment: "")
        
        noOrdersDescriptionLabel.font = .medium15
        noOrdersDescriptionLabel.textColor = .london
        noOrdersDescriptionLabel.text = NSLocalizedString("Here you will find your purchases in stores", comment: "")

        noOrderLinkLabel.font = .semibold13
        noOrderLinkLabel.textColor = .sydney
        noOrderLinkLabel.text = NSLocalizedString("Don't you find your order?", comment: "")
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.minsk.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [4, 4]
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 0, y: 0), CGPoint(x: noOrderLinkDashedView.frame.size.width, y: 0)])
        shapeLayer.path = path
        noOrderLinkDashedView.layer.addSublayer(shapeLayer)
        
        mainContainerView.bringSubviewToFront(cancelFilterContainerView)
        cancelFilterTitleLabel.font = .semibold17
        cancelFilterTitleLabel.textColor = .sydney
        cancelFilterTitleLabel.text = NSLocalizedString("No orders found", comment: "")
        
        cancelFilterButton.backgroundColor = .moscow
        cancelFilterButton.setTitleColor(.zurich, for: .normal)
        cancelFilterButton.titleLabel?.font = .semibold15
        cancelFilterButton.setTitle(NSLocalizedString("Without filters", comment: ""), for: .normal)
        cancelFilterButton.cornerRadius = CommonStyle.buttonCornerRadius
        
        noFoundLinkContainerView.backgroundColor = .zurich
        noFoundGradientView.backgroundColor = .clear
        noFoundGradientView.startColor = UIColor.zurich.withAlphaComponent(0.0)
        noFoundGradientView.endColor = .zurich
        noFoundGradientView.verticalMode = true
        noFoundLinkLabel.font = .semibold13
        noFoundLinkLabel.textColor = .sydney
        noFoundLinkLabel.text = NSLocalizedString("Don't you find your order?", comment: "")
        
        let shapeLayer2 = CAShapeLayer()
        shapeLayer2.strokeColor = UIColor.minsk.cgColor
        shapeLayer2.lineWidth = 1
        shapeLayer2.lineDashPattern = [4, 4]
        let path2 = CGMutablePath()
        path2.addLines(between: [CGPoint(x: 0, y: 0), CGPoint(x: noFoundDashedView.frame.size.width, y: 0)])
        shapeLayer2.path = path2
        noFoundDashedView.layer.addSublayer(shapeLayer2)
    }
    
    private func setShowBottomLink(isShow: Bool) {
        if ((isShow && noFoundBottomConstraint.constant == 0) || (!isShow && noFoundBottomConstraint.constant != 0)) {
            return
        }
        UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions(), animations: { [weak self] in
            self?.noFoundBottomConstraint.constant = (isShow) ? 0 : -150
            self?.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc func refresh(sender:AnyObject){
        viewModel.getOrders(refresh: true)
    }
    
    @IBAction func linkTapGesture(_ sender: Any) {
        OldAPI.performTransition(type: .searchOrder)
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        cancelFilterContainerView.isHidden = true
        tableView.isScrollEnabled = true
        filterView.cancelFilter()
        viewModel.cancelFilters()
    }
    
}

extension OrdersVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.state.value == .firstLoad {
            let cell = tableView.dequeueReusableCell(withIdentifier: orderSkeletonCellId, for: indexPath) as! OrderSkeletonTableViewCell
            cell.setupCell()
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: orderCellId, for: indexPath) as! OrderTableViewCell
        if let transaction = viewModel.order(for: indexPath) {
            let shopInfo = viewModel.shopNameAndLogo(for: Int(transaction.attributes.offer_id) ?? -1, typeId: transaction.attributes.type_id)
            cell.setupCell(transaction: transaction, imageUrl: shopInfo.shopLogo, offerName: shopInfo.shopName)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.orderWasSelected(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.displayCell(for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 48))
        if viewModel.state.value == .firstLoad {
            let skeletonHeaderView = SkeletonHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 48))
            return skeletonHeaderView
        }
        let headLabel: UILabel = UILabel()
        headerView.addSubview(headLabel)
        headLabel.translatesAutoresizingMaskIntoConstraints = false
        headLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20).isActive = true
        headLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20).isActive = true
        headLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor, constant: 0).isActive = true
        headLabel.text = viewModel.title(for: section)
        headLabel.font = .semibold17
        headLabel.textColor = .sydney
        headerView.backgroundColor = .zurich
        return headerView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }

     func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        self.setShowBottomLink(isShow: velocity.y <= 0)
      }
}

extension OrdersVC: OrderFastFilterViewDelegate {
    
    func updateFilter(selectedTransactionsType: Int?) {
        viewModel.updateTypeFilter(newType: selectedTransactionsType)
    }
    
    func canUpdateFilter() -> Bool {
        return viewModel.state.value != .firstLoad
    }
    
}

