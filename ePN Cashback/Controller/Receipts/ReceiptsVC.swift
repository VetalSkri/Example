//
//  ReceiptsVC.swift
//  Backit
//
//  Created by Ivan Nikitin on 02/10/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit
import ProgressHUD

class ReceiptsVC: UITableViewController {

    
    var viewModel: SpecialReceiptsViewModel?
     
    private let SingleReceiptTableViewCell = "SingleReceiptTableViewCell"
    private var tableHeaderView: SpecialReceiptTableHeaderView!
    
    
    private var observer: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        extendedLayoutIncludesOpaqueBars = true
        self.refreshControl?.tintColor = .sydney
        self.refreshControl?.addTarget(self, action: #selector(refreshOffers(_:)), for: UIControl.Event.valueChanged)

        setUpNavigationBar()
        self.tableView.alwaysBounceVertical = true
        
        tableView.register(UINib(nibName: SingleReceiptTableViewCell, bundle: nil), forCellReuseIdentifier: SingleReceiptTableViewCell)
        tableView.backgroundColor = .zurich
        loadData()
        guard let viewModel = viewModel else { return }
        observer = NotificationCenter.default.addObserver(forName: viewModel.getKeyNotificationName(), object: nil, queue: .main, using: { (notification) in
            print("qrcode string after scan or manually enter ReceiptsVC")
            guard let qrcode = notification.object as? String else { return }
            print("qrcode is \(qrcode) ")
            ProgressHUD.show()
            viewModel.displayResult(qrString: qrcode) {
                ProgressHUD.dismiss()
            }
            
        })
    }
    
    deinit {
        guard let observer = observer else { return }
        NotificationCenter.default.removeObserver(observer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLargeTitleDisplayMode(.never)
        showFaqIfNeverShown()
    }
    
    private func showFaqIfNeverShown() {
        if !Util.getSpecialOfflineFaqShown() {
            Util.setSpecialShownOfflineFaq()
            viewModel?.showHelp(fromFaq: false)
        }
    }
    
    func setUpNavigationBar() {
        title = NSLocalizedString("SpecialReceiptLabel", comment: "")
        navigationController?.navigationItem.hidesSearchBarWhenScrolling = true
        
        navigationController?.navigationBar.barTintColor = .zurich
        navigationController?.navigationBar.isTranslucent = false
        
        let faqButton = UIButton(type: .system)
        faqButton.setImage(UIImage(named: "infoReceipt")!.withRenderingMode(.alwaysOriginal), for: .normal)
        faqButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        faqButton.addTarget(self, action: #selector(faqTapped), for: .touchUpInside)
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"back")!.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: faqButton)]
    }

    @objc private func didTapMultyScann() {
        
    }
    
    @objc private func faqTapped(_ sender: Any) {
        viewModel?.showHelp(fromFaq: true)
    }
    
    @objc private func refreshOffers(_ sender: Any) {
        loadData(isForced: true)
    }
    
    @objc func backButtonTapped() {
        viewModel?.goOnBack()
    }
    
    private func loadData(isForced: Bool = false) {
        viewModel?.displayOffers(isForced: isForced, completion: { [weak self] in
            self?.tableView.reloadData()
            self?.refreshControl?.endRefreshing()
        }) { (errorCode) in
            Alert.showErrorToast(by: errorCode)
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfSections(in: tableView, count: viewModel?.numberOfRowsInSection(section: section) ?? 0)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SingleReceiptTableViewCell, for: indexPath) as! SingleReceiptTableViewCell
        cell.viewModel = viewModel?.cellViewModel(for: indexPath.row)
        cell.delegate = self
        cell.backgroundColor = .zurich
        return cell
    }
    
    func numberOfSections(in tableView: UITableView, count numOfSections: Int) -> Int {
           if numOfSections > 0 {
               tableView.backgroundView = nil
           } else {
               let container: UIView = UIView(frame: CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.size.width, height: tableView.frame.size.height))
               container.backgroundColor = UIColor.zurich
               tableView.backgroundView = container
           }
           return numOfSections
       }
    
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2) {
            if let cell = tableView.cellForRow(at: indexPath) as? SingleReceiptTableViewCell {
                cell.transform = .init(scaleX: 0.9, y: 0.9)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2) {
            if let cell = tableView.cellForRow(at: indexPath) as? SingleReceiptTableViewCell {
                cell.transform = .identity
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let _ = tableView.cellForRow(at: indexPath) as? SingleReceiptTableViewCell {
            viewModel?.goOnDetailPageForSelected(at: indexPath.row)
        }
    }
}

extension ReceiptsVC: SingleReceiptCellDelegate {
    func scanButtonClicked(id: Int) {
        viewModel?.setIdOffer(id)
        viewModel?.goOnScan()
    }
}
