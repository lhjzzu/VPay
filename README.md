# VPay
这是一个支付组件，暂时包含有支付宝支付，微信支付和银联支付


# Usage 

## 直接导入
1 可以直接将`lib`文件夹或者`sdk源码`文件夹直接导入工程

2 然后导入相应的框架

    UIKit.framework 
    Foundation.framework 
    CoreGraphics.framework
    CoreText.framework
    QuartzCore.framework
    CoreTelephony.framework
    SystemConfiguration.framework
    CoreMotion.framework
    CFNetwork.framework
    libz.tdb
    libc++.tbd 
    libstdc++.tdb
    libsqlite3.0.tdb

3 `BuildSetting`相关设置
   
   * `other Linker`-> `-ObjC`
   * `Enable bitCode` ->`NO`
  
4 `info.plist`中在URLTypes
    
    设置支付宝和微信的scheme
5 iOS 9 限制了 `http `协议的访问，如果 App 需要访问 `http://`，需要在 `Info.plist` 添加如下代码    

     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     
 6 	渠道
    
    现阶段支持三种渠道:AliPay， WxPay,UnionPay
    如果要删除某一个渠道只需要在Channels下删除对应的文件夹即可
    
## Cocoapods导入

1 可以先搜索一下
   `$ pod search VPay `
   
     -> VPay (0.0.4)
     this is  a pay components.
      pod 'VPay', '~> 0.0.4'
     - Homepage: https://github.com/lhjzzu/VPay
     - Source:   https://github.com/lhjzzu/VPay.git
     - Versions: 0.0.4, 0.0.3, 0.0.2, 0.0.1 [master repo]
     - Subspecs:
       - VPay/Base (0.0.4)
       - VPay/AliPay (0.0.4)
       - VPay/WxPay (0.0.4)
       - VPay/UnionPay (0.0.4)
2 如果不能搜索到，说明你的库需要更新，通过`$ pod setup`更新本地的库
 
3 建立`Podfile`文件并输入

    target 'yourApp' do
    pod 'VPay'
    end
    
  注意: 如果只想导入特定的渠道，例如支付宝可以这样导入,在`Podfile`中输入
   
    target 'yourApp' do
    pod 'VPay/AliPay'
    end
  
 
4 然后执行 `pod install --verbose --no-repo-update`即可
   
   
 