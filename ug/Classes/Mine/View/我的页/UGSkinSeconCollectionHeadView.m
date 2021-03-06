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
#import "UINavigationController+Extension.h"
#import "UGFundsViewController.h"
#import "UGBetRecordViewController.h"

@implementation UGSkinSeconCollectionHeadView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 1;
    self.layer.borderColor = UGRGBColor(231, 230, 230).CGColor;
}

// 充值
- (IBAction)chongzhiAction:(id)sender {
    UGFundsViewController *fundsVC = _LoadVC_from_storyboard_(@"UGFundsViewController");
    fundsVC.selectIndex = 2;
    [NavController1 pushViewController:fundsVC animated:YES];
}

// 体现
- (IBAction)tixianAcition:(id)sender {
    UGFundsViewController *fundsVC = _LoadVC_from_storyboard_(@"UGFundsViewController");
    fundsVC.selectIndex = 3;
    [NavController1 pushViewController:fundsVC animated:YES];
}

// 投注记录
- (IBAction)touzhuAction:(id)sender {
    [NavController1 pushViewController:[UGBetRecordViewController new] animated:YES];
}

// 在线客服
- (IBAction)kehuaAction:(id)sender {
    [NavController1 pushVCWithUserCenterItemType:UCI_在线客服];
}

@end
