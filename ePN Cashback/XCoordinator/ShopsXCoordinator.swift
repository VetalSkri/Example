//
//  ShopsXCoordinator.swift
//  ePN Cashback
//
//  Created by Ivan Nikitin on 16/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import XCoordinator

enum ShopDetailSource: String {
    case main
    case pushNotification
    case favoriteShops
    case doodle
    case search
    case category
    case spotlight
}

enum ShopsRoute: Route {
    case main(Bool)
    case categories
    case shopsCategory(Categories)
    case favorite
    case shopDetail(Store, ShopDetailSource)
    case offlineOfferDetail(OfferOffline, TicketDetailSource)
    case faqHowToBuy
    case verifyLink
    case back
}

class ShopsXCoordinator: NavigationCoordinator<ShopsRoute> {
    
    // MARK: - Init
    private let repository: StoreRepositoryProtocol
    
    init(needUpdate: Bool) {
        repository = StoreRepository()
        super.init(initialRoute: .main(needUpdate))
    }
    var childCoordinator: Presentable?

    // MARK: - Overrides
    
    override func prepareTransition(for route: ShopsRoute) -> NavigationTransition {
        
        if let coordinator = childCoordinator {
            removeChild(coordinator)
        }
        switch route {
        case .main(let needUpdate):
            let shopsVC: ShopsMainVC = ShopsMainVC.controllerFromStoryboard(.shops)
            shopsVC.viewModel = ShopsMainViewModel(router: unownedRouter, storeRepository: repository, needUpdate: needUpdate)
            return .push(shopsVC)
        case .categories:
            let categoriesVC: AllCategoryVC = AllCategoryVC.controllerFromStoryboard(.shops)
            categoriesVC.viewModel = AllCategoryViewModel(router: unownedRouter, storeRepository: repository)
            return .push(categoriesVC)
        case let .shopsCategory(categories):
            let shopsByCategoryVC: CategoryShopsVC = CategoryShopsVC.controllerFromStoryboard(.shops)
            shopsByCategoryVC.viewModel = CategoryShopsViewModel(router: unownedRouter, storeRepository: repository, category: categories)
            return .push(shopsByCategoryVC)
        case .favorite:
            let shopsByLabelVC: FavoriteShopsVC = FavoriteShopsVC.controllerFromStoryboard(.shops)
            shopsByLabelVC.viewModel = FavoriteShopsViewModel(router: unownedRouter, storeRepository: repository)
            return .push(shopsByLabelVC)
        case .shopDetail(let store, let source):
            let detailVC = ShopDetailViewController.controllerFromStoryboard(.shops)
            detailVC.hidesBottomBarWhenPushed = true
            let detailVM = ShopDetailViewModel(router: unownedRouter, storeRepository: repository, shop: store, source: source)
            detailVC.bindViewModel(viewModel: detailVM)
            return .push(detailVC)
        case let .offlineOfferDetail(offer, source):
            childCoordinator = OfflineCBXCoordinator(rootViewController: rootViewController, offer: offer, source: source)
            addChild(childCoordinator!)
            return .none()
        case .faqHowToBuy:
            childCoordinator = FAQHowToBuyXCoordinator(rootViewController: rootViewController)
            addChild(childCoordinator!)
            return .none()
        case .verifyLink:
            childCoordinator = VerifyLinkXCoordinator(rootViewController: rootViewController)
            addChild(childCoordinator!)
            return .none()
        case .back:
            return .pop()
        }
    }
}
