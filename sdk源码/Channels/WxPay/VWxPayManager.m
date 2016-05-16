


//
//  VWxPayManager.m
//  VPay
//
//  Created by 蚩尤 on 16/5/14.
//  Copyright © 2016年 ouer. All rights reserved.
//

#import "VWxPayManager.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "VPayTool.h"
static VWxPayManager *manager  = nil;

static VPayCompletion openCompletion;
static VPayCompletion payCompletion;

@interface VWxPayManager ()<WXApiDelegate>

@end
@implementation VWxPayManager

+ (instancetype)manager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[VWxPayManager alloc] init];
        
    });
    return manager;
}

- (void)wxPayWithOrderDic:(NSDictionary *)orderDic  withCompletion:(VPayCompletion)completion
{
    //appkey
    NSString *appId = [orderDic objectForKey:@"appId"];
    if ([VPayTool isEmpty:appId]) {
        if (completion) {
            completion(VPAY_INVALID,@"微信调起支付错误,字典中缺少微信平台注册得到的appId");
        }
        return;
    }
    //注册
    [WXApi registerApp:appId];
    
    
    PayReq *payReq= [[PayReq alloc]  init];
    payReq.partnerId = [orderDic objectForKey:@"partnerId"]?:@"";
    payReq.prepayId = [orderDic objectForKey:@"prepayId"]?:@"";
    payReq.nonceStr =[orderDic objectForKey:@"nonceStr"]?:@"";
    payReq.timeStamp = [[orderDic objectForKey:@"timeStamp"] intValue]?:0;
    payReq.package = @"Sign=WXPay";
    payReq.sign = [orderDic objectForKey:@"sign"]?:@"";
    [WXApi sendReq:payReq];
    payCompletion = completion;
}


- (void)handleOpenURL:(NSURL *)url withCompletion:(VPayCompletion)completion
{
    [WXApi handleOpenURL:url delegate:self];
    
    openCompletion = completion;
}

#pragma mark -- 微信的回调信息
- (void)onResp:(BaseResp *)resp
{
    VPayResultStatus status = 0;
    NSString *msg;
    if ([resp isKindOfClass:[PayResp class]]) {
        //支付返回结果，实际支付结果需要去微信服务器端查询
        switch (resp.errCode) {
            case 0:
                status = VPAY_SUCCESS;
                msg   = @"微信支付成功";
                break;
            case -1:
                status = VPAY_FAILED;
                msg   = @"微信支付失败";
                break;
            case -2:
                status = VPAY_CANCELED;
                msg   = @"微信支付取消";
                break;
            default:
                status = VPAY_FAILED;
                msg   = @"微信支付失败";
                break;
                
     }
        if (payCompletion) {
            payCompletion(status,msg);
        }
        
        if (openCompletion) {
            openCompletion(status,msg);
        }
  }
    
}
@end
