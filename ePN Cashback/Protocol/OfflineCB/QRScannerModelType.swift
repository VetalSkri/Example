//
//  QRScannerModelType.swift
//  ePN Cashback
//
//  Created by Ivan Nikitin on 02/08/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//
import RxSwift
import RxCocoa
import Foundation

protocol QRScannerModelType {
    
    var photosLibrary: Observable<[UIImage?]> { get }
    
    var messageText: String { get }
    var infoText: String { get }
    var buttonText: String { get }
    
    func goOnBack()
    func goOnManualEnter()
    func goOnClose(qrString: String)
    func handlePhoto(photo: UIImage) 
    func getPhoto(to indexPath: IndexPath)
    func obtainThePhotosLibrary()
    func load()
    
}

extension QRScannerModelType {
    
    var messageText: String {
        return NSLocalizedString("Point the camera at the QR code and scan it.", comment: "")
    }
    
    var infoText: String {
        return NSLocalizedString("Failed to scan a QR code?", comment: "")
    }
    
    var buttonText: String {
        return NSLocalizedString("Enter data manually", comment: "")
    }
}
