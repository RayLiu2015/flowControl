//
//  LRLAlertView.h
//  LRLAlertDemo
//
//  Created by 刘瑞龙 on 15/8/12.
//  Copyright (c) 2015年 V1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LRLAlertView : UIAlertView<UIAlertViewDelegate>

/**
 *@b弹出只有一个取消按钮的block
 */
+(void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message andCancleButtonTitle:(NSString *)buttonTitle;

/**
 *@b弹出带有block的alert. block中index取消按钮index为0,其他按钮从1开始
 */
+(void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message andCancleButtonTitle:(NSString *)buttonTitle andButtonArr:(NSArray *)buttonArr andChooseBlock:(void (^)(NSInteger))chooseBlock;

@end
