//
//  UGSkinSeconCollectionHeadView.m
//  ug
//
//  Created by ug on 2019/10/2.
//  Copyright © 2019 ug. All rights reserved.    self.infoView.layer.cornerRadius = 10;
//

#import "UGSkinSeconCollectionHeadView.h"
#import "SLWebViewController.h"
#import "UGSystemConfigModel.h"
#import "UINavigationController+UGExtension.h"
#import "UGFundsViewController.h"
#import "UGBetRecordViewController.h"

@implementation UGSkinSeconCollectionHeadView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 1;
    self.layer.borderColor = UGRGBColor(231, 230, 230).CGColor;
}
- (IBAction)chongzhiAction:(id)sender {
    //存款
    UGUserModel *user = [UGUserModel currentUser];
    if (user.isTest) {
        [QDAlertView showWithTitle:@"温馨提示" message:@"请先登录您的正式账号" cancelButtonTitle:@"取消" otherButtonTitle:@"马上登录" completionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                SANotificationEventPost(UGNotificationShowLoginView, nil);
            }
        }];
    }else {
        
        UGFundsViewController *fundsVC = [[UGFundsViewController alloc] init];
        fundsVC.selectIndex = 2;
        [[UINavigationController currentNC] pushViewController:fundsVC animated:YES];
    }
}
- (IBAction)tixianAcition:(id)sender {
    //存款
    UGUserModel *user = [UGUserModel currentUser];
    if (user.isTest) {
        [QDAlertView showWithTitle:@"温馨提示" message:@"请先登录您的正式账号" cancelButtonTitle:@"取消" otherButtonTitle:@"马上登录" completionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                SANotificationEventPost(UGNotificationShowLoginView, nil);
            }
        }];
    }else {
        
        UGFundsViewController *fundsVC = [[UGFundsViewController alloc] init];
        fundsVC.selectIndex = 3;
        [[UINavigationController currentNC] pushViewController:fundsVC animated:YES];
    }
}
- (IBAction)touzhuAction:(id)sender {
    if ([UGUserModel currentUser].isTest) {
        [QDAlertView showWithTitle:@"温馨提示" message:@"请先登录您的正式账号" cancelButtonTitle:@"取消" otherButtonTitle:@"马上登录" completionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                SANotificationEventPost(UGNotificationShowLoginView, nil);
            }
        }];
    } else {
        UGBetRecordViewController *betRecordVC = [[UGBetRecordViewController alloc] init];
        [[UINavigationController currentNC] pushViewController:betRecordVC animated:YES];
    }
}
- (IBAction)kehuaAction:(id)sender {
    
    SLWebViewController *webViewVC = [[SLWebViewController alloc] init];
    UGSystemConfigModel *config = [UGSystemConfigModel currentConfig];
    if (config.zxkfUrl) {
        
        webViewVC.urlStr = config.zxkfUrl;
    }
    [[UINavigationController currentNC] pushViewController:webViewVC animated:YES];
}

@end
