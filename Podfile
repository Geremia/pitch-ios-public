platform :ios, '10.0'
inhibit_all_warnings!
use_frameworks!

target 'Pitch' do 
  pod 'TuningFork', :git => 'https://github.com/comyar/TuningFork.git', :branch => 'swift-3'
  pod 'Chronos-Swift', :git => 'https://github.com/comyar/Chronos-Swift.git', :branch => 'master'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
  end
end

