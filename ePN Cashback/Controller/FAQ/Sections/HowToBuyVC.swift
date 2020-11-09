//
//  HowToBuyVC.swift
//  CashBackEPN
//
//  Created by Александр on 07/05/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

class HowToBuyVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var numberedPageControl: NumberedPageControl!
    var viewModel: HowToBuyModelType!
    private let cellIdentifier = "HowToBuyCellId"
    private var currentPage: Int = 0 {
        didSet{
            numberedPageControl.currentPage = currentPage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setUpNavigationBar()
    }
    
    private func setupView(){
        self.view.backgroundColor = .zurich
        self.numberedPageControl.delegate = self
        self.numberedPageControl.currentPage = 1;
        self.numberedPageControl.numberOfPages = viewModel.numberOfFragments()
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
    }
    
    func setUpNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        title = NSLocalizedString("FAQ_howToBuy", comment: "")
        navigationController?.navigationBar.barTintColor = .zurich
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named:"back")!.withRenderingMode(.alwaysOriginal), for: .normal)
        backButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
//        title = NSLocalizedString("FAQ_howOrderPayments", comment: "")
//        navigationController?.navigationBar.isTranslucent = true
//        navigationController?.navigationBar.largeTitleTextAttributes = [
//            NSAttributedString.Key.foregroundColor: UIColor.sydney,
//            NSAttributedString.Key.font : UIFont.semibold17
//        ]
//        navigationController?.navigationBar.backgroundColor = .zurich
//
//        let backButton = UIButton(type: .system)
//        backButton.setImage(UIImage(named:"back")!.withRenderingMode(.alwaysOriginal), for: .normal)
//        backButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
//        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
//        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
//        navigationController?.navigationBar.isTranslucent = false
    }
    
    @objc func backButtonTapped() {
        viewModel.goOnBack()
    }
    
}

extension HowToBuyVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfFragments()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? HowToBuyCell
        guard let cell = collectionViewCell, let viewModel = viewModel else { return UICollectionViewCell() }
        cell.setupCell(withFragment: viewModel.fragment(forRow: indexPath.row))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let w = scrollView.bounds.size.width
        let currentPage = Int(ceil(x/w))
        if(currentPage != self.currentPage){
            self.currentPage = currentPage
        }
    }
    
}

extension HowToBuyVC : NumberedPageControlDelegate{
    
    func changePage(page: Int) {
        if(viewModel.numberOfFragments() <= page){
            return
        }
        collectionView?.scrollToItem(at: IndexPath(row: page, section: 0), at: .centeredHorizontally, animated: true)
    }
    
}
