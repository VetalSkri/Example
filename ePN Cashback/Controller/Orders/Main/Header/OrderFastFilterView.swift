//
//  OrderFastFilterView.swift
//  Backit
//
//  Created by Александр Кузьмин on 10/03/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import UIKit

protocol OrderFastFilterViewDelegate: class {
    func updateFilter(selectedTransactionsType: Int?)
    func canUpdateFilter() -> Bool
}

class OrderFastFilterView: UIView {
    
    weak var delegate: OrderFastFilterViewDelegate?
    private var isFirstLayout = true
    private var cellId = "orderFastFilterCellId"
    private let filters = [NSLocalizedString("Stores", comment: ""), NSLocalizedString("Receipts", comment: "")]
    private var selectedFilterIndex: Int?
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bottomSeparatorView: UIView!
    
    
    class func instanceFromNib() -> OrderFastFilterView {
        return UINib(nibName: "OrderFastFilterView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! OrderFastFilterView
    }
    
    override func layoutSubviews() {
        if isFirstLayout {
            setupView()
        }
        isFirstLayout = false
    }
    
    private func setupView() {
        collectionView.register(UINib(nibName: "OrderFastFilterCell", bundle: nil), forCellWithReuseIdentifier: cellId)
        collectionView.delegate = self
        collectionView.dataSource = self
        (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).estimatedItemSize = CGSize(width: 1, height: 1)
        bottomSeparatorView.backgroundColor = .paris
    }
    
    func cancelFilter() {
        selectedFilterIndex = nil
        if let shopFilterCell = collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? OrderFastFilterCell, let receiptFilterCell = collectionView.cellForItem(at: IndexPath(row: 1, section: 0)) as? OrderFastFilterCell {
            shopFilterCell.setSelected(false)
            receiptFilterCell.setSelected(false)
            UIView.animate(withDuration: 0.4) { [weak self] in
                self?.collectionView.collectionViewLayout.invalidateLayout()
                self?.collectionView.layoutIfNeeded()
            }
        }
    }
    
}

extension OrderFastFilterView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! OrderFastFilterCell
        cell.setupCell(with: filters[indexPath.row], isSelected: indexPath.row == selectedFilterIndex ?? -1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !(delegate?.canUpdateFilter() ?? true) {
            return
        }
        let needUpdateSingleCell = (selectedFilterIndex == indexPath.row) || selectedFilterIndex == nil
        selectedFilterIndex = (selectedFilterIndex == indexPath.row) ? nil : indexPath.row
        
        if let selectedCell = collectionView.cellForItem(at: indexPath) as? OrderFastFilterCell, let secondCell = collectionView.cellForItem(at: IndexPath(row: indexPath.row == 0 ? 1 : 0, section: 0)) as? OrderFastFilterCell {
            selectedCell.setSelected(selectedFilterIndex == indexPath.row)
            if !needUpdateSingleCell {
                secondCell.setSelected(false)
            }
            UIView.animate(withDuration: 0.4) {
                collectionView.collectionViewLayout.invalidateLayout()
                collectionView.layoutIfNeeded()
            }
        }
        var selectedTypeId: Int? = nil
        if let selectedFilterIndex = selectedFilterIndex {
            selectedTypeId = (selectedFilterIndex == 0) ? 1 : 3
        }
        delegate?.updateFilter(selectedTransactionsType: selectedTypeId)
    }
    
}
