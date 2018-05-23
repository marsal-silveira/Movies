platform :ios, '10.0'
use_frameworks!

target 'Movies' do
    
  #Localizable
  pod 'R.swift', '4.0.0'
  
  #Layout/UI
  pod 'Cartography', '3.0.2'
  pod 'ParallaxHeader', '2.0.0'
  pod 'Kingfisher', '4.8.0'

  #Lint
  pod 'SwiftLint', '0.25.1'
  
  # Rx
  pod 'RxSwift', '4.0.0'
  pod 'RxCocoa', '4.1.2'

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
