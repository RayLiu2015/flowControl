//
//  NetTool.h
//  流量监测
//
//  Created by 刘瑞龙 on 15/12/4.
//  Copyright © 2015年 刘瑞龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetTool : NSObject

+ (NSArray *)getDataCounters;

+(NSString *)getDataStringWithB:(long long)dataCount;

+(double)getDataWithB:(long long)data;

+(void)updateUseFlow;

/**
 * @b 设置已经用的流量
 */
+(void)setHasUsedFlow:(double)useFlow;

/**
 * @b 设置流量套餐
 */
+(void)setAllFlow:(double)allFlow;

/**
 * @b 获取已经用的流量
 */
+(double)getHasUsedFlow;

/**
 * @b 获取流量套餐
 */
+(double)getAllFlow;

/**
 * @b 到下个月的剩余时间;
 */
+(double)getLeftTime;

/**
 * @b 获取到下个月1号的天数字符串
 */
+(NSString *)getLeftTimeStr;

/**
 * @b 获取到下个月1号剩余流量的提示语;
 */
+(NSString *)getLeftFlowStr;
@end
