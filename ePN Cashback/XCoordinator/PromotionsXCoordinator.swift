//
//  PromotionsXCoordinator.swift
//  ePN Cashback
//
//  Created by Ivan Nikitin on 16/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import XCoordinator

enum PromotionsRoute: Route {
    case main
    case filter(StockFilterVCDelegate, [StockFilterCategory])
    case back
}

class PromotionsXCoordinator: NavigationCoordinator<PromotionsRoute> {
    
    // MARK: - Init
    
    init() {
        super.init(initialRoute: .main)
    }
    
    // MARK: - Overrides
    
    override func prepareTransition(for route: PromotionsRoute) -> NavigationTransition {
        (rootViewController as? UINavigationController)?.navigationBar.shadowImage = UIImage()
        switch route {
        case .main:
            let stocksVC: StocksMainVC = StocksMainVC.controllerFromStoryboard(.stocks)
            stocksVC.viewModel = StocksMainViewModel(router: unownedRouter)
            return .push(stocksVC)
        case let .filter(delegate, filters):
            let filterVC: StockFilterVC = StockFilterVC.controllerFromStoryboard(.stocks)
            filterVC.viewModel = StockFilterViewModel(router: unownedRouter, filters: filters)
            filterVC.delegate = delegate
            filterVC.hidesBottomBarWhenPushed = true
            return .push(filterVC)
            //            let viewController = NewsViewController.instantiateFromNib()
            //            let service = MockNewsService()
            //            let viewModel = NewsViewModelImpl(newsService: service, router: anyRouter)
            //            viewController.bind(to: viewModel)
            //            return .push(viewController)
            //        case .newsDetail(let news):
            //            let viewController = NewsDetailViewController.instantiateFromNib()
            //            let viewModel = NewsDetailViewModelImpl(news: news)
            //            viewController.bind(to: viewModel)
            //            let animation: Animation
            //            if #available(iOS 10.0, *) {
            //                animation = .swirl
            //            } else {
            //                animation = .scale
            //            }
        //            return .push(viewController, animation: animation)
        case .back:
            return .pop()
        }
    }
}
