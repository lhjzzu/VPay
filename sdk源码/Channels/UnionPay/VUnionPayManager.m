


//
//  VUnionPayManager.m
//  VPay
//
//  Created by 蚩尤 on 16/5/14.
//  Copyright © 2016年 ouer. All rights reserved.
//

#import "VUnionPayManager.h"
#import "UPPayPlugin.h"
#import "UPPayPluginDelegate.h"
#import "VPayTool.h"
static VUnionPayManager *manger;
static VPayCompletion payCompletion;

@interface VUnionPayManager ()<UPPayPluginDelegate>

@end
@implementation VUnionPayManager

+ (instancetype)manager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manger = [[VUnionPayManager alloc] init];
    });
    return manger;
}

- (void)unionPayWithOrderDic:(NSDictionary *)orderDic viewController:(UIViewController *)viewController withCompletion:(VPayCompletion)completion
{
    
    NSString *sign = [orderDic objectForKey:@"sign"];
    if ([VPayTool isEmpty:sign]) {
        completion(VPAY_INVALID,@"银联调起支付错误,缺少订单签名字符串sign");
        return;
    }
 
    [UPPayPlugin startPay:sign mode:@"00" viewController:viewController delegate:self];
    payCompletion = completion;
}

- (void)UPPayPluginResult:(NSString *)result
{
    VPayResultStatus status = 0;
    NSString *msg = nil;
    if ([result isEqual:@"success"]) {
        status = VPAY_SUCCESS;
        msg = @"银联支付成功";
    }else if ([result isEqual:@"fail"]) {
        status = VPAY_FAILED;
        msg = @"银联支付失败";
    }else if ([result isEqual:@"cancel"]) {
        status = VPAY_CANCELED;
        msg = @"银联支付取消";
    }
    
    if (payCompletion) {
        payCompletion(status,msg);
    }

}
@end
