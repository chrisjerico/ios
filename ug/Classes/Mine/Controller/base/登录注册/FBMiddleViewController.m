//
//  FBMiddleViewController.m
//  UGBWApp
//
//  Created by ug on 2020/8/22.
//  Copyright © 2020 ug. All rights reserved.
//

#import "FBMiddleViewController.h"

@interface FBMiddleViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel; //XX 绑定账号

@end

@implementation FBMiddleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [UGUserModel currentUser].username
}


//  注册新账号
- (IBAction)registeredAction:(id)sender {
}
//绑定已有账号
- (IBAction)bindingAction:(id)sender {
}

@end
