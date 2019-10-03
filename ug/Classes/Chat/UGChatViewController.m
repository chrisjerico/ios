//
//  UGChatViewController.m
//  ug
//
//  Created by ug on 2019/9/21.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGChatViewController.h"

@interface UGChatViewController ()

@end

@implementation UGChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    int height = 60;
    
    if ([self.fromView isEqualToString:@"game"]) {
        height = 0;
    }
    
    if ([self.webTitle isEqualToString:@"聊天室"]) {
        if ([CMCommon isPhoneX]) {
            [self setWebViewFrame:CGRectMake(0, 0, UGScreenW, UGScerrnH - IPHONE_SAFEBOTTOMAREA_HEIGHT-height)];
 
        }else {
            [self setWebViewFrame:CGRectMake(0, 0, UGScreenW, UGScerrnH - height)];
        }
        
    }
}


- (void)viewWillAppear:(BOOL)animated {
    [super  viewWillAppear:animated];
    if ([self.webTitle isEqualToString:@"聊天室"]) {
        self.navigationController.navigationBarHidden = YES;
    }
    
    
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
