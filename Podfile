platform :ios, '10.0'
inhibit_all_warnings!
use_frameworks!

target 'Pitch' do 
  pod 'AudioKit'
  pod 'Fabric'
  pod 'Crashlytics'
  pod 'UICountingLabel'
  pod 'RealmSwift'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0.2'
    end
  end
end

