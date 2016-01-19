//
//  LRLAlertView.m
//  LRLAlertDemo
//
//  Created by 刘瑞龙 on 15/8/12.
//  Copyright (c) 2015年 V1. All rights reserved.
//

#import "LRLAlertView.h"

@interface LRLAlertView ()

/**
 *@b选取某个按钮后的回调
 */
@property (nonatomic, copy) void (^chooseBlock)(NSInteger buttonIndex);

@end

@implementation LRLAlertView

+(void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message andCancleButtonTitle:(NSString *)cancleButtonTitle{
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        UIAlertController * AC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:cancleButtonTitle style:UIAlertActionStyleCancel handler:nil];
        [AC addAction:action];
        
        UIViewController *VC = [[[UIApplication sharedApplication].delegate window] rootViewController];
        UIViewController *tempVC = nil;
        if (VC.presentedViewController) {
            tempVC = VC.presentedViewController;
        }else{
            tempVC = VC;
        }
        [tempVC presentViewController:AC animated:YES completion:nil];
     }else{
         UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancleButtonTitle otherButtonTitles:nil, nil];
         [alertView show];
    }
}

+(void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message andCancleButtonTitle:(NSString *)cancleButtonTitle andButtonArr:(NSArray *)buttonArr andChooseBlock:(void (^)(NSInteger))chooseBlock{
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        UIAlertController * AC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        
        __weak UIAlertController * weakAc = AC;
        UIAlertAction * cancleAct = [UIAlertAction actionWithTitle:cancleButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
            NSInteger index = [weakAc.actions indexOfObject:action];
            if (chooseBlock) {
                chooseBlock(index);
            }
        }];
        [AC addAction:cancleAct];
        
        for (int i = 0; i < buttonArr.count; i++) {
            UIAlertAction * action = [UIAlertAction actionWithTitle:buttonArr[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                NSInteger index = [weakAc.actions indexOfObject:action];
                if (chooseBlock) {
                    chooseBlock(index);
                }
            }];
            [weakAc addAction:action];
        }
        
        UIViewController *VC = [[[UIApplication sharedApplication].delegate window] rootViewController];
        UIViewController *tempVC = nil;
        if (VC.presentedViewController) {
            tempVC = VC.presentedViewController;
        }else{
            tempVC = VC;
        }
        [tempVC presentViewController:AC animated:YES completion:nil];
    }else{
        LRLAlertView *av = [[LRLAlertView alloc] init];
        av.delegate = av;
        av.title = title;
        av.message = message;
        av.cancelButtonIndex = 0;
        av.chooseBlock = chooseBlock;
        [av addButtonWithTitle:cancleButtonTitle];
        for (NSString * btnTitle in buttonArr) {
            [av addButtonWithTitle:btnTitle];
        }
        [av show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (self.chooseBlock) {
        self.chooseBlock(buttonIndex);
    }
}

@end
