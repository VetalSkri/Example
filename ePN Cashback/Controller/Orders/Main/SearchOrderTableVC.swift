//
//  SearchOrderTableVC.swift
//  Backit
//
//  Created by Александр Кузьмин on 11/03/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import UIKit
import RxSwift
import KeyboardAvoidingView

class SearchOrderTableVC: UITableViewController {

    var viewModel: SearchOrderViewModel!
    private let disposeBag = DisposeBag()
    private let orderCellId = "orderCellId"
    private var searchBar: UISearchBar?
    
    private var mainContainer: UIView!
    
    private let imageView: UIImageView = UIImageView()
    private let titleLabel = UILabel()
    private let noFoundLinkLabel = UILabel()
    private let noFoundDashedView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(UINib(nibName: "OrderTableViewCell", bundle: nil), forCellReuseIdentifier: orderCellId)
        bindVM()
    }
    
    private func bindVM() {
        viewModel.orders.asObservable().skip(1).subscribe { [weak self] (event) in
            self?.setNoFoundViewHidden(self?.viewModel.numberOfSections() ?? 0 != 0)
            self?.tableView.reloadData()
        }.disposed(by: disposeBag)
        
        viewModel.state.asObservable().observeOn(MainScheduler.instance).subscribe { [weak self] (event) in
            if let pageState = event.element {
                switch pageState {
                case .allIsLoadeds:
                    self?.searchBar?.isLoading = false
                    break
                case .error:
                    self?.searchBar?.isLoading = false
                default:
                    break
                }
            }
        }.disposed(by: disposeBag)
    }
    
    private func setupView() {
        mainContainer = KeyboardAvoidingView(frame: CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.size.width, height: tableView.frame.size.height))
        let container: UIView = UIView()
        mainContainer.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.leadingAnchor.constraint(equalTo: mainContainer.leadingAnchor).isActive = true
        container.trailingAnchor.constraint(equalTo: mainContainer.trailingAnchor).isActive = true
        container.centerYAnchor.constraint(equalTo: mainContainer.centerYAnchor, constant: 0).isActive = true
        container.backgroundColor = .zurich
        
        titleLabel.font = .semibold17
        titleLabel.textColor = .sydney
        titleLabel.text = viewModel.noFoundText()
        
        noFoundLinkLabel.font = .semibold13
        noFoundLinkLabel.textColor = .sydney
        noFoundLinkLabel.text = viewModel.noFoundOrderTitle
        noFoundLinkLabel.isUserInteractionEnabled = true
        
        imageView.image = UIImage(named: "noGoods")
        imageView.contentMode = .scaleAspectFit
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        noFoundLinkLabel.translatesAutoresizingMaskIntoConstraints = false
        noFoundDashedView.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(imageView)
        container.addSubview(titleLabel)
        container.addSubview(noFoundLinkLabel)
        container.addSubview(noFoundDashedView)
        
        imageView.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.5).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1.0/1.25).isActive = true
        imageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -20).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        noFoundLinkLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16).isActive = true
        noFoundLinkLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        noFoundDashedView.topAnchor.constraint(equalTo: noFoundLinkLabel.bottomAnchor, constant: 2).isActive = true
        noFoundDashedView.leadingAnchor.constraint(equalTo: noFoundLinkLabel.leadingAnchor).isActive = true
        noFoundDashedView.trailingAnchor.constraint(equalTo: noFoundLinkLabel.trailingAnchor).isActive = true
        noFoundDashedView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        noFoundDashedView.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        
        let dashedViewLayer = CAShapeLayer()
        dashedViewLayer.strokeColor = UIColor.minsk.cgColor
        dashedViewLayer.lineWidth = 1
        dashedViewLayer.lineDashPattern = [4, 4]
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 0, y: 0), CGPoint(x: noFoundLinkLabel.intrinsicContentSize.width, y: 0)])
        dashedViewLayer.path = path
        noFoundDashedView.layer.addSublayer(dashedViewLayer)
        
        let noFoundLinkTapGesture = UITapGestureRecognizer(target: self, action: #selector(noFoundLinkTapped(sender:)))
        noFoundLinkLabel.addGestureRecognizer(noFoundLinkTapGesture)
        
        tableView.backgroundView = mainContainer
        mainContainer.isHidden = true
    }
    
    private func setNoFoundViewHidden(_ hidden: Bool) {
        mainContainer.isHidden = hidden
    }
    
    @objc private func noFoundLinkTapped(sender: Any) {
        viewModel.openLostOrders()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: orderCellId, for: indexPath) as! OrderTableViewCell
        if let transaction = viewModel.order(for: indexPath) {
            let shopInfo = viewModel.shopNameAndLogo(for: Int(transaction.attributes.offer_id) ?? -1, typeId: transaction.attributes.type_id)
            cell.setupCell(transaction: transaction, imageUrl: shopInfo.shopLogo, offerName: shopInfo.shopName)
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.orderWasSelected(indexPath: indexPath)
    }
    
}


extension SearchOrderTableVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        self.searchBar = searchController.searchBar
//        searchBar = searchController.searchBar
//        viewModel.observerSearch.onNext(searchController.searchBar.text ?? "")
//        if !searchController.isActive || searchController.isBeingPresented {
//            searchBar?.isLoading = false
//        }
    }
}

extension SearchOrderTableVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchBar = searchBar
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.isLoading = false
        viewModel.reset()
        self.setNoFoundViewHidden(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.getOrders(searchText: searchBar.text)
        searchBar.isLoading = true
    }
}
