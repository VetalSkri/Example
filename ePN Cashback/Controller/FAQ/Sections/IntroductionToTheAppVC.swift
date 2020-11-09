//
//  IntroductionToTheAppVC.swift
//  CashBackEPN
//
//  Created by Александр on 08/05/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

class IntroductionToTheAppVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var viewModel: IntroductionToTheAppModelType!
    @IBOutlet weak var numberedPageControl: NumberedPageControl!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    
    private let cellIdentifier = "IntroductionToApplCellId"
    private var currentPage: Int = 0 {
        didSet{
            numberedPageControl.currentPage = currentPage
            setupTitleForNextButton()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        if(viewModel.type() == .normal) {
            setUpNavigationBar()
        } else if(viewModel.type() == .onBoarding) {
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        }
    }
    
    func setupView(){
        self.view.backgroundColor = .zurich
        collectionView.backgroundColor = .zurich
        if(viewModel.type() == .onBoarding) {
//            collectionViewCenterYConstraint.constant = -50
        }
        numberedPageControl.numberOfPages = viewModel.numberOfFragments()
        numberedPageControl.dotStyle = .NonNumbered
        numberedPageControl.selectedDotSize = 10
        numberedPageControl.dotScaleFactor = 0.6
        numberedPageControl.spacingBetweenItems = 5
        currentPage = 0
        skipButton.setTitle(viewModel.skipButtonTitle(), for: .normal)
        skipButton.setTitleColor(UIColor.minsk, for: .normal)
        skipButton.titleLabel?.font = .medium15
        nextButton.setTitleColor(.sydney, for: .normal)
        nextButton.titleLabel?.font = .medium15
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func setUpNavigationBar() {
        title = NSLocalizedString("FAQ_onBoarding", comment: "")
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.sydney,
            NSAttributedString.Key.font : UIFont.semibold17
        ]
        navigationController?.navigationBar.backgroundColor = .zurich
        
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named:"back")!.withRenderingMode(.alwaysOriginal), for: .normal)
        backButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    @objc func backButtonTapped() {
        viewModel.goOnBack()
    }
    
    func setupTitleForNextButton(){
        let fragment = viewModel.fragment(forRow: currentPage)
        self.nextButton.setTitle(fragment.nextButtonTitle, for: .normal)
    }
    
    @IBAction func skipButtonClicked(_ sender: Any) {
        closeView()
    }
    
    @IBAction func nextButtonClicked(_ sender: Any) {
        if(self.currentPage == viewModel.numberOfFragments()-1){
            closeView()
            return
        }
        currentPage += 1
        collectionView?.scrollToItem(at: IndexPath(row: currentPage, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    private func closeView() {
        switch viewModel.type() {
        case .normal:
            viewModel.goOnBack()
        case .onBoarding:
            Session.shared.isAuth ? viewModel.goOnMain() : viewModel.goOnAuth()
        }
    }
    
}

extension IntroductionToTheAppVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
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
        if(currentPage != self.currentPage && currentPage < self.viewModel.numberOfFragments()){
            self.currentPage = currentPage
        }
    }
    
}
