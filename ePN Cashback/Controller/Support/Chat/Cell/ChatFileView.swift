//
//  ChatFileView.swift
//  Backit
//
//  Created by Александр Кузьмин on 10/12/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit
import MediaPlayer

class ChatFileView: UIView {
    
    private var fromMe: Bool
    var image: SupportDialogAttributeMessageFile?
    var uploadingImage: SupportMessageFile?
    private let progressView = RingProgressView(frame: .zero)
    private let shadowView = UIView()
    private let refreshImageView = UIImageView(image: UIImage(named: "refresh"))
    private var chatId: Int = -1
    private var messageId: Int = -1
    private let fileIconImageView = UIImageView()
    
    private var viewModel: SupportChatViewModel?
    
    struct UI {
        static let iconImageViewSize: CGFloat = 42
        static let progressRingWidth: CGFloat = 4
        static let refreshImageViewSize: CGFloat = 20
    }
    
    init(viewModel: SupportChatViewModel?, image: SupportDialogAttributeMessageFile, fromMe: Bool,  chatId: Int, messageId: Int) {
        self.fromMe = fromMe
        self.image = image
        self.viewModel = viewModel
        super.init(frame: .zero)
        subscribe()
        self.addCustomView(icon: icon(image: image, hasFileInCache: (LruFileCache.shared.exist(forKey: "\(chatId):\(messageId):\(image.id)")) || image.tempFileData != nil), name: image.name, chatId: chatId, messageId: messageId)
    }
    
    init(viewModel: SupportChatViewModel?, image: SupportMessageFile, fromMe: Bool, chatId: Int, messageId: Int) {
        self.fromMe = fromMe
        self.uploadingImage = image
        self.viewModel = viewModel
        super.init(frame: .zero)
        subscribe()
        self.addCustomView(icon: icon(image: image), name: image.fileName, chatId: chatId, messageId: messageId)
    }
    
    override private init(frame: CGRect) {
        fromMe = false
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        unsubscribe()
    }
    
    func addCustomView(icon: UIImage?, name: String, chatId: Int, messageId: Int) {
        self.chatId = chatId
        self.messageId = messageId
        
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        
        fileIconImageView.translatesAutoresizingMaskIntoConstraints = false
        fileIconImageView.heightAnchor.constraint(equalToConstant: UI.iconImageViewSize).isActive = true
        fileIconImageView.widthAnchor.constraint(equalToConstant: UI.iconImageViewSize).isActive = true
        fileIconImageView.image = icon
        addSubview(fileIconImageView)
        fileIconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        fileIconImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        fileIconImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        
        progressView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(progressView)
        progressView.heightAnchor.constraint(equalToConstant: UI.iconImageViewSize).isActive = true
        progressView.widthAnchor.constraint(equalToConstant: UI.iconImageViewSize).isActive = true
        progressView.centerXAnchor.constraint(equalTo: fileIconImageView.centerXAnchor, constant: 0).isActive = true
        progressView.centerYAnchor.constraint(equalTo: fileIconImageView.centerYAnchor, constant: 0).isActive = true
        progressView.startColor = .budapest
        progressView.endColor = .budapest
        progressView.backgroundColor = .clear
        progressView.backgroundRingColor = .white
        progressView.ringWidth = UI.progressRingWidth
        progressView.progress = 0.0
        progressView.mkShadowOpacity = 0.0
        progressView.style = .square
        
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(shadowView)
        shadowView.centerXAnchor.constraint(equalTo: fileIconImageView.centerXAnchor).isActive = true
        shadowView.centerYAnchor.constraint(equalTo: fileIconImageView.centerYAnchor).isActive = true
        shadowView.widthAnchor.constraint(equalToConstant: (UI.iconImageViewSize - (UI.progressRingWidth*2))).isActive = true
        shadowView.heightAnchor.constraint(equalToConstant: (UI.iconImageViewSize - (UI.progressRingWidth*2))).isActive = true
        shadowView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        shadowView.cornerRadius = (UI.iconImageViewSize - (UI.progressRingWidth*2))/2
        shadowView.isHidden = true
        
        refreshImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(refreshImageView)
        refreshImageView.contentMode = .scaleAspectFit
        refreshImageView.centerXAnchor.constraint(equalTo: fileIconImageView.centerXAnchor).isActive = true
        refreshImageView.centerYAnchor.constraint(equalTo: fileIconImageView.centerYAnchor).isActive = true
        refreshImageView.widthAnchor.constraint(equalToConstant: UI.refreshImageViewSize).isActive = true
        refreshImageView.heightAnchor.constraint(equalToConstant: UI.refreshImageViewSize).isActive = true
        
        
        //Setup actual progress for file
        let key = "\(chatId):\(messageId):\(image?.id ?? -1)"
        if uploadingImage != nil {
            setLoadVisibilityState(isHidden: false)
            progressView.progress = MessageFileHandler.shared.progress(fileId: uploadingImage!.id)
        } else if (viewModel?.checkFileIsDownloading(key: key) ?? false) {
            if viewModel?.checkFileIsFailed(key: key) ?? false {
                showRefresh()
            } else {
                setLoadVisibilityState(isHidden: false)
                progressView.progress = viewModel?.progress(for: key) ?? 0.0
            }
        }
        else {
            setLoadVisibilityState(isHidden: true)
            progressView.progress = 0.0
        }
        
        let fileName = UILabel()
        fileName.translatesAutoresizingMaskIntoConstraints = false
        fileName.font = .medium15
        fileName.textColor = fromMe ? .zurich : .moscow
        fileName.numberOfLines = 2
        fileName.text = name
        addSubview(fileName)
        fileName.centerYAnchor.constraint(equalTo: fileIconImageView.centerYAnchor).isActive = true
        fileName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        fileName.leadingAnchor.constraint(equalTo: fileIconImageView.trailingAnchor, constant: 13).isActive = true
    }
    
    private func icon(image: SupportDialogAttributeMessageFile, hasFileInCache: Bool) -> UIImage? {
        switch image.fileType() {
        case .file:
            return hasFileInCache ? UIImage(named: "attachFileIcon") : fromMe ? UIImage(named: "myFile_unload") : UIImage(named: "file_unload")
        case .image:
            return hasFileInCache ? UIImage(named: "attachPhotoIcon") : fromMe ? UIImage(named: "myImage_unload") : UIImage(named: "image_unload")
        case .video:
            return hasFileInCache ? UIImage(named: "attachVideoIcon") : fromMe ? UIImage(named: "myVideo_unload") : UIImage(named: "video_unload")
        }
    }
    
    private func icon(image: SupportMessageFile) -> UIImage? {
        switch image.fileType() {
        case .file:
            return fromMe ? UIImage(named: "myFile_unload") : UIImage(named: "file_unload")
        case .image:
            return fromMe ? UIImage(named: "myImage_unload") : UIImage(named: "image_unload")
        case .video:
            return fromMe ? UIImage(named: "myVideo_unload") : UIImage(named: "video_unload")
        }
    }
    
    func startLoad() {
        setLoadVisibilityState(isHidden: false)
    }
    
    private func subscribe() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeProgress(_:)), name: NSNotification.Name("SupportFileStatusNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeDownloadProgress(_:)), name: NSNotification.Name("downloadStateForSupportFile"), object: nil)
    }
    
    private func unsubscribe() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func changeProgress(_ notification: NSNotification) {
        if let dict = notification.userInfo as NSDictionary? {
            if let fileId = dict["fileId"] as? Int, fileId == self.uploadingImage?.id ?? -2 {
                if let isSuccess = dict["success"] as? Bool {
                    
                }
                if let progress = dict["progress"] as? Double {
                    DispatchQueue.main.async { [weak self] in
                        UIView.animate(withDuration: 0.2) { [weak self] in
                            self?.progressView.progress = progress
                        }
                    }
                }
            }
        }
    }
    
    @objc func changeDownloadProgress(_ notification: NSNotification) {
        if let dict = notification.userInfo as NSDictionary? {
            let fileKey = "\(chatId):\(messageId):\(image?.id ?? -1)"
            if let key = dict["key"] as? String, key == fileKey {
                if let success = dict["success"] as? Bool {
                    if success {
                            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                                self?.progressView.progress = 1.0
                            })
                            { [weak self] (completed) in
                                self?.setLoadVisibilityState(isHidden: true)
                                guard let self = self, let image = self.image else { return }
                                self.fileIconImageView.image = self.icon(image: image, hasFileInCache: LruFileCache.shared.exist(forKey: "\(self.chatId):\(self.messageId):\(image.id)"))
                                self.view.layoutIfNeeded()
                            }
                    }
                    else {
                        showRefresh()
                    }
                }
                else if let progress = dict["progress"] as? Double {
                    print("MYLOG: get download progress: \(progress)")
                    UIView.animate(withDuration: 0.2) { [weak self] in
                        self?.progressView.progress = progress
                    }
                }
            }
        }
    }
    
    private func setLoadVisibilityState(isHidden: Bool) {
        OperationQueue.main.addOperation { [weak self] in
            self?.shadowView.isHidden = isHidden
            self?.progressView.isHidden = isHidden
            self?.refreshImageView.isHidden = true
        }
    }
    
    private func showRefresh() {
        OperationQueue.main.addOperation { [weak self] in
            self?.shadowView.isHidden = false
            self?.progressView.isHidden = true
            self?.refreshImageView.isHidden = false
        }
    }
}
