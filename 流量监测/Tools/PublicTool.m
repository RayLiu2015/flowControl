//
//  PublicTool.m
//  流量监测
//
//  Created by liuRuiLong on 15/12/9.
//  Copyright © 2015年 刘瑞龙. All rights reserved.
//

#import "PublicTool.h"

@implementation PublicTool

AppDelegate * getTheAppdelegate(){
    return [UIApplication sharedApplication].delegate;
}

UIWindow * getTheWindow(){
    return [UIApplication sharedApplication].keyWindow;
}

@end
