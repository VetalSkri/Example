//
//  ReceiptsMainVC.swift
//  Backit
//
//  Created by Ivan Nikitin on 07/10/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit
import ProgressHUD
import Lottie
import AVFoundation
import SPStorkController
import RxSwift

class ReceiptsMainVC: UIViewController {

    var viewModel: OfflineCashbackModelType!
    private var isPlayingAnimation = false
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scanButtonView: UIView!
    
    private let identifierOfSearchResultsOfflineVC = "SearchResultsOfflineVC"
    
    
    
    private var refreshControl: UIRefreshControl!
    private let MultyReceiptTableViewCell = "MultyReceiptTableViewCell"
    private let SpecialReceiptTableHeaderView = "SpecialReceiptTableHeaderView"
    private var tableHeaderView: SpecialReceiptTableHeaderView?
    private let headerIdentifier = "filterCellId"
    private let EmptyRececiptsTableViewCell = "EmptyRececiptsTableViewCell"
    private var animationView = AnimationView(name: "scan_button_animation")
    private let disposeBag = DisposeBag()
    private let TAG_FILTER = 101
    private var observer: NSObjectProtocol?
    
    private lazy var specialUIBarButtonItem: UIBarButtonItem = {
        let specialButton = UIButton(type: .system)
        specialButton.setImage(UIImage(named: "specialOfferButton")!.withRenderingMode(.alwaysOriginal), for: .normal)
        specialButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        specialButton.addTarget(self, action: #selector(specialTapped), for: .touchUpInside)
        let specialUIBarButton = UIBarButtonItem(customView: specialButton)
        return specialUIBarButton
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        extendedLayoutIncludesOpaqueBars = true
        
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = .sydney
        refreshControl.addTarget(self, action: #selector(refreshOffers(_:)), for: UIControl.Event.valueChanged)
        title = NSLocalizedString("OfflineCashback", comment: "")
        setUpNavigationBarButton()
        setupSearch()
        
        
        tableHeaderView = UINib(nibName: SpecialReceiptTableHeaderView, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? SpecialReceiptTableHeaderView
        tableHeaderView!.setupView()
        tableHeaderView!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapSpecialOffers)))
        if checkIsShowLotteryBanner() {
            addHeaderToTableView()
        }
        extendedLayoutIncludesOpaqueBars = true
        
        tableView.register(UINib(nibName: MultyReceiptTableViewCell, bundle: nil), forCellReuseIdentifier: MultyReceiptTableViewCell)
        tableView.register(UINib(nibName: EmptyRececiptsTableViewCell, bundle: nil), forCellReuseIdentifier: EmptyRececiptsTableViewCell)
        tableView.backgroundColor = .zurich
        tableView.refreshControl = refreshControl
        tableView.alwaysBounceVertical = true
        
        
        addAnimationOnScanButton()
        
        
        scanButtonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToScan(_:))))
        loadData()
        
        observer = NotificationCenter.default.addObserver(forName: viewModel.getKeyNotificationName(), object: nil, queue: .main, using: { [weak weakSelf = self] (notification) in
            guard let qrcode = notification.object as? String else { return }
            ProgressHUD.show()
            weakSelf?.viewModel.displayResult(qrString: qrcode) {
                ProgressHUD.dismiss()
            }
        })
        
        observer = NotificationCenter.default.addObserver(forName: .categorySelectedForOfflineFilters, object: nil, queue: .main, using: { [weak self](notification) in
            print("categorySelectedForOfflineFilters in ")
            ProgressHUD.show()
            guard let viewModel = self?.viewModel, let self = self else { print("error viewModel nil"); return }
            viewModel.presentOffersByFilter()
            self.tableView.performBatchUpdates({
                self.tableView.reloadSections(IndexSet(integer: 1), with: .none)
            }, completion: nil)
            ProgressHUD.dismiss()
        })
        
        bindViewModel()
        RemoteCfg.shared.fetch()
        loadData(isForced: true)
    }
    
    private func bindViewModel() {
        RemoteCfg.shared.remoteCfgSubject.observeOn(MainScheduler.instance).subscribe(onNext: { [weak self] (isShowLottery) in
            guard let self = self else { return }
            self.setHeaderHidden(hide: !isShowLottery)
            if (isShowLottery) {
                self.tableHeaderView?.updateDate()
            }
        }).disposed(by: disposeBag)
    }
    
    private func checkIsShowLotteryBanner() -> Bool {
        return RemoteCfg.shared.isShowLottery()
    }
    
    deinit {
        guard let observer = observer else { return }
        NotificationCenter.default.removeObserver(observer)
    }
    
    @objc func goToScan(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            self?.scanButtonView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { [weak self] (_) in
            self?.scanButtonView.transform = .identity
            switch AVCaptureDevice.authorizationStatus(for: .video) {
                case .authorized: // The user has previously granted access to the camera.
                    DispatchQueue.main.async { [weak self] in
                        self?.viewModel.goOnScan()
                    }
                case .notDetermined: // The user has not yet been asked for camera access.
                    AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                        if granted {
                            DispatchQueue.main.async { [weak self] in
                                self?.viewModel.goOnScan()
                            }
                        } else {
                            DispatchQueue.main.async { [weak self] in
                                self?.showCameraAccess()
                            }
                        }
                    }
                case .denied: // The user has previously denied access.
                    self?.showCameraAccess()
                    return
                case .restricted: // The user can't grant access due to restrictions.
                    self?.showCameraAccess()
                    return
            default:
                self?.showCameraAccess()
                return
            }
        }
    }
    
    private func showCameraAccess() {
        let cameraAccessVC = CameraAccessVC.controllerFromStoryboard(.offlineCB)
        let transitionDelegate = SPStorkTransitioningDelegate()
        transitionDelegate.swipeToDismissEnabled = true
        transitionDelegate.tapAroundToDismissEnabled = true
        transitionDelegate.customHeight = 290 + view.safeAreaInsets.bottom
        cameraAccessVC.transitioningDelegate = transitionDelegate
        cameraAccessVC.modalPresentationStyle = .custom
        cameraAccessVC.modalPresentationCapturesStatusBarAppearance = true
        cameraAccessVC.delegate = self
        present(cameraAccessVC, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavigationBar()
        scanButtonView.backgroundColor = .sydney
        scanButtonView.cornerRadius = scanButtonView.frame.width / 2
        animationView.play()
        showFaqIfNeverShown()
    }
    
    func setUpNavigationBar() {
        setLargeTitleDisplayMode(.always)
        navigationController?.navigationBar.barTintColor = .zurich
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func addAnimationOnScanButton() {
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        scanButtonView.addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.topAnchor.constraint(equalTo: scanButtonView.topAnchor, constant: 10).isActive = true
        animationView.bottomAnchor.constraint(equalTo: scanButtonView.bottomAnchor, constant: -10).isActive = true
        animationView.leadingAnchor.constraint(equalTo: scanButtonView.leadingAnchor, constant: 10).isActive = true
        animationView.trailingAnchor.constraint(equalTo: scanButtonView.trailingAnchor, constant: -10).isActive = true
        view.layoutIfNeeded()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        scanButtonView.layer.removeAnimation(forKey: "hoverAnimation")
    }
    
    private func showFaqIfNeverShown() {
        if !Util.getOfflineFaqShown() {
            Util.setShownOfflineFaq()
            viewModel.showHelp(fromFaq: false)
        }
    }

    @objc private func didTapMultyScann() {
    }
    
    @objc private func didTapSpecialOffers() {
        viewModel.goToLanding()
    }
    
    @objc private func faqTapped(_ sender: Any) {
        viewModel.showHelp(fromFaq: true)
    }
    
    @objc private func specialTapped(_ sender: Any) {
        viewModel.goOnSpecial()
    }
    
    @objc private func refreshOffers(_ sender: Any) {
        loadData(isForced: true)
    }
    
    fileprivate func updateFilters() {
        if viewModel.filterHasBeenChanged() {
            guard let collectionView = tableView.viewWithTag(TAG_FILTER) as? UICollectionView else { return }
            collectionView.reloadData()
        }
    }
    
    private func loadData(isForced: Bool = false) {
        viewModel.displayOffers(isForced: isForced, completion: { [weak self] in
            self?.checkSpecialRightBarButton()
            self?.viewModel.presentOffersByFilter()
            self?.viewModel.displayCategories(isForced: isForced, completion: { [weak self] in
                self?.tableView.reloadData()
                self?.updateFilters()
                self?.refreshControl?.endRefreshing()
            }) { (errorCode) in
                self?.updateFilters()
                self?.refreshControl?.endRefreshing()
                Alert.showErrorToast(by: errorCode)
            }
        }) { [weak self] (errorCode) in
            self?.refreshControl?.endRefreshing()
            Alert.showErrorToast(by: errorCode)
        }
        
    }
    
    //MARK: - NavigationBar setup
    func setUpNavigationBarButton() {
        let faqButton = UIButton(type: .system)
        faqButton.setImage(UIImage(named: "infoReceipt")!.withRenderingMode(.alwaysOriginal), for: .normal)
        faqButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        faqButton.addTarget(self, action: #selector(faqTapped), for: .touchUpInside)
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: faqButton)]
        
        checkSpecialRightBarButton()
    }
    
    private func checkSpecialRightBarButton() {
        navigationItem.rightBarButtonItems?.removeAll(specialUIBarButtonItem)
        if viewModel.isActiveSpecialOffers() {
            navigationItem.rightBarButtonItems?.append(specialUIBarButtonItem)
        }
    }
        
    //MARK: - SearchBar setup
    func setupSearch() {
        let searchResultsController = storyboard!.instantiateViewController(withIdentifier: identifierOfSearchResultsOfflineVC) as! SearchResultsOfflineVC
        searchResultsController.viewModel = SearchOfflineViewModel(router: viewModel.getRouter(), offlineRepository: viewModel.getRepository())
        let searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.searchResultsUpdater = searchResultsController
        searchController.searchBar.delegate = searchResultsController
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.dimsBackgroundDuringPresentation = false
        
        self.definesPresentationContext = true
        let textFieldInsideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.placeholder = NSLocalizedString("Name of shop", comment: "")
        textFieldInsideSearchBar?.font = .medium15
        textFieldInsideSearchBar?.textColor = .sydney
        textFieldInsideSearchBar?.tintColor = .sydney
        searchController.dimsBackgroundDuringPresentation = false
        if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            if let backgroundview = textfield.subviews.first {
                backgroundview.backgroundColor = .clear
                backgroundview.layer.cornerRadius = 10
                backgroundview.clipsToBounds = true
            }
        }
        navigationItem.searchController = searchController
        
    }
    
    private func setHeaderHidden(hide: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let header = self?.tableHeaderView else { return }
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let self = self else { return }
                if (hide && self.tableView.tableHeaderView == nil) || (!hide && self.tableView.tableHeaderView != nil) {
                    return
                }
                self.tableView.beginUpdates()
                if hide {
                    self.tableView.tableHeaderView = nil
                } else {
                    self.addHeaderToTableView()
                }
                self.tableView.endUpdates()
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private func addHeaderToTableView() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tableView.tableHeaderView = self.tableHeaderView
            self.tableHeaderView!.translatesAutoresizingMaskIntoConstraints = false
            self.tableHeaderView!.topAnchor.constraint(equalTo: self.tableView.topAnchor).isActive = true
            self.tableHeaderView!.centerXAnchor.constraint(equalTo: self.tableView.centerXAnchor).isActive = true
            self.tableHeaderView!.leadingAnchor.constraint(equalTo: self.tableView.leadingAnchor).isActive = true
            self.tableHeaderView!.layoutIfNeeded()
        }
    }
}

//MARK: - TableViewDelegate setup
extension ReceiptsMainVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if viewModel.countOfFilters() > 0 {
                return 65
            } else { return 0 }
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: headerIdentifier, for: indexPath) as! ReceiptFilterHeaderViewCell
            cell.viewModel = viewModel.headerViewModel()
            cell.filterCollectionView.tag = TAG_FILTER
            return cell
        } else {
            if viewModel.numberOfItems() > 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: MultyReceiptTableViewCell, for: indexPath) as! MultyReceiptTableViewCell
                cell.viewModel = viewModel.cellViewModel(for: indexPath.row)
                cell.backgroundColor = .zurich
                return cell
            } else {
                let emptyTableViewCell = tableView.dequeueReusableCell(withIdentifier: EmptyRececiptsTableViewCell, for: indexPath) as? EmptyRececiptsTableViewCell
                guard let cell = emptyTableViewCell else { return UITableViewCell() }
                cell.isSelected = false
                return cell
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2) {
            if let cell = tableView.cellForRow(at: indexPath) as? MultyReceiptTableViewCell {
                cell.transform = .init(scaleX: 0.9, y: 0.9)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2) {
            if let cell = tableView.cellForRow(at: indexPath) as? MultyReceiptTableViewCell {
                cell.transform = .identity
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section > 0 {
            if let _ = tableView.cellForRow(at: indexPath) as? MultyReceiptTableViewCell {
                viewModel.goOnDetailPageForSelected(at: indexPath.row)
            }
        }
    }
    
}

extension ReceiptsMainVC: CameraAccessVCDelegate {
    func manualEnterClicked() {
        viewModel.enterManualy()
    }
}
