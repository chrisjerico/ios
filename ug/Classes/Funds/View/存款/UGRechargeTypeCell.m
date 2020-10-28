//
//  UGRechargeTypeCell.m
//  ug
//
//  Created by ug on 2019/5/3.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGRechargeTypeCell.h"
#import "UGdepositModel.h"

@interface UGRechargeTypeCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;            /**<   标题Label */
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;             /**<   备注Label */
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;  /**<   已签到（灰）补签（红）签到（蓝） */
@end


@implementation UGRechargeTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    if (APP.isBgColorForMoneyVC) {
        self.backgroundColor  = Skin1.bgColor;
        self.nameLabel.textColor = [UIColor whiteColor];
    } else if (Skin1.isBlack) {
        self.backgroundColor = Skin1.homeContentColor;
        self.nameLabel.textColor = Skin1.textColor1;
    }
    
    self.mBtn.layer.cornerRadius = 5;
    self.mBtn.layer.borderWidth = 1;
    self.mBtn.layer.borderColor = [RGBA(28, 136, 255, 1) CGColor];
}

- (void)setNameStr:(NSString *)nameStr {
    _nameStr = nameStr;
    self.nameLabel.text = nameStr;
    
     if (nameStr.isHtmlStr) {
         self.nameLabel.attributedText = ({
             NSMutableAttributedString *mas = [[NSAttributedString alloc] initWithData:[nameStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil].mutableCopy;
             // 替换文字颜色
             NSAttributedString *as = [mas copy];
             for (int i=0; i<as.length; i++) {
                 NSRange r = NSMakeRange(0, as.length);
                 NSMutableDictionary *dict = [as attributesAtIndex:i effectiveRange:&r].mutableCopy;
                 UIColor *c = dict[NSForegroundColorAttributeName];
                 if (fabs(c.red - c.green) < 0.05 && fabs(c.green - c.blue) < 0.05) {
                     if (APP.isBgColorForMoneyVC) {
                         dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
                     } else {
                         dict[NSFontAttributeName] = Skin1.textColor2;
                     }
                     [mas addAttributes:dict range:NSMakeRange(i, 1)];
                 }
             }
             
             NSLog(@"string = %@",mas.string);
             
             mas;
         });
         [self.nameLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
     }
     else{
        [self.nameLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
     }

}

- (void)setTipStr:(NSString *)tipStr {
    
    _tipStr = tipStr;
    self.tipLabel.text = tipStr;
    if (tipStr.isHtmlStr) {
            self.tipLabel.attributedText = ({
            NSMutableAttributedString *mas = [[NSAttributedString alloc] initWithData:[tipStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil].mutableCopy;
            // 替换文字颜色
            NSAttributedString *as = [mas copy];
            for (int i=0; i<as.length; i++) {
                NSRange r = NSMakeRange(0, as.length);
                NSMutableDictionary *dict = [as attributesAtIndex:i effectiveRange:&r].mutableCopy;
                UIColor *c = dict[NSForegroundColorAttributeName];
                if (fabs(c.red - c.green) < 0.05 && fabs(c.green - c.blue) < 0.05) {
                    if (APP.isBgColorForMoneyVC) {
                        dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
                    } else {
                        dict[NSForegroundColorAttributeName] = Skin1.textColor2;
                    }
                    [mas addAttributes:dict range:NSMakeRange(i, 1)];
                }
            }
            mas;
        });
        
    } else {
        [self.tipLabel setTextColor:RGBA(47, 156, 243, 1)];
    }

}

- (void)setHeaderImageStr:(NSString *)headerImageStr {
    _headerImageStr= headerImageStr;
    self.headerImageView.image = [UIImage imageNamed:headerImageStr];
}

- (void)setItem:(UGpaymentModel *)item {
    _item = item;
    [self setNameStr:item.name];
    [self setTipStr:item.tip];
    
    NSMutableDictionary *imgDict = @{
        @"wechat_online"            :@"wechat_online",  // 微信在线支付
        @"wxzsm_transfer"           :@"wechat_online",  // 微信
        @"wechat_transfer"          :@"wechat_online",  // 微信转账
        @"wxsm_transfer"            :@"wechat_online",  // 微信扫码
        
        @"wechat_alipay_transfer"   :@"wx_zfb",         // 微信支付宝转账
        @"wxzfbsm_transfer"         :@"wx_zfb",         // 微信支付宝扫码
        
        @"alipay_online"            :@"zfb_icon",       // 支付宝在线支付
        @"alihb_online"             :@"zfb_icon",       // 支付宝红包支付
        @"zhifubao_transfer"        :@"zfb_icon",       // 支付宝扫码
        @"alipay_transfer"          :@"zfb_icon",       // 支付宝转账
        @"zfbzyhk_transfer"         :@"zfb_icon",       // 支付宝转银行卡
        
        @"bank_transfer"            :@"transfer",       // 银行转账
        @"yinlian_online"           :@"bank_online",    // 银联钱包在线支付
        @"bank_online"              :@"bank_online",   // 网银在线支（用银联图标，还是快捷支付图标？）
        @"quick_online"             :@"quick_online",   // 快捷支付
        
        @"jingdong_online"          :@"jd",             // 京东钱包在线支付
        @"jdzz_transfer"            :@"jd",             // 京东钱包转账
        
        @"tenpay_online"            :@"yunshanfu",      // 云闪付在线支付
        @"yunshanfu_transfer"       :@"yunshanfu",      // 云闪付
        @"ysf_transfer"            :@"yunshanfu",      // 云闪付在线支付
        
        @"qq_online"                :@"qq_online",      // QQ钱包在线支付
        @"qqpay_transfer"           :@"qq_online",      // QQ钱包转账
        
        @"baidu_online"             :@"baidu",          // 百度钱包在线支付
        @"tenpay_transfer"          :@"cft_icon",       // 财付通转账
        @"xnb_online"               :@"xnb_icon",       // 虚拟币在线
        @"xnb_transfer"             :@"USDT",           // 虚拟币充值
        
        @"dk_online"                :@"xnb_icon",       // 点卡支付
        @"ddhb_transfer"            :@"dingding",       // 钉钉红包
        @"dshb_transfer"            :@"duosan",         // 多闪红包
        @"xlsm_transfer"            :@"xlsm",           // 闲聊扫码
        @"yxsm_transfer"            :@"yxsm_transfer_icon",           // 易信扫码
        @"huobi_online"             :@"huobi_online",    // 火币
        @"aliyin_transfer"          :@"aliyin_transfer",    // 支付宝银联
    }.mutableCopy;
    
    [self setHeaderImageStr:imgDict[item.pid]];
}
@end
