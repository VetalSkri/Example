//
//  OrderFilterVC.swift
//  Backit
//
//  Created by Александр Кузьмин on 11/03/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit

class OrderFilterVC: UIViewController {

    var viewModel: OrderFilterViewModel!
    private let disposeBag = DisposeBag()
    
    //CollectionView
    @IBOutlet weak var collectionView: UICollectionView!
    
    //Button view
    var buttonContainerView = UIView()
    var acceptButton = EPNButton(style: .primary, size: .large1)
    
    
    private let headerIdentifier = "sectionHeaderViewId"
    private let cellIdentifier = "orderFilterCellId"
    private let skeletonCellIdentifier = "orderFilterSkeletonCellId"
    private let footerViewIdentifier = "orderFilterFooterViewId"
    private var observer: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupConstraints()
        setUpNavigationBar()
        setupView()
        bindVM()
    }
    
    private func setupSubviews() {
        self.view.addSubview(buttonContainerView)
        buttonContainerView.addSubview(acceptButton)
    }
    
    override func viewWillLayoutSubviews() {
        setupConstraints()
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        buttonContainerView.snp.makeConstraints { (make) in
            make.top.equalTo(collectionView.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(self.tabBarController?.tabBar.frame.height ?? CGFloat(0))
        }
        acceptButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(5)
            make.left.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(12)
            make.height.equalTo(50)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.loadOffers()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    func setUpNavigationBar() {
        title = viewModel.headTitle()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.sydney, NSAttributedString.Key.font : UIFont.semibold17]
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"back")!.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    func bindVM() {
        _ = viewModel.timeIntervals.skip(1).observeOn(MainScheduler.instance).subscribe { [weak self] (event) in
            self?.collectionView.reloadSections([0])
        }
        _ = viewModel.offersLoadState.skip(1).distinctUntilChanged().observeOn(MainScheduler.instance).subscribe({ [weak self] (event) in
            self?.collectionView.reloadSections([1])
        })
    }
    
    func setupView() {
        let layout = EPNAlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .center)
        layout.headerReferenceSize = CGSize(width: collectionView.frame.width, height: 50)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.estimatedItemSize = CGSize(width: 1, height: 1)
        collectionView.collectionViewLayout = layout
        collectionView.register(EpnButtonCollectionFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerViewIdentifier)
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = true
        collectionView.delegate = self
        collectionView.dataSource = self
        
        buttonContainerView.backgroundColor = .zurich
        
        acceptButton.text = NSLocalizedString("Show results", comment: "")
        acceptButton.handler = {[weak self] button in
            self?.acceptButtonClicked()
        }
    }
    
    @objc func backButtonTapped() {
        viewModel.goOnBack()
    }
    
    private func acceptButtonClicked() {
        viewModel.acceptFilter()
    }
    
}


extension OrderFilterVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (indexPath.section == 1 && viewModel.offersLoadState.value == .loading) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: skeletonCellIdentifier, for: indexPath) as! OrderFilterSkeletonCell
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! OrderFilterCell
        cell.setupCell(filterName: viewModel.getFilterName(for: indexPath), isSelected: viewModel.filterIsSelected(for: indexPath))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: footerViewIdentifier,
                                                                             for: indexPath) as! EpnButtonCollectionFooterView
            footerView.setupView(isButtonHidden: viewModel.offersLoadState.value != .error)
            footerView.layoutIfNeeded()
            footerView.delegate = self
            return footerView
        default:
            let sectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! OrderFilterCollectionHeaderView
            sectionHeaderView.setupView(title: viewModel.sectionTitle(indexPath.section))
            sectionHeaderView.resetButton.tag = indexPath.section
            sectionHeaderView.resetButton.addTarget(self, action: #selector(resetTapped(sender:)), for: .touchUpInside)
            return sectionHeaderView
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 55)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 10, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectItem(indexPath)
        collectionView.reloadSections([indexPath.section])
    }
    
    @objc func resetTapped(sender: UIButton) {
        viewModel.reset(section: sender.tag)
        collectionView.reloadSections([sender.tag])
    }
}

extension OrderFilterVC: EpnButtonCollectionFooterViewDelegate {
    
    func buttonClicked() {
        viewModel.loadOffers()
    }
    
}
