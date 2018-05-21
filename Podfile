platform :ios, '10.0'
use_frameworks!

target 'Movies' do
    
  #Localizable
  pod 'R.swift'
  
  #Layout/UI
  pod 'Cartography'
  pod 'ParallaxHeader'
  pod 'Kingfisher'

  #Lint
  pod 'SwiftLint'
  
  # Rx
  pod 'RxSwift'
  pod 'RxCocoa'

  #API/Network
  pod 'Moya-ObjectMapper/RxSwift'
    
  swift4 = [
    'R.swift',
    'Cartography',
    'ParallaxHeader',
    'Kingfisher',
    'Rswift',
    'RxSwift',
    'RxCocoa',
    'RxGesture',
    'Alamofire',
    'Moya',
    'Moya-ObjectMapper',
    'ObjectMapper'
  ]
  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      swift_version = nil
      
      if swift4.include?(target.name)
        swift_version = '4.1'
        else
        swift_version = '3.2'
      end
      
      if swift_version
        target.build_configurations.each do |config|
          config.build_settings['SWIFT_VERSION'] = swift_version
          config.build_settings['PROVISIONING_PROFILE_SPECIFIER'] = ''
        end
      end
    end
  end
  
end

target 'MoviesTests' do
  
end

target 'MoviesUITests' do

end