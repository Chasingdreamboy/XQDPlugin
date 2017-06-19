#
# Be sure to run `pod lib lint XQDPlugin.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'XQDPlugin'
  s.version          = '0.0.7'
  s.summary          = 'An easy way to install Xiaoqidai allication.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
方便快速接入小期贷。
                       DESC

  s.homepage         = 'https://github.com/acct<blob>=<NULL>/XQDPlugin'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'acct<blob>=<NULL>' => 'wangerdong@treefinance.com.cn' }
  s.source           = { :git => 'https://github.com/Chasingdreamboy/XQDPlugin.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'
  s.source_files = 'XQDPlugin/Classes/**/*'
   s.resource_bundles = {
     'XQDPlugin' => ['XQDPlugin/Assets/*.png','XQDPlugin/Assets/*.xml','XQDPlugin/Assets/*.html', 'XQDPlugin/Assets/*.js','XQDPlugin/Assets/*.gif','XQDPlugin/Assets/*.storyboard','XQDPlugin/Assets/*.xib','XQDPlugin/Assets/*.xcassets']
   }
	#s.xcconfig = { 'LIBRARY_SEARCH_PATHS' => '/Users/wangxiaodong/Desktop/XQDPlugin/XQDPlugin/Classes/Vender/tongdun' }
   s.public_header_files = 'XQDPlugin/Classes/XQDPlugin.h'
   s.frameworks = "UIKit", "CoreGraphics", "MobileCoreServices", "Security", "SystemConfiguration", "AddressBookUI", "AddressBook", "CoreLocation","ImageIO","AssetsLibrary","Accelerate","AVFoundation","ContactsUI","AdSupport","CoreMedia","CoreTelephony"
   s.library = 'z','c++','icucore','resolv'
   #s.ios.vendored_libraries = 'XQDPlugin/Frameworks/*.a'
   s.dependency 'AFNetworking', '~> 3.1.0'
   s.dependency 'MBProgressHUD', '~> 0.8'
   s.dependency 'APAddressBook','~> 0.1.11'
   s.dependency 'LLSimpleCamera', '~> 3.0.0'
   s.dependency 'NJKWebViewProgress', '~> 0.2.3'
   s.dependency 'TPKeyboardAvoiding', '~> 1.2.8'
   s.dependency 'NYXImagesKit', '~> 2.3'
   s.dependency 'FontAwesomeKit', '~> 2.2.0'
   s.dependency 'OpenUDID', '~> 1.0.0'
   s.dependency 'RKDropdownAlert', '~> 0.3.0'
   s.dependency 'pop', '~> 1.0.8'
   s.dependency 'FCCurrentLocationGeocoder', '~> 1.1.10'
   s.dependency 'RegexKitLite', '~> 4.0'
   s.dependency 'UIResponder+KeyboardCache', '~> 0.1'
   s.dependency 'SimpleExif', '~> 0.0.1'
   s.dependency 'AliyunOSSiOS', '~> 2.6.0'
   #s.dependency 'RSAEncrypt', '~> 1.1.0'
   s.dependency 'MJRefresh'
   s.dependency 'GTMBase64', '~> 1.0.0'
   s.dependency 'RBBAnimation', '~> 0.3.0'
   s.dependency 'CAAnimationBlocks', '~> 0.0.1'
   s.dependency 'SDWebImage', '~> 4.0.0'
   s.dependency 'AliyunOSSiOS', '~> 2.6.0'
   #s.dependency 'TalkingData-Analytics', :git => 'http://192.168.5.252/ios/TalkingData-Analytics.git'
   #s.dependency 'TDBadgedCell','~> 4.1.1'
   s.dependency 'UICKeyChainStore', '~> 2.0.6'
end
