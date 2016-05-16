//
//  VAliPayManager.m
//  VPay
//
//  Created by 蚩尤 on 16/5/14.
//  Copyright © 2016年 ouer. All rights reserved.
//

#import "VAliPayManager.h"
#import <UIKit/UIKit.h>
#import <AlipaySDK/AlipaySDK.h>
#import <AlipaySDK/APayAuthInfo.h>
#import "VPayTool.h"
static VAliPayManager *manager;

@implementation VAliPayManager


+ (instancetype)manager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[VAliPayManager alloc] init];
        
    });
    return manager;
}

- (void)aliPayWithOrderDic:(NSDictionary *)orderDic withScheme:(NSString *)scheme withCompletion:(VPayCompletion)completion
{
    NSString *sign = orderDic[@"sign"];
    if ([VPayTool isEmpty:sign]) {
        if (completion) {
            completion(VPAY_INVALID,@"支付宝调起支付错误,支付签名sign缺失");
        }
    }
    
    if ([VPayTool isEmpty:scheme]) {
        if (completion) {
            completion(VPAY_CANCELED,@"支付宝调起支付错误,请传入支付宝回调的scheme");
        }
    }
    __weak typeof(self) wSelf = self;

    [[AlipaySDK defaultService] payOrder:sign fromScheme:scheme callback:^(NSDictionary *resultDic) {
        
        [wSelf handleResult:resultDic withCompletion:completion];
    }];
}

- (void)handleOpenURL:(NSURL *)url withCompletion:(VPayCompletion)completion
{
    __weak typeof(self) wSelf = self;
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        if (!wSelf) {
            return ;
        }
        [wSelf handleResult:resultDic withCompletion:completion];
        
    }];
}

- (void)handleResult:(NSDictionary *)resultDic withCompletion:(VPayCompletion)completion {
    
    VPayResultStatus status = 0;
    NSString * msg;
    switch ([[resultDic objectForKey:@"resultStatus"] intValue]) {
        case 9000:
            status = VPAY_SUCCESS;
            msg   = @"支付宝支付成功";
            break;
            
        case 6001:
            status = VPAY_CANCELED;
            msg   = @"支付宝支付取消";
            break;
            
        case 8000:
            status = VPAY_PENDING;
            msg   = @"支付宝支付结果确认中";
            break;
            
        default:
            status = VPAY_FAILED;
            msg   = @"支付宝支付失败";
            break;
    }
    /**
     9000 成功
     6001 用户取消
     8000 支付结果待确认
     --  失败
     */
    if (completion) {
        completion(status,msg);
    }
    
}

@end


