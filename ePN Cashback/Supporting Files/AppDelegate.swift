//
//  AppDelegate.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 20.08.18.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import VK_ios_sdk
import Firebase
import FirebaseMessaging
import CoreData
import UserNotifications
import Fabric
import Crashlytics
import FirebaseCore
import Kingfisher
import XCoordinator
import CoreSpotlight
import YandexMobileMetrica

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let window: UIWindow! = UIWindow()
    var router : StrongRouter<AppRoute>!// = { return AppXCoordinator().anyRouter }()

    let gcmMessageIDKey = "gcm.message_id"
    
    override init() {
        super.init()
        UIViewController.classInit
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Fabric.with([Crashlytics.self])
        window.backgroundColor = .white
        
        //MARK: - Set up maxCount cache for image
        KingfisherManager.shared.cache.memoryStorage.config.totalCostLimit = 10000000
        
        //MARK: - Set up notification config
        FirebaseApp.configure()
        Notifications.shared.notificationCenter.delegate = Notifications.shared
        Notifications.shared.notificationMessaging.delegate = Notifications.shared
        Notifications.shared.setCategoryAction()
        self.setupRouter()
        
        CoreDataManager.shared.setup(completion: {
            print("MYLOG: Core Data configured successfully.")
            
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .changedMainStoreList, object: nil)
            }
        })
        
        //MARK: - Firebase subscribe to topics
        Notifications.shared.notificationMessaging.subscribe(toTopic: "iosnews") { error in
            if let error = error {
                print("MYLOG: subscribed to news topic Error: \(String(describing: error.localizedDescription))")
            }
        }

        //MARK: - Initialize sign-in google
        GIDSignIn.sharedInstance().clientID = Bundle.main.object(forInfoDictionaryKey: "GOOGLE_CLIENT_ID") as? String

        //MARK: - Initialize sign-in facebook
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)

        SplashscreenManager.instance.animateAfterLaunch(window!)
        _ = RemoteCfg.shared
        
        if Session.shared.isFirstLaunchApp {
            Util.isCardsPursesHint = true
            Util.isUkrainV2PurseHint = true
            Session.shared.isFirstLaunchApp = false
        }
        
        //MARK: - Initialize App Metrica
        if let configuration = YMMYandexMetricaConfiguration.init(apiKey: "d3e00f05-a881-4b82-a590-d64cec587e2b") {
            YMMYandexMetrica.activate(with: configuration)
            print("MYLOG: Yandex metrica configurate successfully")
        } else {
            print("MYLOG: Yandex metrica configurate failure")
        }
        
        return true
    }
    
    private func setupRouter() {
        if router == nil {
            router = AppXCoordinator().strongRouter
            self.router.setRoot(for: window)
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map{ String(format: "%02.2hhx", $0) }.joined()
        print("Device token is: \(token)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("MYLOG: application didReceiveRemoteNotification called")
        setupRouter()
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        RemoteCfg.shared.fetch()
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        Session.shared.locale = Util.languageOfContent()
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        PaymentUtils.shared.disableAllRotatedPurse()
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        print("Continue User activity called: ")
        
        if userActivity.activityType == CSSearchableItemActionType {
            if !Session.shared.isAuth {
                return true
            }
            if let userInfo = userActivity.userInfo {
                let selectedID = userInfo[CSSearchableItemActivityIdentifier] as! String
                if let itemIdString = selectedID.components(separatedBy: ":").last, let itemDomain = selectedID.components(separatedBy: ":").first, let domain = SpotlightManager.SpotlightDomain(rawValue: itemDomain), let itemId = Int(itemIdString) {
                    switch domain {
                    case .OfflineStore:
                        router.trigger(.deepLinkOfflineShopDetail(OfferOffline(id: itemId, title: "", description: nil, priority: 0, image: nil, tag: nil, url: nil, typeId: 0, type: ShopTypeId.offlineMulty.rawValue), .spotlight))
                        break
                    case .OnlineStore:
                        router.trigger(.deepLinkOnlineShopDetail(Store(id: itemId, offer: Offer(name: "", title: "", tag: "", image: "", logo: "", logo_small: "", maxRate: "",maxRatePretext: "", priority: 0, typeId: ShopTypeId.offlineMulty.rawValue, offlineCbImage: nil, offlineCbDescription: nil, linkDefault: nil, url: nil)), .spotlight))
                        break
                    }
                }
            }
            return true
        }
        
        //FIXME: - rewrite whole this method
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            let url = userActivity.webpageURL!
            if let params = Util.parseUrlParameters(from: url) {
                guard let hash = params[Util.HASH] else { return true }
                router.trigger(.deepLinkCreateNewPassword(hash))
            } else {
                print("else is offline-cashback \(url)")
                router.trigger(.deepLinkOfflineCB)
            }
        }
        
        return true
    }
    
    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        ApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        
        GIDSignIn.sharedInstance().handle(url)
        VKSdk.processOpen(url, fromApplication: sourceApplication)
        
        let host = url.host
        let path = url.path
        let components = url.pathComponents
        
        print("host is \(String(describing: host))")
        print("path is \(path)")
        for index in 0..<components.count {
            print("components is \(components[index])")
        }
        
        if host == "SignIn" {
            router.trigger(.auth(animate: true))
        }
        return true
    }
}
