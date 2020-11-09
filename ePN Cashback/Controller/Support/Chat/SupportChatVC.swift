//
//  SupportChatVC.swift
//  Backit
//
//  Created by Александр Кузьмин on 12/11/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit
import ReverseExtension
import Photos
import Differ

class SupportChatVC: UIViewController {
    
    private enum Images {
        static let trashIcon = UIImage(named: "TrashIcon")
    }
    
    var viewModel: SupportChatViewModel!
    
    //Text input fields
    @IBOutlet weak var textInputContainerView: UIView!
    @IBOutlet weak var attachFileButton: UIButton!
    @IBOutlet weak var sendMessageButton: UIButton!
    @IBOutlet weak var textField: GrowingTextView!
    @IBOutlet weak var textInputContainerViewBottomConstraint: NSLayoutConstraint!
    
    //tableView
    @IBOutlet weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    
    private let messageCellId = "chatMessageCellId"
    private let skeletonCellId = "skeletonChatCellId"
    private let sectionCellId = "sectionCellId"
    
    
    deinit {
        unsubscribeNotificationCenter()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .paris
        
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "SkeletonChatMessageTableViewCell", bundle: nil), forCellReuseIdentifier: skeletonCellId)
        tableView.backgroundColor = .paris
        tableView.rowHeight = UITableView.automaticDimension
        
        refreshControl.tintColor = .sydney
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
        tableView.re.delegate = self
        tableView.dataSource = self
        
        setupNavigationBar()
        setupView()
        subscribeNotificationCenter()
        
        loadMessages()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tableView.addGestureRecognizer(tap)
        
        applySendButtonEnable()
    }
    
    private func setupNavigationBar() {
        title = viewModel.title
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .zurich
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.sydney , NSAttributedString.Key.font : UIFont.semibold17]
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(backButtonClicked))
        
        if viewModel.shouldShowCloseDialogButton {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: Images.trashIcon, style: .plain, target: self, action: #selector(self.onDeleteButtonTouchUpInside(sender:)))
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.sydney
        }
    }
    
    @objc func refresh(sender:AnyObject)
    {
        loadMessages()
    }
    
    @objc func backButtonClicked() {
        viewModel.back()
        view.backgroundColor = .paris
        
        tableView.backgroundColor = .paris
        
        textInputContainerView.backgroundColor = .zurich
        textInputContainerView.cornerRadius = 5
        textInputContainerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    }
    
    @objc func onDeleteButtonTouchUpInside(sender: Any) {
        viewModel.showCloseChatAlert()
    }
    
    private func setupView() {
        textField.maxHeight = 150
        textField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("Enter your message", comment: ""), attributes: [NSAttributedString.Key.font : UIFont.medium15, NSAttributedString.Key.foregroundColor : UIColor.minsk])
        textField.font = .medium15
        textField.textColor = .moscow
        textField.delegate = self
    }
    
    @IBAction func attachFileButtonClicked(_ sender: Any) {
        let alert = UIAlertController(style: .actionSheet)
        alert.addTelegramPicker { result in
            switch result {
            case .photo(let assets):
                if assets.count <= 0  { return }
                DispatchQueue.global(qos: .background).async { [weak self] in
                    var files = [SupportMessageFile]()
                    for asset in assets {
                        let imageManager = PHImageManager.default()
                        let requestOptions = PHImageRequestOptions()
                        requestOptions.isSynchronous = true
                        requestOptions.deliveryMode = .highQualityFormat
                        requestOptions.resizeMode = .exact
                        requestOptions.isNetworkAccessAllowed = false
                        let videoRequestOptions = PHVideoRequestOptions()
                        videoRequestOptions.deliveryMode = .automatic
                        videoRequestOptions.isNetworkAccessAllowed = false
                        switch asset.mediaType {
                        case .video:
                            let semaphore = DispatchSemaphore(value: 0)
                            imageManager.requestAVAsset(forVideo: asset, options: videoRequestOptions) { (videoAsset, audioMix, info) in
                                guard let videoAsset = videoAsset as? AVURLAsset, let videoData = try? Data(contentsOf: videoAsset.url) else {
                                    semaphore.signal()
                                    return
                                }
                                var fileName: String? = nil
                                var fileExtension: String? = nil
                                if let info = info {
                                    if info.keys.contains(NSString(string: "PHImageFileURLKey")) {
                                        if let path = info[NSString(string: "PHImageFileURLKey")] as? NSURL {
                                            fileName = path.lastPathComponent
                                            fileExtension = path.pathExtension
                                        }
                                    }
                                }
                                if fileName == nil {
                                    fileName = asset.value(forKey: "filename") as? String
                                }
                                let file = SupportMessageFile(id: -1, file: videoData, fileName: fileName ?? "video.MOV", fileExtension: fileExtension ?? "MOV", messageId: -1, link: nil, size: Float(Double(videoData.count)/(1024.0*1024.0)))
                                files.append(file)
                                semaphore.signal()
                            }
                            _ = semaphore.wait(timeout: DispatchTime.distantFuture)
                            break
                        default:
                            imageManager.requestImageData(for: asset, options: requestOptions) { (imageData, text, orientation, info) in
                                guard let imageData = imageData else { return }
                                var fileName: String? = nil
                                var fileExtension: String? = nil
                                if let info = info {
                                    if info.keys.contains(NSString(string: "PHImageFileURLKey")) {
                                        if let path = info[NSString(string: "PHImageFileURLKey")] as? NSURL {
                                            fileName = path.lastPathComponent
                                            fileExtension = path.pathExtension
                                        }
                                    }
                                }
                                if fileName == nil {
                                    fileName = asset.value(forKey: "filename") as? String
                                }
                                let file = SupportMessageFile(id: -1, file: imageData, fileName: fileName ?? "image.JPG", fileExtension: fileExtension ?? "JPG", messageId: -1, link: nil, size: Float(Double(imageData.count)/(1024.0*1024.0)))
                                files.append(file)
                            }
                        }
                        
                    }
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        let diff = self.viewModel.sendMessage(message: "", files: files)
                        self.tableView.apply(diff)
                    }
                }
                break
            }
        }
        if UIDevice.current.userInterfaceIdiom == .pad {
            alert.popoverPresentationController?.sourceView = self.view
            alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.maxY, width: 0, height: 0)
        }
        alert.addAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func sendMessageButtonClicked(_ sender: Any) {
        if viewModel.sendButtonDisabled { return }
        let diff = viewModel.sendMessage(message: textField.text)
        tableView.apply(diff)
        textField.text = ""
        applySendButtonEnable()
    }
    
    private func applySendButtonEnable() {
        sendMessageButton.alpha = textField.text.isEmpty ? 0.5 : 1.0
        sendMessageButton.isEnabled = !textField.text.isEmpty
    }
    
    private func loadMessages() {
        if viewModel.getDialogId() <= 0 { return }
        viewModel.loadMessages { [weak self] (isSuccess) in
            self?.refreshControl.endRefreshing()
            self?.tableView.reloadData()
        }
        tableView.reloadData()
    }
    
}





extension SupportChatVC: GrowingTextViewDelegate {
    
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        applySendButtonEnable()
    }
    
}



extension SupportChatVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.isShowSkelenot() {
            let cell = tableView.dequeueReusableCell(withIdentifier: skeletonCellId, for: indexPath) as! SkeletonChatMessageTableViewCell
            cell.setupCell(row: indexPath.row)
            return cell
        }
        let decoratedObject = viewModel.message(forIndexPath: indexPath)
        if let text = decoratedObject.2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: sectionCellId, for: indexPath) as! ChatSectionTableViewCell
            cell.setupCell(text: text)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: messageCellId, for: indexPath) as! ChatMessageTableViewCell
        cell.viewModel = self.viewModel
        let messagesContainer = viewModel.message(forIndexPath: indexPath)
        if let message = messagesContainer.0 {
            cell.setupCell(message: message, dialogId: viewModel.getDialogId())
        }
        else if let messageInProcess = messagesContainer.1 {
            cell.setupCell(messageInProcess: messageInProcess, dialogId: viewModel.getDialogId())
            cell.delegate = self
        }
        return cell
    }
    
}




//Keyboard delegate
extension SupportChatVC {
    
    private func subscribeNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.messageUpdate(_:)), name: NSNotification.Name("SupportMessageStatusNotification"), object: nil)
    }
    
    private func unsubscribeNotificationCenter() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        print("MYLOG: keyboard will show call")
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if endFrameY >= UIScreen.main.bounds.size.height {
                self.textInputContainerViewBottomConstraint?.constant = 0.0
            } else {
                let offset =  -(endFrame?.size.height ?? 0 * -1) + self.view.safeAreaInsets.bottom
                self.textInputContainerViewBottomConstraint?.constant = -offset
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: {
                            self.view.layoutIfNeeded()
            },
                           completion: nil)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        print("MYLOG: keyboard will hide call")
        if let userInfo = notification.userInfo {
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            self.textInputContainerViewBottomConstraint?.constant = 0
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: {
                            self.view.layoutIfNeeded()
            },
                           completion: nil)
        }
    }
    
    @objc func messageUpdate(_ notification: NSNotification) {
        if let dict = notification.userInfo as NSDictionary? {
            if let isSuccess = dict["isSuccess"] as? Bool, let messageId = dict["messageId"] as? Int {
                if !isSuccess {
                    if let indexPath = viewModel.getIndexPathOfProcessMessage(messageId: messageId) {
                        OperationQueue.main.addOperation { [weak self] in
                            self?.tableView.reloadRows(at: [indexPath], with: .automatic)
                        }
                    }
                } else {
                    if let dialogId = dict["dialogId"] as? Int {
                        let isNewTicket = viewModel.getDialogId() <= 0
                        viewModel.successSendMessage(messageId: messageId, dialogId: dialogId)
                        if isNewTicket {
                            self.loadMessages()
                        }
                        OperationQueue.main.addOperation { [weak self] in
                            self?.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
}

extension SupportChatVC: ChatMessageTableViewCellDelegate {
    
    func resendButtonClicked(messageId: Int) {
        if !viewModel.checkMessageIsFailure(messageId: messageId) { return }
        let failureMessageActionSheet =  UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        failureMessageActionSheet.addAction(UIAlertAction(title: NSLocalizedString("Resend", comment: ""), style: .default, handler: { [weak self] (action) in
            if let indexPath = self?.viewModel.resendMessage(messageId: messageId) {
                self?.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            
        }))
        failureMessageActionSheet.addAction(UIAlertAction(title: NSLocalizedString("Delete", comment: ""), style: .destructive, handler: { [weak self] (action) in
            if let diff = self?.viewModel.deleteMessage(messageId: messageId) {
                self?.tableView.apply(diff)
            }
        }))
        failureMessageActionSheet.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
        self.present(failureMessageActionSheet, animated: true, completion: nil)
    }
    
}
