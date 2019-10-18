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
    UGFundsViewController *fundsVC = [[UGFundsViewController alloc] init];
    fundsVC.selectIndex = 2;
    [NavController1 pushViewController:fundsVC animated:YES];
}

- (IBAction)tixianAcition:(id)sender {
    //存款
    UGFundsViewController *fundsVC = [[UGFundsViewController alloc] init];
    fundsVC.selectIndex = 3;
    [NavController1 pushViewController:fundsVC animated:YES];
}

- (IBAction)touzhuAction:(id)sender {
    [NavController1 pushViewController:[UGBetRecordViewController new] animated:YES];
}

- (IBAction)kehuaAction:(id)sender {
    SLWebViewController *webViewVC = [[SLWebViewController alloc] init];
    UGSystemConfigModel *config = [UGSystemConfigModel currentConfig];
    if (config.zxkfUrl > 0) {
        webViewVC.urlStr = config.zxkfUrl;
		[NavController1 pushViewController:webViewVC animated:YES];
    }
}

@end
