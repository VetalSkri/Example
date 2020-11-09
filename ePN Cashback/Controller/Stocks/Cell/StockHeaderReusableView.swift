//
//  StockHeaderReusableView.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 13/03/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

class StockHeaderReusableView: UICollectionViewCell {
    
    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var bannerLabel: UILabel!
    @IBOutlet weak var filterCollectionView: UICollectionView!
    private let cellIdentifier = "percentFilterCell"
    
    var viewModel: StockHeaderReusableViewModel? {
        didSet{
            bannerView.backgroundColor = .prague
            bannerLabel.font = .bold17
            bannerLabel.textColor = .zurich
            bannerLabel.text = NSLocalizedString("Increased cashback 2 lines", comment: "")
            filterCollectionView.allowsMultipleSelection = true
            filterCollectionView.backgroundColor = .zurich
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.filterCollectionView.collectionViewLayout.invalidateLayout()
    }
    
}

extension StockHeaderReusableView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberOfItems() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! FilterOfStockCollectionViewCell
        guard let viewModel = viewModel else {
            return UICollectionViewCell()
        }
        let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath)
        cell.viewModel = cellViewModel
        if cellViewModel != nil {
            cell.isSelected = cellViewModel!.getStatusOfFilter()
            if cellViewModel!.getStatusOfFilter() {
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
            }
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let cell = collectionView.cellForItem(at: indexPath) as? FilterOfStockCollectionViewCell else { return false}
        guard let viewModel = viewModel else { return false }
        if !cell.isSelected {
            for index in 0..<viewModel.numberOfItems() where index != indexPath.row  {
                let deselectIndexPath = IndexPath(row: index, section: 0)
                collectionView.deselectItem(at: deselectIndexPath, animated: false)
                viewModel.switchOffTapped(indexPath: deselectIndexPath)
            }
        }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        let filter = viewModel.switchOnTapped(indexPath: indexPath)
        NotificationCenter.default.post(name: .percentRangeSelectedForStockFilters, object: filter)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        viewModel.switchOffTapped(indexPath: indexPath)
        NotificationCenter.default.post(name: .percentRangeSelectedForStockFilters, object: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cell = collectionView.cellForItem(at: indexPath) as? FilterOfStockCollectionViewCell else { return CGSize(width: 1, height: 1) }
        cell.filter.sizeToFit()
        return CGSize(width: cell.filter.frame.width + 20, height: cell.filter.frame.height + 14)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
}
