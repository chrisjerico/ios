//
//  HomeTrademarkView.m
//  UGBWApp
//
//  Created by fish on 2020/10/16.
//  Copyright © 2020 ug. All rights reserved.
//

#import "HomeTrademarkView.h"

@interface HomeTrademarkView ()
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;  /**<   底部商标Label */
@property (weak, nonatomic) IBOutlet UILabel *bottomTitle;  /**<   底部内容文字 */
@property (weak, nonatomic) IBOutlet UIButton *preferentialBtn;/**<   底部优惠按钮 */
@end

@implementation HomeTrademarkView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setBackgroundColor:Skin1.navBarBgColor];
    [self setHidden:APP.isHideFoot];
    
    SANotificationEventSubscribe(UGNotificationWithSkinSuccess, self, ^(typeof (self) self, id obj) {
        // l001站点定制需求
        if ([APP.SiteId containsString:@"l001"]) {
            if (Skin1.isLH) {
                self.bottomTitle.text = @"💻电脑版";
                [self.preferentialBtn setHidden:YES];
            } else {
                self.bottomTitle.text = @"💻电脑版 🎁优惠活动";
                [self.preferentialBtn setHidden:NO];
            }
        }
        else{
            self.bottomTitle.text = @"💻电脑版 🎁优惠活动";
            [self.preferentialBtn setHidden:NO];
        }
        
        if (Skin1.is23||Skin1.isBlack) {
            [self.bottomTitle setTextColor:[UIColor whiteColor]];
             [self.bottomLabel setTextColor:[UIColor whiteColor]];
        }
    });
    
    SANotificationEventSubscribe(UGNotificationGetSystemConfigComplete, self, ^(typeof (self) self, id obj) {
        self.bottomLabel.text = [NSString stringWithFormat:@"COPYRIGHT © %@ RESERVED", SysConf.webName];
        
        if (Skin1.isTKL) {
            self.backgroundColor = [UIColor whiteColor];
        } else {
            self.backgroundColor = Skin1.isBlack || !SysConf.rankingListSwitch ? [UIColor clearColor] : Skin1.navBarBgColor;
        }
    });
}

#pragma mark - IBAction

- (IBAction)goPCVC:(id)sender {
    TGWebViewController *qdwebVC = [[TGWebViewController alloc] init];
    qdwebVC.url = pcUrl;
    qdwebVC.webTitle = UGSystemConfigModel.currentConfig.webName;
    [NavController1 pushViewController:qdwebVC animated:YES];
}

- (IBAction)goYOUHUIVC:(id)sender {
    [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGPromotionsController") animated:YES];
}

@end
