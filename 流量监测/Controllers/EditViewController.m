//
//  ViewController.m
//  流量监测
//
//  Created by 刘瑞龙 on 15/12/4.
//  Copyright © 2015年 刘瑞龙. All rights reserved.
//

#import "NetTool.h"
#import "LRLAlertView.h"
#import "ShowViewController.h"
#import "EditViewController.h"


@interface EditViewController ()

@property (nonatomic, strong) NSUserDefaults *groupUserDefaults;

@property (nonatomic,assign) double thisUseFlow;

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UITextField *allFlowTextField;
@property (weak, nonatomic) IBOutlet UITextField *hasUsedTextField;

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backButton.hidden = getTheAppdelegate().isFirstLaunch;
    
    if (!getTheAppdelegate().isFirstLaunch) {
        self.allFlowTextField.text = [NSString stringWithFormat:@"%.2f", self.allFlow];
        self.hasUsedTextField.text = [NSString stringWithFormat:@"%.2f", self.hasUsedFlow];
    }
}

- (IBAction)makeSureButtonAct:(id)sender {
    if (chargeIsANumber(self.allFlowTextField.text) && chargeIsANumber(self.hasUsedTextField.text) && (self.allFlowTextField.text.floatValue > self.hasUsedTextField.text.floatValue)) {
        [NetTool setAllFlow:self.allFlowTextField.text.doubleValue];
        [NetTool setHasUsedFlow:self.hasUsedTextField.text.doubleValue];
        
        [self.view endEditing:YES];
        if (getTheAppdelegate().isFirstLaunch) {
            ShowViewController *sV = [[ShowViewController alloc] init];
            UINavigationController *sN = [[UINavigationController alloc] initWithRootViewController:sV];
            sN.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:sN animated:YES completion:^{
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:FirstLaunchKey];
                    [[NSUserDefaults standardUserDefaults] synchronize];
            }];
        }else{
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }else{
        [LRLAlertView showAlertWithTitle:@"提示" andMessage:@"请输入正确的流量" andCancleButtonTitle:@"取消"];
    }
}
- (IBAction)backButtonAct:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

BOOL chargeIsANumber(NSString *string){
    NSString *regex1 = @"^[1-9]\\d*\\.\\d*|0\\.\\d*[1-9]\\d*|0?\\.0+|0$";
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex1];
    
    NSString *regex2 = @"^[1-9]\\d*|0$";
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
    
    return [predicate2 evaluateWithObject:string] || [predicate1 evaluateWithObject:string];
}

@end
