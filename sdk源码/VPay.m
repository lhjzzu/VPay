

//
//  VPay.m
//  VPay
//
//  Created by 蚩尤 on 16/5/14.
//  Copyright © 2016年 ouer. All rights reserved.
//

#import "VPay.h"
#import "VPayTool.h"
#import "VAliPayManager.h"
#import "VWxPayManager.h"
#import "VUnionPayManager.h"

static Class payClass;
static VPay *manager = nil;
static NSString *aliPay_scheme = nil;
static NSString *wxPay_scheme = nil;
@implementation VPay

+ (instancetype)manager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[VPay alloc] init];
    });
    return manager;
}



- (void)payWithOrderDic:(NSDictionary *)orderDic withType:(VPayType)type withScheme:(NSString *)scheme withViewController:(UIViewController *)viewController withCompletion:(VPayCompletion)completion
{
    BOOL isSupport = [self isSupportWithPayType:type withCompletion:completion];
    if (!isSupport) {
        return;
    }
    if (type == VPAYTYPE_ALIPAY) {
        
        if ([VPayTool isEmpty:scheme]) {
            if (completion) {
                completion(VPAY_INVALID,@"支付宝支付调起错误，没有传入scheme");
            }
            return;
        }
        aliPay_scheme = scheme;
        
        [[payClass manager] aliPayWithOrderDic:orderDic withScheme:scheme withCompletion:completion];
        
    } else if (type == VPAYTYPE_WX) {
        NSString *appId = [orderDic objectForKey:@"appId"];
      if ([VPayTool isEmpty:appId]) {
            if (completion) {
                completion(VPAY_INVALID,@"微信支付调起错误，字典中缺少appId");
            }
            return;
        }
        
        wxPay_scheme = appId;
        [[payClass manager] wxPayWithOrderDic:orderDic  withCompletion:completion];
    } else if (type == VPAYTYPE_UNION) {
        
        if (![viewController isKindOfClass:[UIViewController class]] || viewController == nil) {
            if (completion) {
                completion(VPAY_INVALID,@"银联支付调起错误，必须传入控制器");
            }
            return;
        }
        [[payClass manager] unionPayWithOrderDic:orderDic viewController:viewController withCompletion:completion];

    } else {
        if (completion) {
            completion(VPAY_INVALID,@"调起支付错误,请传入正确的支付类型");
        }
    }
}

- (void)handleOpenWithURL:(NSURL *)url withComletion:(VPayCompletion)completion
{
    if ([url.scheme isEqualToString:aliPay_scheme]) {
        [[payClass manager] handleOpenURL:url withCompletion:completion];
    } else if ([url.scheme isEqualToString:wxPay_scheme]) {
        [[payClass manager] handleOpenURL:url withCompletion:completion];
    }
}

- (BOOL)isSupportWithPayType:(VPayType)type withCompletion:(VPayCompletion)completion {

    if (type == VPAYTYPE_ALIPAY) {
        payClass = NSClassFromString(@"VAliPayManager");
        if (![payClass instancesRespondToSelector:@selector(aliPayWithOrderDic:withScheme:withCompletion:)]) {
            if (completion) {
                completion(VPAY_INVALID,@"调起支付宝支付错误，没有支付宝这个渠道");
            }
            return NO;
        }

    } else  if (type == VPAYTYPE_WX) {
        payClass = NSClassFromString(@"VWxPayManager");
        if (![payClass instancesRespondToSelector:@selector(wxPayWithOrderDic:withCompletion:)]) {
            if (completion) {
                completion(VPAY_INVALID,@"调起微信支付错误，没有微信这个渠道");
            }
            return NO;
        }
        
    } else  if (type == VPAYTYPE_UNION) {
        payClass = NSClassFromString(@"VUnionPayManager");
        if (![payClass instancesRespondToSelector:@selector(unionPayWithOrderDic:viewController:withCompletion:)]) {
            if (completion) {
                completion(VPAY_INVALID,@"调起银联支付错误，没有银联这个渠道");
            }
            return NO;
        }
    }
    
    return YES;
}
@end
