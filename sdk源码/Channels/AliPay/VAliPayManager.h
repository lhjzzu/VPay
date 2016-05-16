//
//  AliPayManager.h
//  VPay
//
//  Created by 蚩尤 on 16/5/14.
//  Copyright © 2016年 ouer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VPay.h"
@interface VAliPayManager : NSObject

/**
 *  支付宝支付单例
 *
 */

+ (instancetype)manager;
/**
 *  调起支付宝支付
 *
 *  @param orderDic   订单信息字典
 *  @param scheme     调用支付的app注册在info.plist中的scheme
 *  @param completion 支付结果的回调
 */
- (void)aliPayWithOrderDic:(NSDictionary *)orderDic withScheme:(NSString *)scheme withCompletion:(VPayCompletion)completion;

/**
 *  处理钱包或者独立快捷app支付跳回商户app携带的支付结果Url
 *
 *  @param url 支付结果url，传入后由SDK解析，统一在上面的pay方法的callback中回调
 *  @param completion 跳钱包支付结果回调，保证跳转钱包支付过程中，即使调用方app被系统kill时，能通过这个回调取到支付结果。
 */
- (void)handleOpenURL:(NSURL *)url withCompletion:(VPayCompletion)completion;

@end
