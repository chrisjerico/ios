//
//  FBMiddleViewController.m
//  UGBWApp
//
//  Created by ug on 2020/8/22.
//  Copyright © 2020 ug. All rights reserved.
//

#import "FBMiddleViewController.h"
#import "SUCache.h"
#import "UGRegisterViewController.h"
#import "UGLoginViewController.h"
@interface FBMiddleViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel; //XX 绑定账号

@end

@implementation FBMiddleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@尚未绑定账号，你可以：",[UGUserModel currentUser].username];
}


//  注册新账号 ==>注册界面
- (IBAction)registeredAction:(id)sender {
    NSInteger slot = 0;
    NSString *uuid =  [SUCache itemForSlot:slot].profile.userID;
    NSString *name =  [SUCache itemForSlot:slot].profile.name;
//    FBSDKAccessToken *token = [SUCache itemForSlot:slot].token;

    NSArray *arry = [[NSArray alloc] initWithObjects:@{@"uuid":uuid},@{@"name":name},@{@"platform":@"facebook"}, nil];
    
    UGRegisterViewController *registerVC = _LoadVC_from_storyboard_(@"UGRegisterViewController") ;
    
    [registerVC setFbArrary:arry];
    [self.navigationController pushViewController:registerVC animated:YES];
        
    
}
//绑定已有账号==》登录界面
- (IBAction)bindingAction:(id)sender {

    
    UGLoginViewController *loginVC = _LoadVC_from_storyboard_(@"UGLoginViewController") ;
    loginVC.isfromFB = YES;
   
    [self.navigationController pushViewController:loginVC animated:YES];
}

@end
