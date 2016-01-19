//
//  ShowViewController.m
//  流量监测
//
//  Created by liuRuiLong on 15/12/8.
//  Copyright © 2015年 刘瑞龙. All rights reserved.
//

#import "NetTool.h"
#import "ShowViewController.h"
#import "EditViewController.h"

@interface ShowViewController ()
@property (weak, nonatomic) IBOutlet UILabel *showFlowLabel;

@end

@implementation ShowViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.showFlowLabel.text = [NetTool getLeftFlowStr];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"重新设置" style:UIBarButtonItemStylePlain target:self action:@selector(settingAct)];
    self.navigationItem.leftBarButtonItem = item;
    
    [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(updateFlow) userInfo:nil repeats:YES];
}
-(void)updateFlow{
    [NetTool updateUseFlow];
    self.showFlowLabel.text = [NetTool getLeftFlowStr];
}
- (IBAction)testButtonAct:(id)sender {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"prefs:root=MOBILE_DATA_SETTINGS_ID"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=MOBILE_DATA_SETTINGS_ID"]];
    }else{
        NSLog(@"不能打开");
    }
}

-(void)settingAct{
    if (getTheAppdelegate().isFirstLaunch) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else{
        EditViewController *edit = [[EditViewController alloc] init];
        edit.hasUsedFlow = [NetTool getHasUsedFlow];
        edit.allFlow = [NetTool getAllFlow];
        edit.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self.navigationController presentViewController:edit animated:YES completion:^{
        }];
    }
}
@end
