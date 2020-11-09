//
//  SplashscreenManager.swift
//  Backit
//
//  Created by Александр Кузьмин on 15/01/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import UIKit

class SplashscreenManager {

    // MARK: - Properties

    static let instance = SplashscreenManager(animationDurationBase: 1.3)

    var view: SplashscreenView?
    var parentView: UIWindow?

    let animationDurationBase: Double

    let logoQuestionMarkViewTag = 100
    let logoIsItViewTag = 101
    let logoVigetViewTag = 102


    // MARK: - Lifecycle

    init(animationDurationBase: Double) {
        self.animationDurationBase = animationDurationBase
    }


    // MARK: - Animate

    func animateAfterLaunch(_ parentViewPassedIn: UIWindow) {
        parentView = parentViewPassedIn
        view = loadView()
        view?.complete = { [weak self] in
            self?.view?.removeFromSuperview()
            self?.view = nil
        }
        fillParentViewWithView()
    }

    func loadView() -> SplashscreenView {
        return UINib(nibName: "SplashscreenView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! SplashscreenView
    }

    func fillParentViewWithView() {
        if let view = view {
            parentView?.addSubview(view)
            parentView?.bringSubviewToFront(view)
            parentView?.makeKeyAndVisible()
            
            view.frame = parentView!.bounds
            view.center = parentView!.center
        }
    }
    
    func moveToTop() {
        if let view = view {
            parentView?.bringSubviewToFront(view)
        }
    }
}
