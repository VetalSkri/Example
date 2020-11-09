//
//  SupportVC.swift
//  Backit
//
//  Created by Александр Кузьмин on 08/11/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

protocol SupportVCDelegate: class {
    func refresh()
}

class SupportVC: UIViewController {

    var viewModel: SupportViewModel!
    private var openPageIndex = 0
    private let activeCellId = "activeCellId"
    private let closedCellId = "closedCellId"
    
    //Header
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tabContainerView: UIView!
    @IBOutlet weak var activeTabButton: UIButton!
    @IBOutlet weak var closedTabButton: UIButton!
    
    //CollectionView
    @IBOutlet weak var collectionView: UICollectionView!
    
    //EmptyView
    @IBOutlet weak var emptyContainerView: UIView!
    @IBOutlet weak var emptyDescriptionLabel: UILabel!
    
    //NewDialog button
    @IBOutlet weak var newDialogButtonContainerView: UIView!
    var newDialogButton = EPNButton(style: .primary, size: .large1)
    
    //No ethernet view
    @IBOutlet weak var noEthernetContainerView: UIView!
    @IBOutlet weak var noEthernetTitleLabel: UILabel!
    @IBOutlet weak var noEthernetSubtitleLabel: UILabel!
    @IBOutlet weak var noEthernetRefreshButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupConstraints()
        setupNavigationBar()
        setupView()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if let interactiveGestureRecognizer = self.navigationController?.interactivePopGestureRecognizer {
            collectionView.panGestureRecognizer.require(toFail: interactiveGestureRecognizer)
        }
        loadTickets()
        subscribe()
    }
    
    deinit {
        unsubscribe()
    }
    
    private func setupSubviews() {
        newDialogButtonContainerView.addSubview(newDialogButton)
    }
    
    private func setupConstraints() {
        newDialogButton.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.top.equalToSuperview().inset(10)
            make.left.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(16)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(16)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.viewDidAppear()
    }

    private func subscribe() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateTicketsSignal), name: NSNotification.Name("updateTickets"), object: nil)
    }
    
    private func unsubscribe() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func updateTicketsSignal() {
        if viewModel.getTicketCount(for: .closed) > 0 || viewModel.getTicketCount(for: .open) > 0 {
            self.collectionView.isHidden = false
            self.headerView.isHidden = false
            self.noEthernetContainerView.isHidden = true
            self.emptyContainerView.isHidden = true
        }
    }
    
    private func loadTickets() {
        noEthernetContainerView.isHidden = true
        collectionView.isHidden = false
        viewModel.loadTickets { [weak self] (success) in
            guard let self = self else { return }
            if !success {
                self.noEthernetContainerView.isHidden = false
                self.collectionView.isHidden = true
                return
            }
            if self.viewModel.getTicketCount(for: .open) == 0 && self.viewModel.getTicketCount(for: .closed) == 0 {    //no tickets
                self.emptyContainerView.isHidden = false
                self.collectionView.isHidden = true
                self.headerView.isHidden = true
                self.switchTab(toIndex: 0)
            } else {
                self.collectionView.isHidden = false
                self.headerView.isHidden = false
                self.emptyContainerView.isHidden = true
            }
        }
    }

    private func setupNavigationBar() {
        title = viewModel.title
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .zurich
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.sydney , NSAttributedString.Key.font : UIFont.semibold17]
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(backButtonClicked))
    }
    
    @objc func backButtonClicked() {
        viewModel.back()
    }
    
    private func setupView() {
        view.backgroundColor = .zurich
        
        noEthernetContainerView.backgroundColor = .zurich
        noEthernetTitleLabel.text = NSLocalizedString("Connection lost", comment: "")
        noEthernetTitleLabel.textColor = .sydney
        noEthernetTitleLabel.font = .bold17
        noEthernetSubtitleLabel.text = NSLocalizedString("Check your internet connection and refresh the page", comment: "")
        noEthernetSubtitleLabel.textColor = .moscow
        noEthernetSubtitleLabel.font = .medium15
        noEthernetRefreshButton.setTitle(NSLocalizedString("Refresh", comment: ""), for: .normal)
        noEthernetRefreshButton.backgroundColor = .sydney
        noEthernetRefreshButton.setTitleColor(.zurich, for: .normal)
        noEthernetRefreshButton.titleLabel?.font = .semibold15
        noEthernetRefreshButton.cornerRadius = 5
        
        headerView.layer.cornerRadius = 11
        headerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        headerView.shadowColor = .shadow
        headerView.shadowOpacity = 1
        headerView.shadowRadius = 10
        headerView.shadowOffset = CGSize(width: 0,height: 0)
        headerView.backgroundColor = .zurich
        
        tabContainerView.backgroundColor = .paris
        tabContainerView.cornerRadius = 5
        
        activeTabButton.titleLabel?.font = .medium13
        activeTabButton.cornerRadius = 5
        activeTabButton.shadowColor = .shadow
        activeTabButton.shadowOffset = CGSize(width: 0, height: 0)
        activeTabButton.shadowOpacity = 0.5
        activeTabButton.setTitle(NSLocalizedString("Active", comment: ""), for: .normal)
        
        closedTabButton.titleLabel?.font = .medium13
        closedTabButton.cornerRadius = 5
        closedTabButton.shadowColor = .shadow
        closedTabButton.shadowOffset = CGSize(width: 0, height: 0)
        closedTabButton.shadowOpacity = 0.5
        closedTabButton.setTitle(NSLocalizedString("Closed", comment: ""), for: .normal)
        
        emptyContainerView.backgroundColor = .zurich
        
        emptyDescriptionLabel.text = NSLocalizedString("EmptyDescription", comment: "")
        emptyDescriptionLabel.textColor = .moscow
        emptyDescriptionLabel.font = .medium15
        
        newDialogButton.text = NSLocalizedString("Start a dialogue", comment: "")
        newDialogButton.handler = { [weak self] button in
            self?.newDialogButtonClicked()
        }
        
        newDialogButtonContainerView.backgroundColor = .zurich
        
        changeButtonState(toIndex: openPageIndex)
    }
    
    private func switchTab(toIndex: Int) {
        if openPageIndex == toIndex {
            return
        }
        openPageIndex = toIndex
        changeButtonState(toIndex: toIndex)
        if collectionView.numberOfItems(inSection: 0) > toIndex {
            collectionView.scrollToItem(at: IndexPath(row: toIndex, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    private func changeButtonState(toIndex: Int) {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.activeTabButton.shadowRadius = (toIndex == 0) ? 4 : 0
            self?.activeTabButton.backgroundColor = (toIndex == 0) ? UIColor.zurich : UIColor.clear
            self?.activeTabButton.titleLabel?.font = (toIndex == 0) ? UIFont.semibold13 : UIFont.medium13
            self?.activeTabButton.setTitleColor((toIndex == 0) ? UIColor.moscow : UIColor.london , for: .normal)
            self?.closedTabButton.shadowRadius = (toIndex == 1) ? 4 : 0
            self?.closedTabButton.backgroundColor = (toIndex == 1) ? UIColor.zurich : UIColor.clear
            self?.closedTabButton.titleLabel?.font = (toIndex == 1) ? UIFont.semibold13 : UIFont.medium13
            self?.closedTabButton.setTitleColor((toIndex == 1) ? UIColor.moscow : UIColor.london , for: .normal)
        }
    }
    
    @IBAction func activeButtonClicked(_ sender: Any) {
        switchTab(toIndex: 0)
    }
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        switchTab(toIndex: 1)
    }
    
    private func newDialogButtonClicked() {
        viewModel.createTicket()
    }
    
    @IBAction func noEthernetRefreshButtonClicked(_ sender: Any) {
        loadTickets()
    }
    
    
}

extension SupportVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: activeCellId, for: indexPath) as! ActiveTicketsCollectionViewCell
            cell.viewModel = viewModel
            cell.setupCell()
            cell.delegate = self
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: closedCellId, for: indexPath) as! ClosedTicketsCollectionViewCell
            cell.viewModel = viewModel
            cell.setupCell()
            cell.delegate = self
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        endScroll(scrollView: scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            endScroll(scrollView: scrollView)
        }
    }
    
    private func endScroll(scrollView: UIScrollView) {
        let currentIndex = Int(round(scrollView.contentOffset.x / scrollView.frame.size.width))
        if (currentIndex != self.openPageIndex) {
            self.openPageIndex = currentIndex
            changeButtonState(toIndex: self.openPageIndex)
        }
    }
    
}

extension SupportVC: SupportVCDelegate {
    
    func refresh() {
        loadTickets()
    }
    
}
