//
//  StockFilterVC.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 10/06/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

protocol StockFilterVCDelegate: class {
    func applyFilters(filters: [StockFilterCategory])
}

class StockFilterVC: UIViewController {

    weak var delegate : StockFilterVCDelegate?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var applyButton: EPNButton!
    var viewModel: StockFilterModelType!
    private let headerIdentifier = "sectionStockCollectionViewHeaderId"
    private let cellIdentifier = "stockFilterCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = .zurich
        self.view.backgroundColor = .zurich
        
        setUpNavigationBar()
        
        let leftAlignedLayout = EPNAlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .center)
        leftAlignedLayout.headerReferenceSize = CGSize(width: collectionView.frame.width, height: 50)
        leftAlignedLayout.minimumInteritemSpacing = 10
        leftAlignedLayout.minimumLineSpacing = 10
        leftAlignedLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        leftAlignedLayout.estimatedItemSize = CGSize(width: 1, height: 1)
        collectionView.collectionViewLayout = leftAlignedLayout
        collectionView.allowsMultipleSelection = true
        
        applyButton.style = .primary
        applyButton.text = viewModel.buttonText
        applyButton.handler = { [weak self] (button) in
            self?.delegate?.applyFilters(filters: self!.viewModel.getFilters())
            self?.viewModel.goOnBack()
        }
    }
    
    func setUpNavigationBar() {
        title = viewModel.title
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.sydney, NSAttributedString.Key.font : UIFont.semibold17]
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"back")!.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    @objc func backButtonTapped() {
        viewModel.goOnBack()
    }
    
}

extension StockFilterVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! StockFilterCollectionViewCell
        cell.setupCellWithFilterName(name: viewModel.objectName(forIndexPath: indexPath), selected: viewModel.isSelectedItem(forIndexPath: indexPath))
        cell.isSelected = false
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! StockFilterHeaderCollectionView
        sectionHeaderView.viewModel = viewModel.header(forSection: indexPath.section)
        sectionHeaderView.categoryTitleButton.tag = indexPath.section
        sectionHeaderView.categoryTitleButton.addTarget(self, action: #selector(resetTapped(sender:)), for: .touchUpInside)
        return sectionHeaderView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 10, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectItem(atIndexPath: indexPath)
        collectionView.reloadData()
    }
    
    @objc func resetTapped(sender: UIButton) {
        viewModel.resetSection(section: sender.tag)
        collectionView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
}
