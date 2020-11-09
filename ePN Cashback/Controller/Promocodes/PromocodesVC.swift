//
//  PromocodesVC.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 28/03/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit
import ProgressHUD

class PromocodesVC: UIViewController/*, ActivatePromocodeDelegate*/ {
    
    @IBOutlet weak var tableView: UITableView!
    private var isFirstLayout = true
    var viewModel: PromocodesModelType!
    private var tableHeaderView: PromoTableHeaderView!
    @IBOutlet weak var indicatorOfBottomPaging: UIActivityIndicatorView!
    
    private let identifierOfPromocodeCell = "promocodeCell"
    private let identifierOfPromocodeHeader = "promocodeHeaderCell"

    private var observer: NSObjectProtocol?
    private var refreshControl: UIRefreshControl!
//    private var inputViewPromocode = EPNInputView()
    private let infoLabel = UILabel()
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var titleHeaderLabel: UILabel!
    @IBOutlet weak var subtitleHeaderLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ///Send event to analytic about open Promocode
        Analytics.promocodesEventPressed()
        
        refreshControl = UIRefreshControl()
        self.indicatorOfBottomPaging.isHidden = true
        
        refreshControl.tintColor = .zurich
        refreshControl.backgroundColor = .calgary
        refreshControl.addTarget(self, action:
            #selector(refreshPromocodes(_:)),
                                 for: UIControl.Event.valueChanged)
        
        
        setUpNavigationBar()
        tableView.keyboardDismissMode = .onDrag
        tableView.sectionIndexBackgroundColor = .clear
        tableView.backgroundColor = .zurich
        tableView.addSubview(refreshControl)
        ProgressHUD.show()
        if (viewModel.cacheLifeTimeIsExpired()) {
            loadPromocodes()
        }
        observer = NotificationCenter.default.addObserver(forName: .promocodeIsActivated, object: nil, queue: .main, using: { [weak weakSelf = self] (newPromocode) in
            print("promocode has been activated")
            let promocode = newPromocode.object as? PromocodeActivateInfo
            weakSelf?.viewModel.activateNewPromocode(promocode)
            weakSelf?.tableView.reloadData()
        })
    }
    
    override func viewDidLayoutSubviews() {
        if isFirstLayout {
            isFirstLayout = false
            setupView()
        }
    }
    
    deinit {
        guard let observer = observer else { return }
        NotificationCenter.default.removeObserver(observer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshControl.endRefreshing()
        viewModel.goOnShowActivatePromocodeResult()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ProgressHUD.dismiss()
        refreshControl.endRefreshing()
    }
    
    func setUpNavigationBar() {
        navigationController?.navigationBar.barTintColor = .clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.isTranslucent = true
        
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "backNavBar")!.withRenderingMode(.alwaysOriginal), for: .normal)
        backButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    private func setupView() {
        
        titleHeaderLabel.font = .bold17
        titleHeaderLabel.textColor = .zurich
        titleHeaderLabel.text = NSLocalizedString("Promocodes", comment: "")
        subtitleHeaderLabel.font = .medium15
        subtitleHeaderLabel.textColor = .zurich
        subtitleHeaderLabel.text = NSLocalizedString("CheckInfoAboutPromo", comment: "")
        
        self.view.backgroundColor = .zurich
        self.tableView.backgroundColor = .zurich
        tableHeaderView = UINib(nibName: "PromoTableHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? PromoTableHeaderView
        tableHeaderView.setupView(title: viewModel.infoText, placeholder: viewModel.getPlaceholderText, checkButtonTitle: viewModel.buttonText)
        tableHeaderView.translatesAutoresizingMaskIntoConstraints = false
        self.tableHeaderView.layoutSubviews()
        tableView.tableHeaderView = tableHeaderView
        tableView.tableHeaderView?.layoutIfNeeded()
        tableHeaderView.centerXAnchor.constraint(equalTo: self.tableView.centerXAnchor).isActive = true
        tableHeaderView.widthAnchor.constraint(equalTo: self.tableView.widthAnchor).isActive = true
        tableHeaderView.topAnchor.constraint(equalTo: self.tableView.topAnchor).isActive = true
        tableHeaderView.layoutIfNeeded()
        tableView.tableHeaderView = tableHeaderView
        headerView.backgroundColor = .calgary
        tableHeaderView.delegate = self
        
        var frame = tableView.bounds
        frame.origin.y = -frame.size.height
        let backgroundView = UIView(frame: frame)
        backgroundView.autoresizingMask = .flexibleWidth
        backgroundView.backgroundColor = .calgary
        tableView.insertSubview(backgroundView, at: 0)
    }
    
    @objc func backButtonTapped() {
        viewModel.goOnBack()
    }
    
    @objc private func refreshPromocodes(_ sender: Any) {
        loadPromocodes()
    }
    
    func loadPromocodes() {
        viewModel.loadListOfPromocodes(completion: { [weak self] in
            OperationQueue.main.addOperation { [weak self] in
                ProgressHUD.dismiss()
                self?.refreshControl.endRefreshing()
                self?.tableView.reloadData()
            }
            }, failure: { [weak self] () in
                ProgressHUD.dismiss()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                    self?.refreshControl.endRefreshing()
                }
        })
    }
    
}


extension PromocodesVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfSections(in: tableView, count: viewModel.numberOfItemsInSection(section: section))
    }
    
    func numberOfSections(in tableView: UITableView, count numOfRows: Int) -> Int {
        if numOfRows > 0 {
            tableView.backgroundView = nil
        } else {
            setupContainer(in: tableView)
        }
        return numOfRows
    }
    
    func setupContainer(in v: UITableView) {
        let container: UIView = UIView(frame: CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.size.width, height: tableView.frame.size.height))
        container.backgroundColor = .zurich
        let imageView: UIImageView = UIImageView()
        let textLabel: EPNLabel = EPNLabel(style: .helperText)
        imageView.image = UIImage(named: "zeroInterface")
        imageView.contentMode = .scaleAspectFit
        container.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1.0).isActive = true
        imageView.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        
        textLabel.text = viewModel.getTextForEmptyPromocodes
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .center
        container.addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        textLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
        textLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 30).isActive = true
        textLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -30).isActive = true
        tableView.backgroundView = container
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifierOfPromocodeCell, for: indexPath) as! PromocodeViewCell
        cell.viewModel = viewModel.cellViewModel(index: indexPath.row)
        if viewModel.isPagingPromocodes(atIndexPath: indexPath) {
            DispatchQueue.main.async {
                self.indicatorOfBottomPaging.isHidden = false
                self.indicatorOfBottomPaging.startAnimating()
            }
            viewModel.pagingListOfPromocodes(completion: { [weak self] in
                OperationQueue.main.addOperation { [weak self] in
                    self?.indicatorOfBottomPaging.isHidden = true
                    self?.indicatorOfBottomPaging.stopAnimating()
                    self?.tableView.reloadData()
                }
                }, failure: { [weak self] () in
                    OperationQueue.main.addOperation { [weak self] in
                        self?.indicatorOfBottomPaging.isHidden = true
                        self?.indicatorOfBottomPaging.stopAnimating()
                    }
            })
            
        }
        
        return cell
    }
    
}

extension PromocodesVC: PromoTableHeaderViewDelegate {
    
    func checkButtonWasClicked(withPromo: String) {
        tableHeaderView.setNotFountVisibility(isHidden: true, message: "")
        tableHeaderView.layoutIfNeeded()
        tableHeaderView.makeButtonEnabled(isEnable: false)
        ProgressHUD.show()
        viewModel.setPromocode(promocode: withPromo.trimmingCharacters(in: .whitespaces))
        viewModel.checkPromocode(completion: { [weak self] in
            ProgressHUD.dismiss()
            OperationQueue.main.addOperation { [weak self] in
                self?.tableHeaderView.makeButtonEnabled(isEnable: true)
                self?.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
                if let self = self {
                    self.viewModel.goOnCheckPromocode()
                }
            }
            }, failure: { [weak self] (errorString) in
                ProgressHUD.dismiss()
                OperationQueue.main.addOperation { [weak self] in
                    guard let self = self else { return }
                    self.tableHeaderView.makeButtonEnabled(isEnable: true)
                    self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
                    if let errorString = errorString {
                        self.tableHeaderView.setNotFountVisibility(isHidden: false, message: errorString)
                        self.tableHeaderView.layoutIfNeeded()
                    }
                }
        })
    }
    
}
