//
//  RatesCollectionViewCell.swift
//  Backit
//
//  Created by Александр Кузьмин on 08/10/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

class RatesCollectionViewCell: OfflineCollectionViewCellBase {
    
    private var viewModel: OfflineOfferDetailViewModel!

    @IBOutlet weak var tableView: UITableView!
    private let cellId = "ratesCellId"
    
    override func didMoveToSuperview() {
        self.backgroundColor = .paris
        tableView.backgroundColor = .paris
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupCell(viewModel: OfflineOfferDetailViewModel, scrollToTop: Bool) {
        self.viewModel = viewModel
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100))
        tableView.reloadData()
        if scrollToTop && tableView.contentOffset.y > 5 {
            disableDelegateHandler = true
            scrollingToTop()
        }
    }
    
    func stopScroll() {
        tableView.setContentOffset(tableView.contentOffset, animated: false)
    }
    
    func scrollingToTop() {
        if tableView.contentOffset.y > 5 {
            disableDelegateHandler = true
            tableView.setContentOffset( CGPoint(x: 0, y: 0), animated: true)
        }
    }
    
}

extension RatesCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRates()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! RatesTableViewCell
        cell.selectionStyle = .none
        if let rate = viewModel.rate(row: indexPath.row) {
            cell.setupCell(rate: rate, isMulti: viewModel.isMultiOffer())
        }
        cell.backgroundColor = .paris
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row >= (viewModel.numberOfRates() - 1) {
            return
        }
        let additionalSeparatorThickness = CGFloat(2.0)
        let additionalSeparator = UIView(frame: CGRect(x:0,
                                                       y: cell.frame.size.height - additionalSeparatorThickness,
                                                       width: cell.frame.size.width-16,
                                                       height: additionalSeparatorThickness))
        additionalSeparator.backgroundColor = UIColor.zurich
        cell.addSubview(additionalSeparator)
    }

}
