//
//  JYLoginViewController.m
//  ug
//
//  Created by ug on 2020/2/11.
//  Copyright © 2020 ug. All rights reserved.
//

#import "JYLoginViewController.h"
#import "UGEncryptUtil.h"
#import "STBarButtonItem.h"
#import "UGRegisterViewController.h"
#import <WebKit/WebKit.h>
#import "UGImgVcodeModel.h"
#import "UGSecurityCenterViewController.h"
#import "SLWebViewController.h"

@interface JYLoginViewController ()<UITextFieldDelegate,UINavigationControllerDelegate,WKScriptMessageHandler,WKNavigationDelegate,WKUIDelegate>
{
    NSString *ggCode;
    NSString *gCheckUserName;
}
@property (weak, nonatomic) IBOutlet UITextField *userNameTextF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextF;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;


@end

@implementation JYLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
