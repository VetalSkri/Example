//
//  QRScannerViewModel.swift
//  ePN Cashback
//
//  Created by Ivan Nikitin on 02/08/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import XCoordinator
import Photos
import RxSwift
import RxCocoa
import UIKit

class QRScannerViewModel: QRScannerModelType {
    
    private let router: UnownedRouter<ScanRoute>
    private let photosLibrarySubject: PublishSubject<[UIImage?]> = PublishSubject<[UIImage?]>()
    private var images: [UIImage?] = [nil]
    
    
    var photosLibrary: Observable<[UIImage?]> {
        return photosLibrarySubject.asObserver()
    }
    
    init(router: UnownedRouter<ScanRoute>) {
        self.router = router
    }
    
    func goOnBack() {
        router.trigger(.close)
    }
    
    func goOnManualEnter() {
        router.trigger(.manual(isModal: false))
    }
    
    func goOnClose(qrString: String) {
        Analytics.sentEventScanSendQR()
        router.trigger(.dismiss(qrString), with: TransitionOptions(animated: false))
    }
    
    func getPhoto(to indexPath: IndexPath) {
        guard let image = images[indexPath.row] else { return }
        handlePhoto(photo: image)
    }
    
    func handlePhoto(photo: UIImage) {
        if let features = detectQRCode(photo), !features.isEmpty{
            for case let row as CIQRCodeFeature in features{
                print(row.messageString ?? "nope")
                guard let stringValue = row.messageString else { return }
                goOnClose(qrString: stringValue )
            }
        }
        else {
            goOnClose(qrString: "")
        }
    }
    
    func detectQRCode(_ image: UIImage?) -> [CIFeature]? {
        if let image = image, let ciImage = CIImage.init(image: image){
            var options: [String: Any]
            let context = CIContext()
            options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
            let qrDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: options)
            if ciImage.properties.keys.contains((kCGImagePropertyOrientation as String)){
                options = [CIDetectorImageOrientation: ciImage.properties[(kCGImagePropertyOrientation as String)] ?? 1]
            } else {
                options = [CIDetectorImageOrientation: 1]
            }
            let features = qrDetector?.features(in: ciImage, options: options)
            return features
            
        }
        return nil
    }
    
    func load() {
        photosLibrarySubject.onNext(self.images)
    }
    
    // Получение фотографий из устройства
    func obtainThePhotosLibrary(){
        DispatchQueue.global(qos: .unspecified).async {
            let imageManager = PHImageManager.default()
            let requestManager = PHImageRequestOptions()
            requestManager.isSynchronous = true
            requestManager.deliveryMode = .highQualityFormat

            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

            if let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions) {
                if fetchResult.count > 0 {
                    let count = fetchResult.count > 20 ? 20 : fetchResult.count
                    for photo in 0..<count {
                        imageManager.requestImage(for: fetchResult.object(at: photo), targetSize: CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height), contentMode: .aspectFill, options: requestManager) { (image, error) in
                            if let image = image {
                                self.images.append(image)
                            }
                        }
                    }
                } else {
                    print("Empty")
                }
            }
            self.photosLibrarySubject.onNext(self.images)
        }
    }
}
