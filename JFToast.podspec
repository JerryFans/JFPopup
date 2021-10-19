#
# Be sure to run `pod lib lint JFToast.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JFToast'
  s.version          = '1.2.0'
  s.summary          = 'JFToast is a part of JFPopup Module help you popup toast view easily In Swift'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
                       *support three position, top center and bottom*
                       *support only hint*
                       *support only icon*
                       *support hint + icon*
                       DESC

  s.homepage         = 'https://github.com/JerryFans/JFPopup'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'JerryFans' => 'fanjiarong_haohao@163.com' }
  s.source           = { :git => 'https://github.com/JerryFans/JFPopup.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'JFPopup/Classes/Core/*','JFPopup/Classes/General/Toast/*'
  
  s.swift_version = ['4.0']
  
  s.dependency 'JRBaseKit', '~> 0.9.0'
  
   s.resource_bundles = {
     'JFPopup' => ['JFPopup/Assets/*.png'],
   }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'

end
