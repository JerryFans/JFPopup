#
# Be sure to run `pod lib lint JFPopup.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JFPopup'
  s.version          = '1.5.4'
  s.summary          = 'A Swift Popup Module help you popup your custom view easily'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
                       *JFPopup can help you popup your custom view with any way*
                       *Like popup a Drawer, a dialog, a bottomSheet,*
                       *Also support Objc, but you should writeJFPopup  extension with youself, usage see example.
                       *Support many General Kit:
                       *Version 1.0.0 support a Wechat Style ActionSheet
                       *Version 1.2.0 support a ToastView
                       *Version 1.3.0 support a LodingView
                       *Version 1.4.0 support a AlertView
                       *In the feature, will support more popup view
                       DESC

  s.homepage         = 'https://github.com/JerryFans/JFPopup'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'JerryFans' => 'fanjiarong_haohao@163.com' }
  s.source           = { :git => 'https://github.com/JerryFans/JFPopup.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'JFPopup/Classes/**/*'
  
  s.swift_version = ['4.0']
  
  s.dependency 'JRBaseKit', '~> 1.1.1'
  
   s.resource_bundles = {
     'JFPopup' => ['Assets/*.png'],
   }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'

end
