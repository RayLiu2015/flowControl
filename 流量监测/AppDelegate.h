//
//  AppDelegate.h
//  流量监测
//
//  Created by 刘瑞龙 on 15/12/4.
//  Copyright © 2015年 刘瑞龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, assign) CGFloat canUseData;

/**
 * @b 程序的第一次启动
 */
@property (nonatomic, assign) BOOL isFirstLaunch;

@end

