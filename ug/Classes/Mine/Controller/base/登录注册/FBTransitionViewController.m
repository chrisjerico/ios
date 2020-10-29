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
#import "JYLoginViewController.h"
#import "JYRegisterViewController.h"
#import "TKLRegisterViewController.h"           // 天空蓝版注册
#import "UGBMLoginViewController.h"
#import "UGBMRegisterViewController.h"
@interface FBTransitionViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel; //XX 绑定账号
@end

@implementation FBTransitionViewController

- (BOOL)允许未登录访问 { return true; }
- (BOOL)允许游客访问 { return true; }

-(void)viewWillAppear:(BOOL)animated{
    [self viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title= @"欢迎登陆使用";
    self.titleLabel.text = [NSString stringWithFormat:@"%@尚未绑定账号，你可以：",self.name];
}

//  注册新账号 ==>注册界面
- (IBAction)registeredAction:(id)sender {

    if (Skin1.isJY) {
        JYRegisterViewController *registerVC = _LoadVC_from_storyboard_(@"JYRegisterViewController") ;
        [registerVC setIsfromFB:YES];
        [self.navigationController pushViewController:registerVC animated:YES];
    }
    else if(Skin1.isTKL){
        TKLRegisterViewController *registerVC = _LoadVC_from_storyboard_(@"TKLRegisterViewController") ;
        [registerVC setIsfromFB:YES];
        [self.navigationController pushViewController:registerVC animated:YES];
    }
    else if(Skin1.isGPK){
        UGBMRegisterViewController *registerVC = _LoadVC_from_storyboard_(@"UGBMRegisterViewController") ;
        [registerVC setIsfromFB:YES];
        [self.navigationController pushViewController:registerVC animated:YES];
    }
    else {
        UGRegisterViewController *registerVC = _LoadVC_from_storyboard_(@"UGRegisterViewController") ;
        [registerVC setIsfromFB:YES];
        [self.navigationController pushViewController:registerVC animated:YES];
    }
   
        
    
}
//绑定已有账号==》登录界面
- (IBAction)bindingAction:(id)sender {

    if (Skin1.isJY||Skin1.isTKL) {
        JYLoginViewController *loginVC = _LoadVC_from_storyboard_(@"JYLoginViewController") ;
        loginVC.isfromFB = YES;
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    else if(Skin1.isGPK){
        UGBMLoginViewController *loginVC = _LoadVC_from_storyboard_(@"UGBMLoginViewController") ;
        loginVC.isfromFB = YES;
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    else {
        UGLoginViewController *loginVC = _LoadVC_from_storyboard_(@"UGLoginViewController") ;
        loginVC.isfromFB = YES;
        [self.navigationController pushViewController:loginVC animated:YES];
    }
   
}

@end
