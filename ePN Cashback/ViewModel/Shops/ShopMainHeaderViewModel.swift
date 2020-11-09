//
//  ShopsMainHeaderReusableViewModel.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 08/02/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit
import XCoordinator

class ShopMainHeaderViewModel {

    private var doodles = [DoodlesItem]()
    private let router: UnownedRouter<ShopsRoute>
    
    init(doodles: [DoodlesItem], router: UnownedRouter<ShopsRoute>) {
        self.doodles.removeAll()
        self.doodles.append(contentsOf: doodles)
        self.router = router
    }
    
    func buttonTryAgainText() -> String {
        return NSLocalizedString("Try again", comment: "")
    }
    
    func getTitleForEmptyShopsPage() -> String {
        return NSLocalizedString("Try again", comment: "")
    }
    
    func numberOfDoodles() -> Int {
        return doodles.count
    }
    
    func doodlesForIndexPath(indexPath: IndexPath) -> DoodlesItem {
        return doodles[indexPath.row]
    }
    
    func doodleWasClicked(indexPath: IndexPath) {
        let clickedDoodle = doodlesForIndexPath(indexPath: indexPath)
        DoodleAnalytics.openDoodleWith(id: clickedDoodle.id ?? 0)
        
        if clickedDoodle.goToStore {
            guard let typeID = clickedDoodle.offerTypeID else {
                return
            }
            
            guard let offerID = clickedDoodle.offerID else {
                return
            }
            
            switch typeID {
            case DoodlesTypes.onlineOffer.rawValue:
                let store: Store
                
                if let shop = CoreDataStorageContext.shared.fetchShop(byId: offerID) {
                    store = shop
                } else {
                    store = Store(id: offerID,
                                  name: clickedDoodle.name,
                                  title: clickedDoodle.name,
                                  tag: "",
                                  image: clickedDoodle.image ?? "",
                                  logo: clickedDoodle.offerLogo ?? "",
                                  logo_s: clickedDoodle.offerLogo ?? "",
                                  priority: clickedDoodle.priority,
                                  maxRate: nil, maxRatePretext: nil,
                                  typeId: typeID,
                                  offlineCbImage: clickedDoodle.image,
                                  offlineCbDescription: clickedDoodle.subTitle,
                                  linkDefault: clickedDoodle.link,
                                  url: clickedDoodle.link)
                }
                
                self.router.trigger(.shopDetail(store, .doodle))
                
            case DoodlesTypes.offlineOffer.rawValue:
                let offerOffline: OfferOffline
                
                if let offer = CoreDataStorageContext.shared.fetchOfflineOffer(byId: offerID) {
                    offerOffline = offer
                } else {
                    offerOffline = OfferOffline(id: offerID,
                                                title: clickedDoodle.title ?? "",
                                                description: clickedDoodle.subTitle,
                                                priority: clickedDoodle.priority,
                                                image: clickedDoodle.image,
                                                tag: nil,
                                                url: clickedDoodle.link,
                                                typeId: typeID,
                                                type: typeID)
                }
            
                self.router.trigger(.offlineOfferDetail(offerOffline, .doodle))
                
            default:
                return
            }
        } else {
            guard let link = clickedDoodle.link else {
                return
            }
            
            guard let url = URL(string: link) else {
                return
            }
            
            UIApplication.shared.open(url)
        }
    }
}
