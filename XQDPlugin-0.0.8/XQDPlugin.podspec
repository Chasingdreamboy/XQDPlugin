Pod::Spec.new do |s|
  s.name = "XQDPlugin"
  s.version = "0.0.8"
  s.summary = "An easy way to install Xiaoqidai allication."
  s.license = {"type"=>"MIT", "file"=>"LICENSE"}
  s.authors = {"acct<blob>=<NULL>"=>"wangerdong@treefinance.com.cn"}
  s.homepage = "https://github.com/acct<blob>=<NULL>/XQDPlugin"
  s.description = "\u{65b9}\u{4fbf}\u{5feb}\u{901f}\u{63a5}\u{5165}\u{5c0f}\u{671f}\u{8d37}\u{3002}"
  s.frameworks = ["UIKit", "CoreGraphics", "MobileCoreServices", "Security", "SystemConfiguration", "AddressBookUI", "AddressBook", "CoreLocation", "ImageIO", "AssetsLibrary", "Accelerate", "AVFoundation", "ContactsUI", "AdSupport", "CoreMedia", "CoreTelephony"]
  s.libraries = ["z", "c++", "icucore", "resolv"]
  s.xcconfig = {"LIBRARY_SEARCH_PATHS"=>"$(PODS_ROOT)/ios/XQDPlugin.framework"}
  s.source = { :path => '.' }

  s.ios.deployment_target    = '8.0'
  s.ios.vendored_framework   = 'ios/XQDPlugin.framework'
end
