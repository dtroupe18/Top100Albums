platform :ios, '13.0'

# ignore all warnings in all pods.
inhibit_all_warnings!
use_frameworks! :linkage => :static

target 'Top100Albums' do
  pod 'Alamofire'
  pod 'CocoaLumberjack/Swift'
  pod 'DeviceKit'
  pod 'Kingfisher'
  pod "PromiseKit"
  pod 'SnapKit'
  pod 'SwiftFormat/CLI'
  pod 'SwiftLint'

  target 'Top100AlbumsTests' do
    inherit! :search_paths
    pod 'OHHTTPStubs/Swift'
    pod 'SnapshotTesting'
  end

  target 'Top100AlbumsUITests' do
    # Pods for testing
  end
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
        end
    end
end
