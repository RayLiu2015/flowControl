//
//  PublicTool.h
//  流量监测
//
//  Created by liuRuiLong on 15/12/9.
//  Copyright © 2015年 刘瑞龙. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AppDelegate.h"

@interface PublicTool : NSObject

AppDelegate * getTheAppdelegate();

UIWindow * getTheWindow();

@end
