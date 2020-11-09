//
//  UIViewController+Extension.swift
//  CashBackEPN
//
//  Created by Александр Кузьмин on 21/05/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

private let swizzling: (AnyClass, Selector, Selector) -> () = { forClass, originalSelector, swizzledSelector in
    let originalMethod = class_getInstanceMethod(forClass, originalSelector)
    let swizzledMethod = class_getInstanceMethod(forClass, swizzledSelector)
    method_exchangeImplementations(originalMethod!, swizzledMethod!)
}

extension UIViewController {
    
    static let classInit: Void = {
        let originalSelector = #selector(viewDidAppear(_:))
        let swizzledSelector = #selector(swizzledViewDidAppear(_:))
        swizzling(UIViewController.self, originalSelector, swizzledSelector)
    }()

    @objc func swizzledViewDidAppear(_ animated: Bool) {
        SplashscreenManager.instance.moveToTop()
    }
    
    func pushViewController(storyboardName: String, viewControllerIdentifier: String, withAnimation: Bool = true, completion: (()->())? = nil) {
        let storyboard = UIStoryboard.init(name: storyboardName, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: viewControllerIdentifier)
        let navController = UINavigationController(rootViewController: vc)
        self.present(navController, animated: withAnimation, completion: {
            completion?()
        })
    }
    
    func presentViewControllerAsPopup(storyboardName: String, viewControllerIdentifier: String, animation: Bool = true, completion: (()->())? = nil) {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let popupVc = storyboard.instantiateViewController(withIdentifier: viewControllerIdentifier)
        popupVc.providesPresentationContextTransitionStyle = true
        popupVc.definesPresentationContext = true
        popupVc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        popupVc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        guard let navigationController = self.navigationController else {
            self.present(popupVc, animated: animation) {
                completion?()
            }
            return
        }
        navigationController.present(popupVc, animated: animation) {
            completion?()
        }
    }
    
    static func controllerInStoryboard(_ storyboard: UIStoryboard, identifier: String) -> Self {
        return instantiateControllerInStoryboard(storyboard, identifier: identifier)
    }
    
    static func controllerInStoryboard(_ storyboard: UIStoryboard) -> Self {
        return controllerInStoryboard(storyboard, identifier: nameOfClass())
    }
    
    static func controllerFromStoryboard(_ storyboard: Storyboards) -> Self {
        return controllerInStoryboard(UIStoryboard(name: storyboard.rawValue, bundle: nil), identifier: nameOfClass())
    }
    
    func topMostViewController() -> UIViewController? {
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController()
        }
            
        if let tab = self as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tab.topMostViewController()
        }
        if self.presentedViewController == nil {
            return self
        }
        if let navigation = self.presentedViewController as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController()
        }
        if let tab = self.presentedViewController as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tab.topMostViewController()
        }
        return self.presentedViewController?.topMostViewController()
    }
    
}

private extension UIViewController {
    static func instantiateControllerInStoryboard<T: UIViewController>(_ storyboard: UIStoryboard, identifier: String) -> T {
        return storyboard.instantiateViewController(withIdentifier: identifier) as! T
    }
}


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIViewController {

    func setLargeTitleDisplayMode(_ largeTitleDisplayMode: UINavigationItem.LargeTitleDisplayMode) {
        switch largeTitleDisplayMode {
        case .automatic:
            guard let navigationController = navigationController else { break }
            if let index = navigationController.children.firstIndex(of: self) {
                setLargeTitleDisplayMode(index == 0 ? .always : .never)
            } else {
                setLargeTitleDisplayMode(.always)
            }
        case .always, .never:
            // Always override to be .never if large title isn't available (contentSizeCategory, device size..)
            navigationItem.largeTitleDisplayMode = isLargeTitleAvailable() ? largeTitleDisplayMode : .never
            // Even when .never, needs to be true otherwise animation will be broken on iOS11, 12, 13
            navigationController?.navigationBar.prefersLargeTitles = true
        @unknown default:
            assertionFailure("\(#function): Missing handler for \(largeTitleDisplayMode)")
        }
    }
    
    private func isLargeTitleAvailable() -> Bool {
        switch traitCollection.preferredContentSizeCategory {
        case .accessibilityExtraExtraExtraLarge,
             .accessibilityExtraExtraLarge,
             .accessibilityExtraLarge,
             .accessibilityLarge,
             .accessibilityMedium,
             .extraExtraExtraLarge:
            return false
        default:
            /// Exclude 4" screen or 4.7" with zoomed
            return UIScreen.main.bounds.height > 568
        }
    }
}
