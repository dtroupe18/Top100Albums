platform :ios, '13.0'

# ignore all warnings in all pods.
inhibit_all_warnings!
use_frameworks! :linkage => :static

target 'Top100Albums' do
  pod 'Alamofire'
  pod 'CocoaLumberjack/Swift'
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
