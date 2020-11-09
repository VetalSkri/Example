//
//  ClosedTicketsCollectionViewCell.swift
//  Backit
//
//  Created by Александр Кузьмин on 08/11/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

class ClosedTicketsCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: SupportVCDelegate?
    private let cellId = "ticketCellIdenfitier"
    private let skeletonCellId = "ticketSkeletonCellId"
    var viewModel: SupportViewModel!
    private var observer: NSObjectProtocol?
    private let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyContainerView: UIView!
    @IBOutlet weak var emptyMessageTextLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        subscribe()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        subscribe()
    }
    
    deinit {
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
        }
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupCell() {
        emptyContainerView.backgroundColor = .clear
        emptyMessageTextLabel.text = NSLocalizedString("No close tickets", comment: "")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .clear
        tableView.register(UINib(nibName: "TicketSkeletonTableViewCell", bundle: nil), forCellReuseIdentifier: skeletonCellId)
        tableView.register(UINib(nibName: "TicketTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
        tableView.alwaysBounceVertical = true
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 22))
        refreshControl.tintColor = .sydney
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    private func subscribe() {
        observer = NotificationCenter.default.addObserver(forName: Notification.Name("updateTickets"), object: nil, queue: nil) { [weak self] (notification) in
            self?.refreshControl.endRefreshing()
            self?.tableView.reloadData()
            print("MYLOG: call reload from closed cell")
        }
        NotificationCenter.default.addObserver(self, selector: #selector(changeLastMessage(notification:)), name: NSNotification.Name("successSendMessage"), object: nil)
    }
    
    @objc private func changeLastMessage(notification: NSNotification) {
        self.tableView.reloadData()
    }
    
    @objc func refresh(sender:AnyObject)
    {
        delegate?.refresh()
    }
    
}

extension ClosedTicketsCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = viewModel.isLoading ? 5 : viewModel.getTicketCount(for: .closed)
        //self.tableView.isHidden = (numberOfRows <= 0)
        self.emptyContainerView.isHidden = !(numberOfRows <= 0)
        return viewModel.isLoading ? 5 : viewModel.getTicketCount(for: .closed)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.getIsLoading() {
            let cell = tableView.dequeueReusableCell(withIdentifier: skeletonCellId, for: indexPath) as! TicketSkeletonTableViewCell
            cell.setupCell()
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TicketTableViewCell
        if let ticket = viewModel.getTicket(for: .closed, indexPath: indexPath) {
            cell.setupView(ticket: ticket)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectChat(indexPath: indexPath, isOpen: false)
    }
    
}
