//
//  SelectTicketTypeVC.swift
//  Backit
//
//  Created by Александр Кузьмин on 11/11/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit
import TransitionButton
import Skeleton

class SelectTicketTypeVC: UIViewController {

    var viewModel: SelectTicketTypeViewModel!
    private let cellId = "ticketTypeCellId"
    private let skeletonCellId = "tiicketSkeletonCellId"
    private let refreshControl = UIRefreshControl()
    
    //TableView
    @IBOutlet weak var tableView: UITableView!
    
    //StartDialogue
    @IBOutlet weak var startDialogueContainerView: UIView!
    var startDialogueButton = EPNButton(style: .primary, size: .large1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupConstraints()
        setupNavigationBar()
        
        refreshControl.tintColor = .sydney
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.alwaysBounceVertical = true
        tableView.backgroundColor = .zurich
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 20))
        
        view.backgroundColor = .zurich
        
        startDialogueButton.handler = {[weak self] button in
            self?.startDialogueButtonClicked()
        }
        
        setupView()
        
        loadTickets()
    }
        
    private func setupSubviews() {
        startDialogueContainerView.addSubview(startDialogueButton)
    }
    
    private func setupConstraints() {
        startDialogueContainerView.snp.makeConstraints { (make) in
            make.top.equalTo(tableView.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(16)
        }
        startDialogueButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(10)
            make.left.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
            make.height.equalTo(0)
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
    
    @objc func refresh(sender:AnyObject)
    {
        refreshControl.beginRefreshing()
        loadTickets()
    }
    
    private func loadTickets() {
        viewModel.loadTopics { [weak self] (isSuccess) in
            self?.tableView.reloadData()
            self?.refreshControl.endRefreshing()
        }
        tableView.reloadData()
    }
    
    private func setupView() {
        startDialogueButton.text = NSLocalizedString("Start a dialogue", comment: "")
    }
    
    private func startDialogueButtonClicked()
    {
        startDialogueButton.getTransionButton.startAnimation()
        viewModel.startDialogue { [weak self] (success) in
            if !success {
                self?.startDialogueButton.getTransionButton.stopAnimation(animationStyle: .shake, revertAfterDelay: 0.3, completion: nil)
            } else {
                self?.startDialogueButton.getTransionButton.stopAnimation()
            }
        }
    }
    
    private func showDialogueButton() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: { [weak self] in
            self?.startDialogueButton.snp.remakeConstraints({ (make) in
                make.height.equalTo(50)
                make.top.equalToSuperview().inset(10)
                make.left.equalToSuperview().inset(16)
                make.right.equalToSuperview().inset(16)
                make.bottom.equalToSuperview()
                
            })
            self?.view.layoutIfNeeded()
            }, completion: nil)
    }
    
}

extension SelectTicketTypeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.typesCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.showSkeleton() {
            let cell = tableView.dequeueReusableCell(withIdentifier: skeletonCellId, for: indexPath) as! SupportTicketSkeletonCell
            cell.setupCell()
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TicketTypeTableViewCell
        if let topic = viewModel.topic(for: indexPath) {
            cell.setupCell(type: topic, isSelected: viewModel.selectedRow ?? -1 == indexPath.row)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewModel.showSkeleton() { return }
        var indexPaths = [IndexPath]()
        if let selectedRow = viewModel.selectedRow {
            if selectedRow == indexPath.row {
                return
            }
            indexPaths.append(IndexPath(row: selectedRow, section: 0))
        } else {
            showDialogueButton()
        }
        indexPaths.append(indexPath)
        viewModel.selectedRow = indexPath.row
        tableView.reloadRows(at: indexPaths, with: .automatic)
    }
}
