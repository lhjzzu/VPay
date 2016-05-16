//
//  UnionPayManager.h
//  VPay
//
//  Created by 蚩尤 on 16/5/14.
//  Copyright © 2016年 ouer. All rights reserved.
//

#import "VPay.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface VUnionPayManager : NSObject
/**
 *
 *  银联支付单例
 *
 */

+ (instancetype)manager;
/**
 *  调起银联支付
 *
 *  @param orderDic       签名信息字典
 *  @param viewController 调起支付的视图控制器
 *  @param completion     支付结果回调
 */
- (void)unionPayWithOrderDic:(NSDictionary *)orderDic viewController:(UIViewController *)viewController withCompletion:(VPayCompletion)completion;

@end
