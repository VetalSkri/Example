# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

target 'Backit' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ePN Cashback

  pod 'VK-ios-sdk'
  pod 'FBSDKLoginKit'
  pod 'GoogleSignIn'

  pod 'Firebase/Auth'
  pod 'Firebase/Core'
  pod 'Firebase/Messaging'
  pod 'Firebase/RemoteConfig'
  pod 'Firebase/Analytics'
  pod 'SnapKit'

  pod 'Fabric'
  pod 'Crashlytics'
  pod 'RxSwift', '~> 5'
  pod 'RxCocoa', '~> 5'
  pod 'ProgressHUD'
  pod 'Charts'
  pod 'JTAppleCalendar', '~> 7'
  pod 'lottie-ios'
  pod 'Toast-Swift', '~> 5.0.0'
  pod 'Kingfisher', '~> 5.0'
  pod 'XCoordinator', '~> 2'
  pod 'InputMask'
  pod 'Repeat'
  pod 'TransitionButton'
  pod 'Alamofire', '5.0.0-beta.6'
  pod 'FSPagerView'
  pod 'markymark'
  pod 'SwipeMenuViewController'
  pod "Skeleton"
  pod "ReverseExtension"
  pod 'ISDiskCache'
  pod 'Lightbox'
  pod 'Differ'
  pod "KeyboardAvoidingView", '~> 5.0'
  pod 'SPStorkController'
  pod 'FSCalendar'
  pod 'YandexMobileMetrica', '3.9.4'
  pod 'PhoneNumberKit', '~> 3.1'
  

  target 'CashBackEPNTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'CashBackEPNUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    if ['markymark', 'SwipeMenuViewController', 'TransitionButton', ].include? target.name
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '4.2'
      end
    end
    if ['ReverseExtension', ].include? target.name
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '4.0'
      end
    end
  end

end
