//
//  HomeTabCoordinator.swift
//  ePN Cashback
//
//  Created by Ivan Nikitin on 16/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import XCoordinator

enum HomeRoute: Route {
    case shops
    case offlineCB
    case promotions
    case orders
    case account
}

class HomeTabCoordinator: TabBarCoordinator<HomeRoute> {
    
    // MARK: - Stored properties
    
    private var tabBarHandler = TabBarHandler()
    private let shopsRouter: StrongRouter<ShopsRoute>
    private let offlineCbRouter: StrongRouter<OfflineCBRoute>
    private let promotionsRouter: StrongRouter<PromotionsRoute>
    private let ordersRouter: StrongRouter<OrdersRoute>
    private let accountRouter: StrongRouter<AccountRoute>
    
    // MARK: - Init
    
    convenience init(pageIndex index: Int, needUpdate: Bool) {
        let shopsCoordinator = ShopsXCoordinator(needUpdate: needUpdate)
        shopsCoordinator.rootViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("Stores", comment: ""), image: UIImage(named: "tabBarStores")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "tabBarStoresSelected")?.withRenderingMode(.alwaysOriginal))
        shopsCoordinator.rootViewController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.sydney], for: .selected)

        let offlineCbCoordinator = OfflineCBXCoordinator()
        offlineCbCoordinator.rootViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("OfflineCashback", comment: ""), image: UIImage(named: "tabBarReceipts")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "tabBarReceiptsSelected")?.withRenderingMode(.alwaysOriginal))
        offlineCbCoordinator.rootViewController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.sydney], for: .selected)
        
        let promotionsCoordinator = PromotionsXCoordinator()
        promotionsCoordinator.rootViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("Stocks", comment: ""), image: UIImage(named: "tabBarSale")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "tabBarSaleSelected")?.withRenderingMode(.alwaysOriginal))
        promotionsCoordinator.rootViewController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.sydney], for: .selected)

        let ordersCoordinator = OrdersXCoordinator()
        ordersCoordinator.rootViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("Orders", comment: ""), image: UIImage(named: "tabBarMyOrder")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "tabBarMyOrderSelected")?.withRenderingMode(.alwaysOriginal))
        ordersCoordinator.rootViewController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.sydney], for: .selected)

        let accountCoordinator = AccountXCoordinator()
        accountCoordinator.rootViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("Account", comment: ""), image: UIImage(named: "tabBarAccount")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "tabBarAccountSelected")?.withRenderingMode(.alwaysOriginal))
        accountCoordinator.rootViewController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.sydney], for: .selected)
        
        self.init(
                  shopsRouter: shopsCoordinator.strongRouter,
                  offlineCbRouter: offlineCbCoordinator.strongRouter,
                  promotionsRouter: promotionsCoordinator.strongRouter,
                  ordersRouter: ordersCoordinator.strongRouter,
                  accountRouter: accountCoordinator.strongRouter,
                  pageIndex: index)
    }
    
    init(
         shopsRouter: StrongRouter<ShopsRoute>,
         offlineCbRouter: StrongRouter<OfflineCBRoute>,
         promotionsRouter: StrongRouter<PromotionsRoute>,
         ordersRouter: StrongRouter<OrdersRoute>,
         accountRouter: StrongRouter<AccountRoute>,
         pageIndex page: Int) {
        self.shopsRouter = shopsRouter
        self.offlineCbRouter = offlineCbRouter
        self.promotionsRouter = promotionsRouter
        self.ordersRouter = ordersRouter
        self.accountRouter = accountRouter
        
        super.init(tabs: [shopsRouter, offlineCbRouter, promotionsRouter, ordersRouter, accountRouter], select: page)
        self.rootViewController.tabBar.barTintColor = .zurich
        self.rootViewController.delegate = tabBarHandler
    }
    
    // MARK: - Overrides
    
    override func prepareTransition(for route: HomeRoute) -> TabBarTransition {
        
        switch route {
        case .shops:
            return .select(shopsRouter)
        case .offlineCB:
            return .select(offlineCbRouter)
        case .promotions:
            return .select(promotionsRouter)
        case .orders:
            return .select(ordersRouter)
        case .account:
            return .select(accountRouter)
        }
    }
}

class TabBarHandler: NSObject, UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let navController = viewController as? UINavigationController, let _ = navController.viewControllers.first as? ReceiptsMainVC {
            ///Send event to analytic about open multyOffers 
            Analytics.showEventMultyOffers()
        }
    }
}
