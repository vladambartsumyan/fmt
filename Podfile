platform :ios, '8.0'
use_frameworks!

target 'FMT2’ do
    pod 'RealmSwift'
    pod 'Realm'
    pod 'Moya'
    pod 'SMSegmentView', '~> 1.1'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.1'
      config.build_settings['CLANG_WARN_DOCUMENTATION_COMMENTS'] = 'NO'
    end
  end
end
