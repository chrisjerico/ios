//
//  FBTransitionViewController.m
//  UGBWApp
//
//  Created by ug on 2020/8/23.
//  Copyright © 2020 ug. All rights reserved.
//

#import "FBTransitionViewController.h"
#import "SUCache.h"
#import "UGRegisterViewController.h"
#import "UGLoginViewController.h"
@interface FBTransitionViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel; //XX 绑定账号
@end

@implementation FBTransitionViewController

- (BOOL)允许未登录访问 { return true; }
- (BOOL)允许游客访问 { return true; }

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title= @"欢迎登陆使用";
    self.titleLabel.text = [NSString stringWithFormat:@"%@尚未绑定账号，你可以：",self.name];
}

//  注册新账号 ==>注册界面
- (IBAction)registeredAction:(id)sender {

    
    UGRegisterViewController *registerVC = _LoadVC_from_storyboard_(@"UGRegisterViewController") ;
    [registerVC setIsfromFB:YES];
    [self.navigationController pushViewController:registerVC animated:YES];
        
    
}
//绑定已有账号==》登录界面
- (IBAction)bindingAction:(id)sender {

    
    UGLoginViewController *loginVC = _LoadVC_from_storyboard_(@"UGLoginViewController") ;
    loginVC.isfromFB = YES;
    [self.navigationController pushViewController:loginVC animated:YES];
}

@end
