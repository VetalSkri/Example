//
//  ReceiptFilterHeaderViewCell.swift
//  Backit
//
//  Created by Ivan Nikitin on 12/02/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import UIKit

class ReceiptFilterHeaderViewCell: UITableViewCell {
    
    @IBOutlet weak var filterCollectionView: UICollectionView!
    private let cellIdentifier = "filterCellId"
    private let defaultCategoryIndexPath = IndexPath(row: 0, section: 0)
    
    var viewModel: ReceiptMainHeaderViewModel? {
        didSet{
            filterCollectionView.delegate = self
            filterCollectionView.dataSource = self
            filterCollectionView.register(UINib(nibName: "ReceiptMainHeaderFilterViewCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
            filterCollectionView.allowsMultipleSelection = true
            filterCollectionView.backgroundColor = .zurich
        }
    }
    
    func updateLayoutSubviews() {
        guard let index = viewModel?.selectedRow() else { return }
        self.filterCollectionView.scrollToItem(at: index, at: .left, animated: false)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

extension ReceiptFilterHeaderViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberOfItems() ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ReceiptMainHeaderFilterViewCell
        guard let viewModel = viewModel else {
            return UICollectionViewCell()
        }
        let selectedStatusOfCell = viewModel.isSelectedFilter(forIndexPath: indexPath)
        cell.setupView(filterTitle: viewModel.filterTitle(forIndexPath: indexPath), isSelected: selectedStatusOfCell)
        if selectedStatusOfCell {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
            viewModel.selectRow(atIndexPath: indexPath)
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ReceiptMainHeaderFilterViewCell else { return false}
        guard let viewModel = viewModel else { return false }
        if !cell.isSelected {
            for index in 0..<viewModel.numberOfItems() where index != indexPath.row  {
                let deselectIndexPath = IndexPath(row: index, section: 0)
                collectionView.deselectItem(at: deselectIndexPath, animated: false)
                viewModel.switchOffTapped()
            }
        }
        return true
    }

    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        viewModel.selectRow(atIndexPath: indexPath)
        viewModel.switchOnTapped(indexPath: indexPath)
        NotificationCenter.default.post(name: .categorySelectedForOfflineFilters, object: nil)
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel else {
            return
        }
        
        viewModel.switchOffTapped()
        
        collectionView.selectItem(at: defaultCategoryIndexPath, animated: false, scrollPosition: .top)
        
        NotificationCenter.default.post(name: .categorySelectedForOfflineFilters, object: nil)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 16, bottom: 10, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}
