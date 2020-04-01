platform :ios, '13.0'

# ignore all warnings in all pods.
inhibit_all_warnings!

target 'Top100Albums' do
  use_frameworks!
  
  pod 'CocoaLumberjack/Swift'
  pod 'Kingfisher', '~> 5.0'
  pod 'SnapKit', '~> 5.0.0'
  pod 'SwiftLint'

  target 'Top100AlbumsTests' do
    inherit! :search_paths
    pod 'OHHTTPStubs/Swift'
    pod 'SnapshotTesting', '~> 1.7.2'
  end

  target 'Top100AlbumsUITests' do
    # Pods for testing
  end
end
