//
//  ChatMessageTableViewCell.swift
//  Backit
//
//  Created by Александр Кузьмин on 05/12/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit
import Lightbox
import MediaPlayer
import AVKit

protocol ChatMessageTableViewCellDelegate: class {
    func resendButtonClicked(messageId: Int)
}

class ChatMessageTableViewCell: UITableViewCell, UIDocumentInteractionControllerDelegate {
    
    weak var delegate: ChatMessageTableViewCellDelegate?
    
    //Main container view fields
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerViewRightConstraint: NSLayoutConstraint!
    
    //Message label, multiline
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var messageTextViewTopConstraint: NSLayoutConstraint!
    
    
    //is read fields
    @IBOutlet weak var isReadImageView: UIImageView!
    @IBOutlet weak var readDateLabel: UILabel!
    @IBOutlet weak var isReadImageVIewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var isReadImageViewLeftConstraint: NSLayoutConstraint!
    
    //Indicator upload message to server
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    
    //Author of message
    @IBOutlet weak var authorLabel: UILabel!
    
    //TableView of attached files
    @IBOutlet weak var filesStackView: UIStackView!
    
    //Warning image view, when send message failure
    @IBOutlet weak var warningImageView: UIImageView!
    @IBOutlet weak var warningClickZoneView: UIView!
    
    
    
    private var message: SupportDialogAttributeMessage?
    private var processMessage: SupportMessage?
    private var dialogId: Int?
    
    private let fileCellId = "fileMessageCellId"
    private let fileCellHeight: CGFloat = 62
    private var fromMe = false
    private var isFirstLayout = true
    
    var viewModel: SupportChatViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        if isFirstLayout {
            isFirstLayout = false
            warningClickZoneView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(resendClicked(_:))))
        }
        super.layoutSubviews()
    }
    
    func setupCell(message: SupportDialogAttributeMessage, dialogId: Int) {
        self.message = message
        self.processMessage = nil
        self.dialogId = dialogId
        commonSetupCell(isUploadMessage: false, isMyMessage: !(message.userRole == "support" || message.userRole == "admin"), fullName: message.fullname, message: message.message, date: message.createdDate, messageId: message.id, isReaded: message.isRead)
        setupFiles(files: message.files)
    }
    
    func setupCell(messageInProcess: SupportMessage, dialogId: Int) {
        self.message = nil
        self.processMessage = messageInProcess
        self.dialogId = dialogId
        commonSetupCell(isUploadMessage: true, isMyMessage: true, fullName: "", message: messageInProcess.message, date: nil, messageId: messageInProcess.id, isReaded: false)
        setupFiles(files: messageInProcess.files)
    }
    
    private func commonSetupCell(isUploadMessage: Bool, isMyMessage: Bool, fullName: String, message: String, date: Date?, messageId: Int, isReaded: Bool) {
        fromMe = isMyMessage
        selectionStyle = .none
        backgroundColor = .clear
        
        containerView.cornerRadius = CommonStyle.newCornerRadius
        warningImageView.isHidden = true
        warningClickZoneView.isHidden = true
        loadIndicator.color = .minsk
        
        isReadImageView.image = isReaded ? UIImage(named: "readIcon") : UIImage(named: "unreadIcon")
        messageTextView.isSelectable = true
        if !fromMe {
            containerView.backgroundColor = .zurich
            messageTextView.textColor = .moscow
            containerViewLeftConstraint.constant = 16
            containerViewRightConstraint.constant = UIScreen.main.bounds.width / 7.5
            authorLabel.isHidden = false
            isReadImageView.isHidden = true
            isReadImageViewLeftConstraint.constant = 0
            isReadImageVIewWidthConstraint.constant = 0
            containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner]
            authorLabel.text = fullName
        } else {
            if isUploadMessage {
                if MessageHandler.shared.checkMessageInProcess(messageId: messageId) {
                    isReadImageView.isHidden = true
                    loadIndicator.startAnimating()
                } else {
                    loadIndicator.stopAnimating()
                    isReadImageView.isHidden = true
                    warningImageView.isHidden = false
                    warningClickZoneView.isHidden = false
                }
            } else {
                isReadImageView.isHidden = false
                loadIndicator.stopAnimating()
            }
            containerView.backgroundColor = .moscow
            messageTextView.textColor = .zurich
            containerViewLeftConstraint.constant = UIScreen.main.bounds.width / 5
            containerViewRightConstraint.constant = 16
            authorLabel.isHidden = true
            isReadImageViewLeftConstraint.constant = 13
            isReadImageVIewWidthConstraint.constant = 18
            containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner]
            authorLabel.text = ""
        }
        
        messageTextView.font = .medium15
        messageTextView.isEditable = false
        
        messageTextViewTopConstraint.constant = (message.count <= 0) ? -35 : 15
        messageTextView.text = message
        if message.count <= 0 {
            messageTextView.frame = CGRect(x: messageTextView.frame.origin.x, y: messageTextView.frame.origin.y, width: messageTextView.frame.size.width, height: 0)
        }
        
        
        authorLabel.font = .medium11
        authorLabel.textColor = .minsk
        
        readDateLabel.font = .medium11
        readDateLabel.textColor = .minsk
        if let messageDate = date {
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = .current
            dateFormatter.locale = .current
            dateFormatter.dateFormat = "HH:mm"
            readDateLabel.text = dateFormatter.string(from: messageDate)
        } else {
            readDateLabel.text = " "
        }
    }
    
    private func setupFiles(files: [SupportDialogAttributeMessageFile]?) {
        filesStackView.subviews.forEach( { $0.removeFromSuperview() } )
        guard let files = files else { return }
        files.forEach( {
            addFileSubviewToFilesStackView(image: $0)
        } )
    }
    
    private func setupFiles(files: [SupportMessageFile]?) {
        filesStackView.subviews.forEach( { $0.removeFromSuperview() } )
        guard let files = files else { return }
        files.forEach( {
            addFileSubviewToFilesStackView(image: $0)
        } )
    }
    
    private func addFileSubviewToFilesStackView(image: SupportDialogAttributeMessageFile) {
        let fileView = ChatFileView(viewModel: viewModel, image: image, fromMe: fromMe, chatId: dialogId ?? -2, messageId: message?.id ?? -2)
        filesStackView.addArrangedSubview(fileView)
        fileView.leadingAnchor.constraint(equalTo: fileView.leadingAnchor, constant: 0).isActive = true
        fileView.trailingAnchor.constraint(equalTo: fileView.trailingAnchor, constant: 0).isActive = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        tap.delegate = self
        fileView.addGestureRecognizer(tap)
        fileView.isUserInteractionEnabled = true
    }
    
    private func addFileSubviewToFilesStackView(image: SupportMessageFile) {
        let fileView = ChatFileView(viewModel: viewModel, image: image, fromMe: fromMe, chatId: dialogId ?? -2, messageId: message?.id ?? -2)
        filesStackView.addArrangedSubview(fileView)
        fileView.leadingAnchor.constraint(equalTo: fileView.leadingAnchor, constant: 0).isActive = true
        fileView.trailingAnchor.constraint(equalTo: fileView.trailingAnchor, constant: 0).isActive = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        tap.delegate = self
        fileView.addGestureRecognizer(tap)
        fileView.isUserInteractionEnabled = true
    }
    
    @objc private func handleTap(sender: Any) {
        if let senderGestureRecognizer = sender as? UITapGestureRecognizer, let fileView = senderGestureRecognizer.view as? ChatFileView {
            guard let image = fileView.image, let viewModel = viewModel else { return }
            let key = "\(dialogId ?? -1):\(message?.id ?? -1):\(image.id)"
            if !viewModel.checkFileIsAlredyLoad(key: key) && image.tempFileData == nil {
                if !viewModel.checkFileIsDownloading(key: key) || viewModel.checkFileIsFailed(key: key) {
                    print("MYLOG: file tap handler call!")
                    fileView.startLoad()
                    viewModel.downloadFile(key: key, path: image.file)
                }
                return
            }
            
            switch image.fileType() {
            case .image:
                showImage(for: key, fileView: fileView, imageId: image.file, tempData: image.tempFileData)
                break
            case .video:
                playVideo(for: key, fileView: fileView, imageId: image.file, fileExtension: image.name.fileExtension(), tempData: image.tempFileData)
                break
            case .file:
                showFile(for: key, fileView: fileView, imageId: image.file, fileExtension: image.name.fileExtension(), tempData: image.tempFileData)
                break
            }
        }
    }
    
    private func showImage(for key: String, fileView: ChatFileView, imageId: String, tempData: Data?) {
        if let tempData = tempData {
            OperationQueue.main.addOperation { [weak self] in
                let images = [
                    LightboxImage(
                        image: UIImage(data: tempData) ?? UIImage(),
                        text: ""
                    )
                ]
                let controller = LightboxController(images: images)
                controller.dynamicBackground = true
                controller.modalPresentationStyle = .fullScreen
                if let currentVC = self?.getCurrentViewController() {
                    currentVC.present(controller, animated: true, completion: nil)
                }
            }
            return
        }
        viewModel?.getFile(key: key) { (fileData) in
            OperationQueue.main.addOperation { [weak self] in
                guard let fileData = fileData else {
                    fileView.startLoad()
                    self?.viewModel?.downloadFile(key: key, path: imageId)
                    return
                }
                let images = [
                    LightboxImage(
                        image: UIImage(data: fileData) ?? UIImage(),
                        text: ""
                    )
                ]
                let controller = LightboxController(images: images)
                controller.dynamicBackground = true
                controller.modalPresentationStyle = .fullScreen
                if let currentVC = self?.getCurrentViewController() {
                    currentVC.present(controller, animated: true, completion: nil)
                }
            }
        }
    }
        
    private func playVideo(for key:String, fileView: ChatFileView, imageId: String, fileExtension: String, tempData: Data?) {
        if let tempData = tempData {
            OperationQueue.main.addOperation { [weak self] in
                guard let self = self else { return }
                let documentDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
                let fileURL = documentDirectory.appendingPathComponent("tempVideoToPlay").appendingPathExtension(fileExtension)
                do {
                    try tempData.write(to: fileURL)
                    let playerItem = AVPlayerItem(asset: AVAsset(url: fileURL))
                    let player = AVPlayer(playerItem: playerItem)
                    let playerViewController = AVPlayerViewController()
                    playerViewController.player = player
                    playerViewController.modalPresentationStyle = .fullScreen
                    if let currentVC = self.getCurrentViewController() {
                        currentVC.present(playerViewController, animated: true) {
                            playerViewController.player!.play()
                        }
                    }
                } catch { return }
            }
            return
        }
        viewModel?.getFile(key: key) { (fileData) in
            OperationQueue.main.addOperation { [weak self] in
                guard let fileData = fileData else {
                    fileView.startLoad()
                    self?.viewModel?.downloadFile(key: key, path: imageId)
                    return
                }
                guard let self = self else { return }
                let documentDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
                let fileURL = documentDirectory.appendingPathComponent("tempVideoToPlay").appendingPathExtension(fileExtension)
                do {
                    try fileData.write(to: fileURL)
                    let playerItem = AVPlayerItem(asset: AVAsset(url: fileURL))
                    let player = AVPlayer(playerItem: playerItem)
                    let playerViewController = AVPlayerViewController()
                    playerViewController.player = player
                    playerViewController.modalPresentationStyle = .fullScreen
                    if let currentVC = self.getCurrentViewController() {
                        currentVC.present(playerViewController, animated: true) {
                            playerViewController.player!.play()
                        }
                    }
                } catch { return }
            }
        }
    }
    
    private func showFile(for key: String, fileView: ChatFileView, imageId: String, fileExtension: String, tempData: Data?) {
        if let tempData = tempData {
            OperationQueue.main.addOperation { [weak self] in
                guard let self = self else { return }
                let documentDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
                let fileURL = documentDirectory.appendingPathComponent("tempFileToShow").appendingPathExtension(fileExtension)
                do {
                    try tempData.write(to: fileURL)
                    let documentInteractionController = UIDocumentInteractionController(url: fileURL)
                    documentInteractionController.delegate = self
                    documentInteractionController.presentPreview(animated: true)
                } catch { return }
            }
            return
        }
        viewModel?.getFile(key: key) { (fileData) in
            OperationQueue.main.addOperation { [weak self] in
                guard let fileData = fileData else {
                    fileView.startLoad()
                    self?.viewModel?.downloadFile(key: key, path: imageId)
                    return
                }
                guard let self = self else { return }
                let documentDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
                let fileURL = documentDirectory.appendingPathComponent("tempFileToShow").appendingPathExtension(fileExtension)
                do {
                    try fileData.write(to: fileURL)
                    let documentInteractionController = UIDocumentInteractionController(url: fileURL)
                    documentInteractionController.delegate = self
                    documentInteractionController.presentPreview(animated: true)
                } catch { return }
            }
        }
    }
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self.getCurrentViewController()!
    }
    
    private func getCurrentViewController() -> UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    @objc func resendClicked(_ sender: Any) {
        guard let processMessage = self.processMessage else { return }
        delegate?.resendButtonClicked(messageId: processMessage.id)
    }
    
}
