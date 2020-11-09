//
//  ShopsCollectionHeaderView.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 06/06/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit
import FSPagerView

class ShopsCollectionHeaderView: UICollectionReusableView {

    @IBOutlet weak var pagerView: FSPagerView!
    @IBOutlet weak var pagerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var pagerViewTopConsrtaint: NSLayoutConstraint!
    @IBOutlet weak var doodlesPageControl: UIPageControl!
    @IBOutlet weak var contentView: UIView!
    
    private let numberOfItemPerRow: CGFloat = 2
    private let leftAndRightPaddings : CGFloat = 25
    private let doodleCellIdentifier = "doodleCellId"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("ShopsCollectionHeaderView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    var viewModel: ShopMainHeaderViewModel?{
        didSet{
            setupView()
        }
    }
    
    private func setupView() {
        guard let viewModel = viewModel else {
            return
        }
        
        self.view.backgroundColor = .zurich
        self.contentView.backgroundColor = .zurich
        pagerView.delegate = self
        pagerView.dataSource = self
        
        pagerView.backgroundColor = .zurich
        pagerView.automaticSlidingInterval = 6
        pagerView.interitemSpacing = 20
        pagerView.isInfinite = true
        pagerView.register(UINib(nibName: "ShopsCollectionHeaderViewCell", bundle: nil), forCellWithReuseIdentifier: doodleCellIdentifier)
        pagerView.isHidden = viewModel.numberOfDoodles() > 0 ? false : true
        pagerViewHeightConstraint.constant = viewModel.numberOfDoodles() > 0 ? 130 : 0
        pagerViewTopConsrtaint.constant = viewModel.numberOfDoodles() > 0 ? 5 : 0
        doodlesPageControl.isHidden = viewModel.numberOfDoodles() > 0 ? false : true
        doodlesPageControl.numberOfPages = viewModel.numberOfDoodles()
        
        pagerView.reloadData()
    }
    
}

extension ShopsCollectionHeaderView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberOfDoodles() ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView, count numOfSections: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: doodleCellIdentifier, for: indexPath) as? ShopsCollectionHeaderViewCell
        guard let cell = collectionViewCell, let viewModel = viewModel else { return UICollectionViewCell() }
        cell.setupCellWithDoodle(doodle: viewModel.doodlesForIndexPath(indexPath: indexPath))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel?.doodleWasClicked(indexPath: indexPath)
    }

}

extension ShopsCollectionHeaderView: FSPagerViewDelegate, FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return viewModel?.numberOfDoodles() ?? 0
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let collectionViewCell = pagerView.dequeueReusableCell(withReuseIdentifier: doodleCellIdentifier, at: index) as! ShopsCollectionHeaderViewCell
        if let viewModel = viewModel {
            collectionViewCell.setupCellWithDoodle(doodle: viewModel.doodlesForIndexPath(indexPath: IndexPath(row: index, section: 0)))
        }
        collectionViewCell.contentView.layer.shadowColor = UIColor.clear.cgColor
        collectionViewCell.contentView.layer.shadowRadius = 0
        collectionViewCell.contentView.layer.shadowOpacity = 0
        if let subview = collectionViewCell.contentView.subviews.first {
            subview.layer.cornerRadius = 3
        }
        return collectionViewCell
    }
    
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        self.doodlesPageControl.currentPage = pagerView.currentIndex
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        viewModel?.doodleWasClicked(indexPath: IndexPath(row: index, section: 0))
    }
    
}
