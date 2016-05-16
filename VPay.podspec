

Pod::Spec.new do |s|

  s.name         = "VPay"
  s.version      = "0.0.2"
  s.summary      = "this is  a pay components."

  s.description  = <<-DESC
                   * this is  a pay components.
                   * 包含了Alipay, WxPay, UnionPay
                   * 如果需要,后续会陆续集成更多的组件。
                   DESC

  s.homepage     = "https://github.com/lhjzzu/VPay"
  s.license      = "MIT"
  s.author       = { "lhjzzu" => "1822657131@qq.com" }
  s.platform     = :ios, "5.0"
  s.source       = { :git => "https://github.com/lhjzzu/VPay.git", :tag => s.version }
  s.requires_arc = true
  s.default_subspecs = 'Base', 'AliPay', 'WxPay','UnionPay'
  s.xcconfig = { 'OTHER_LDFLAGS' => '-lObjC','ENABLE_BITCODE' => 'NO'}

  s.subspec 'Base' do |base|
    base.source_files = 'lib/*.h'
    base.public_header_files = 'lib/*.h'
    base.vendored_libraries = 'lib/*.a'
    base.frameworks = 'UIKit','Foundation', 'CoreGraphics','CoreText','QuartzCore','CoreTelephony','SystemConfiguration','CoreMotion','CFNetwork'
    base.libraries = 'c++', 'stdc++', 'z','sqlite3.0'
  end
   
  s.subspec 'AliPay' do |alipay|
    alipay.vendored_libraries = 'lib/Channels/AliPay/*.a'
    alipay.ios.vendored_frameworks = 'lib/Channels/AliPay/AlipaySDK.framework'
    alipay.resource = 'lib/Channels/AliPay/AlipaySDK.bundle'
    alipay.dependency 'VPay/Base'
  end
   
  s.subspec 'WxPay' do |wx|
    wx.vendored_libraries = 'lib/Channels/WxPay/*.a'
    wx.public_header_files = 'lib/Channels/WxPay/*.h'
    wx.source_files = 'lib/Channels/WxPay/*.h'
    wx.ios.library = 'sqlite3'
    wx.dependency 'VPay/Base'
  end

  s.subspec 'UnionPay' do |unionpay|
    unionpay.vendored_libraries = 'lib/Channels/UnionPay/*.a'
    unionpay.public_header_files = 'lib/Channels/UnionPay/*.h'
    unionpay.source_files = 'lib/Channels/UnionPay/*.h'
    unionpay.dependency 'VPay/Base'
 end



end
