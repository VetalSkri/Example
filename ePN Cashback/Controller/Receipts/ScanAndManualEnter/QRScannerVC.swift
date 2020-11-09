//
//  QRScannerVC.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 01/03/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit
import AVFoundation
import SnapKit
import Photos
import RxSwift
import RxCocoa

final class QRScannerVC: UIViewController, UINavigationControllerDelegate {
    
    var viewModel: QRScannerModelType!
    var captureSession = AVCaptureSession()
    private var pickerController: UIImagePickerController!
    private var isFirstLayout = true
    
    private var collectionView: UICollectionView!
    
    var topView = UIView()
    var qrDashedRectView = UIView()
    var helpLabel = UILabel()
    
    var bag = DisposeBag()
    
    var buttonsContainerView = UIView()
    var manualEnterContainerView = UIView()
    var backImageView = UIImageView(image: UIImage(named: "closeScan"))
    var flashStatusImageView = UIImageView(image: UIImage(named: "noFlash"))
    var pencilImageView = UIImageView(image: UIImage(named: "pencil"))
    var enterDataLabel = UILabel()
        
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.qr]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUIElements()
        setupSubviews()
        setupConstraints()
        binding()
        viewModel.load()
//         Get the back-facing camera for capturing videos
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)

        PHPhotoLibrary.requestAuthorization{status in
            if status == .authorized {
                self.viewModel.obtainThePhotosLibrary()
            }
        }

        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("Failed to get the camera device")
            return
        }

        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)

            // Set the input device on the capture session.
            captureSession.addInput(input)

            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)

            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes

        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }

        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = CGRect(x: view.frame.origin.x, y: 0, width: view.frame.width, height: view.frame.height)
        view.layer.addSublayer(videoPreviewLayer!)

        // Start video capture.
        captureSession.startRunning()

        // Move the message label and top bar to the front

        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubviewToFront(qrCodeFrameView)
        }
        
        view.bringSubviewToFront(backImageView)
        view.bringSubviewToFront(qrDashedRectView)
        view.bringSubviewToFront(helpLabel)
        view.bringSubviewToFront(buttonsContainerView)
        view.bringSubviewToFront(topView)
    }
    
    private func checkPermission(completion: @escaping (Bool) -> Void){
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized:
                completion(true)
            default:
                self.showNoAccessAlert()
            }
        }
    }
    
    private func showNoAccessAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: NSLocalizedString("Permission denied", comment: ""), message: NSLocalizedString("Settings_AccessGallery", comment: ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel))
            alert.addAction(UIAlertAction(title: NSLocalizedString("Settings_Title", comment: ""), style: .default, handler: { _ in
                guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                UIApplication.shared.open(url, options: [:])
            }))
            
            self.present(alert, animated: true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        if isFirstLayout {
            isFirstLayout = false
            qrDashedRectView.drawCorners(radius: 10.0, color: .zurich, strokeWidth: 4.0, length: qrDashedRectView.frame.size.width/5)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setupImagePicker() {
        DispatchQueue.main.async {
            self.pickerController = UIImagePickerController()
            self.pickerController.delegate = self
            self.pickerController.allowsEditing = true
            
            self.present(self.pickerController, animated: true, completion: nil)
        }
    }
    
    private func setupSubviews() {
        
        helpLabel.numberOfLines = 0
        helpLabel.textAlignment = .center
        
        topView.addSubview(backImageView)
        topView.addSubview(flashStatusImageView)
            
        manualEnterContainerView.addSubview(pencilImageView)
        manualEnterContainerView.addSubview(enterDataLabel)

        buttonsContainerView.addSubview(manualEnterContainerView)
        
        qrDashedRectView.addSubview(helpLabel)
            
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = CGSize(width: 80, height: 80)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ImageCollectionCell.self, forCellWithReuseIdentifier: "ImageCollectionCell")
        collectionView.backgroundColor = .clear
    
        self.buttonsContainerView.addSubview(collectionView)
        
        flashStatusImageView.contentMode = .scaleAspectFit
        flashStatusImageView.isUserInteractionEnabled = true
        flashStatusImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(flashTapGesture)))
        
        backImageView.isUserInteractionEnabled = true
        backImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backButtonClicked)))
        
        manualEnterContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(manualEnterTapGesture)))
        
        self.view.addSubview(topView)
        self.view.addSubview(qrDashedRectView)
        self.view.addSubview(buttonsContainerView)
    }
    
    private func setupConstraints() {
        topView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        flashStatusImageView.snp.makeConstraints { (make) in
            make.height.equalTo(28)
            make.width.equalTo(28)
            make.top.equalToSuperview().inset(56)
            make.bottom.equalToSuperview()
            make.right.equalToSuperview().inset(24)
        }
        backImageView.snp.makeConstraints { (make) in
            make.height.equalTo(28)
            make.width.equalTo(28)
            make.top.equalToSuperview().inset(56)
            make.left.equalToSuperview().inset(24)
            make.bottom.equalToSuperview()
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(manualEnterContainerView.snp.bottom).offset(20)
            make.left.equalToSuperview().inset(16)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(50)
            make.height.greaterThanOrEqualTo(80)
        }
        buttonsContainerView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(170)
            make.top.greaterThanOrEqualTo(qrDashedRectView.snp.bottom).offset(20)
        }
        manualEnterContainerView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        pencilImageView.snp.makeConstraints { (make) in
            make.height.equalTo(20)
            make.width.equalTo(20)
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        enterDataLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalTo(pencilImageView.snp.right).offset(13)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        qrDashedRectView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.lessThanOrEqualToSuperview()
            make.height.equalTo(250)
            make.width.equalTo(250)
        }
        helpLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
    
    private func binding() {
        viewModel.photosLibrary.bind(to: collectionView.rx.items(cellIdentifier: "ImageCollectionCell", cellType: ImageCollectionCell.self)) { [weak self ]index,image,cell in
            self?.view.layoutIfNeeded()
            cell.setupImage(image: image)
        }.disposed(by: bag)
        
        collectionView.rx.itemSelected.subscribe(onNext: { [weak self] in
            if $0.row == 0 {
                self?.checkPermission { (status) in
                    if status {
                        self?.setupImagePicker()
                    }
                }
            } else {
                self?.viewModel.getPhoto(to: $0)
            }
            }).disposed(by: bag)
    }
    
    private func setUpUIElements() {
        navigationController?.navigationBar.isHidden = true
        
        helpLabel.textColor = .zurich
        helpLabel.font = .bold17
        helpLabel.text = NSLocalizedString("Point the camera at the QR-code", comment: "")
        
        enterDataLabel.textColor = .zurich
        enterDataLabel.font = .semibold15
        enterDataLabel.text = NSLocalizedString("Enter data manually", comment: "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = .black
    }
    
    @objc func backButtonClicked(_ sender: Any) {
        captureSession.stopRunning()
        viewModel.goOnBack()
    }
    
    @objc func flashTapGesture(_ sender: Any) {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        guard device.hasTorch else { return }
        
        do {
            try device.lockForConfiguration()
            
            if (device.torchMode == AVCaptureDevice.TorchMode.on) {
                device.torchMode = AVCaptureDevice.TorchMode.off
                flashStatusImageView.image = UIImage(named: "noFlash")
            } else {
                do {
                    try device.setTorchModeOn(level: 1.0)
                    flashStatusImageView.image = UIImage(named: "flash")
                } catch {
                    print(error)
                }
            }
            
            device.unlockForConfiguration()
        } catch {
            print(error)
        }
    }
    
    @objc func manualEnterTapGesture(_ sender: Any) {
        viewModel.goOnManualEnter()
    }
    
}

extension QRScannerVC: AVCaptureMetadataOutputObjectsDelegate {
    
    /// Stops scanning the codes.
    public func stopScanning() {
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }
    
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            return
        }
        
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                stopScanning()
                viewModel.goOnClose(qrString: metadataObj.stringValue!)
            }
        }
    }
}
extension QRScannerVC: UIImagePickerControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        pickerController.dismiss(animated: true, completion: nil)
        self.viewModel.handlePhoto(photo: info[.editedImage] as! UIImage)
    }
}
