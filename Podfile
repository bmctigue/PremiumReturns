source 'https://github.com/CocoaPods/Specs.git'
use_frameworks!

target 'PremiumReturns' do

    pod 'RealmSwift'
    pod 'Eureka', :git => 'https://github.com/xmartlabs/Eureka.git'
    pod 'ChameleonFramework/Swift', :git => 'https://github.com/ViccAlexander/Chameleon.git'
    pod 'SwiftyUserDefaults', :git => 'https://github.com/radex/SwiftyUserDefaults.git'

    target 'PremiumReturnsTests' do
        inherit! :search_paths
    end
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        if target.name == 'Eureka'
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '4.1'
            end
        end
    end
end
