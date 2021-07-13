#
# Be sure to run `pod lib lint RYJToolKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RYJToolKit'
  s.version          = '0.3.6'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.summary          = 'Underlying tool component.'
  s.homepage         = 'https://github.com/developRen/RYJToolKit'
  s.author           = { 'developRen' => 'jie_ios@163.com' }
  s.source           = { :git => 'https://github.com/developRen/RYJToolKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  
#  s.prefix_header_file = "RYJToolKit/Classes/RYJToolKit.pch"
  s.source_files = 'RYJToolKit/Classes/RYJToolKit.h',
                   'RYJToolKit/Classes/RYJToolMarco.h'
                   
  s.subspec 'RYJDate' do |ss|
      ss.source_files = 'RYJToolKit/Classes/RYJDate/RYJDate.{h,m}'
  end
  
  s.subspec 'RYJNetwork' do |ss|
      ss.source_files = 'RYJToolKit/Classes/RYJNetwork/RYJReachability.{h,m}'
      ss.dependency 'RealReachability'
  end
    
  s.subspec 'RYJPermission' do |ss|
      ss.source_files = 'RYJToolKit/Classes/RYJPermission/RYJPermission.{h,m}'
  end
    
#  s.subspec 'RYJRouter' do |ss|
#      ss.source_files = 'RYJToolKit/Classes/RYJRouter/RYJRouter.{h,m}'
#  end
    
  s.subspec 'RYJTimer' do |ss|
      ss.source_files = 'RYJToolKit/Classes/RYJTimer/RYJTimer.{h,m}'
  end

  s.subspec 'RYJLocation' do |ss|
      ss.source_files = 'RYJToolKit/Classes/RYJLocation/RYJLocation.{h,m}'
  end
  
  s.subspec 'RYJToolCategory' do |ss|

       ss.subspec 'Foundation' do |ss|
            ss.source_files = 'RYJToolKit/Classes/RYJToolCategory/Foundation/NSArray+RYJTool.{h,m}',
            'RYJToolKit/Classes/RYJToolCategory/Foundation/NSFileManager+RYJTool.{h,m}',
            'RYJToolKit/Classes/RYJToolCategory/Foundation/NSObject+RYJTool.{h,m}',
            'RYJToolKit/Classes/RYJToolCategory/Foundation/NSString+RYJTool.{h,m}'
       end

       ss.subspec 'UIKit' do |ss|
            ss.dependency 'RYJToolKit/RYJToolCategory/Foundation'
            ss.source_files = 'RYJToolKit/Classes/RYJToolCategory/UIKit/UIImage+RYJTool.{h,m}',
            'RYJToolKit/Classes/RYJToolCategory/UIKit/UIFont+RYJTool.{h,m}',
            'RYJToolKit/Classes/RYJToolCategory/UIKit/UILabel+RYJTool.{h,m}',
            'RYJToolKit/Classes/RYJToolCategory/UIKit/UIViewController+RYJTool.{h,m}'
       end

 end
       
  # s.resource_bundles = {
  #   'RYJToolKit' => ['RYJToolKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  
  s.dependency 'YTKNetwork'
  s.dependency 'CTMediator'
  
end
