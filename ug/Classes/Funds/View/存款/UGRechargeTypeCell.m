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
    self.backgroundColor = [UIColor clearColor];
    self.nameLabel.textColor = Skin1.textColor1;
}

- (void)setNameStr:(NSString *)nameStr {
    _nameStr = nameStr;
    self.nameLabel.text = nameStr;
}

- (void)setTipStr:(NSString *)tipStr {
    _tipStr = tipStr;
    self.tipLabel.attributedText = ({
        NSMutableAttributedString *mas = [[NSAttributedString alloc] initWithData:[tipStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil].mutableCopy;
        // 替换文字颜色
        NSAttributedString *as = [mas copy];
        for (int i=0; i<as.length; i++) {
            NSRange r = NSMakeRange(0, as.length);
            NSMutableDictionary *dict = [as attributesAtIndex:i effectiveRange:&r].mutableCopy;
            UIColor *c = dict[NSForegroundColorAttributeName];
            if (fabs(c.red - c.green) < 0.05 && fabs(c.green - c.blue) < 0.05) {
                dict[NSForegroundColorAttributeName] = Skin1.textColor2;
                [mas addAttributes:dict range:NSMakeRange(i, 1)];
            }
        }
        mas;
    });
}

- (void)setHeaderImageStr:(NSString *)headerImageStr {
    _headerImageStr= headerImageStr;
    self.headerImageView.image = [UIImage imageNamed:headerImageStr];
}

- (void)setItem:(UGpaymentModel *)item {
    _item = item;
    
    [self setNameStr:item.name];
    [self setTipStr:item.tip];
    
    if ([item.pid isEqualToString:@"alipay_online"]||[item.pid isEqualToString:@"alipay_transfer"]||[item.pid isEqualToString:@"jingdong_online"]||[item.pid isEqualToString:@"zhifubao_transfer"]) {
        [self setHeaderImageStr:@"zfb_icon"];
    }
    else if ([item.pid isEqualToString:@"wechat_online"]||[item.pid isEqualToString:@"wechat_transfer"]||[item.pid isEqualToString:@"xnb_online"]||[item.pid isEqualToString:@"dk_online"]||[item.pid isEqualToString:@"wxsm_transfer"]) {
        [self setHeaderImageStr:@"wechat_online"];
    }
    else if ([item.pid isEqualToString:@"bank_transfer"]) {
        [self setHeaderImageStr:@"transfer"];
    }
    else if ([item.pid isEqualToString:@"bank_online"]||[item.pid isEqualToString:@"yinlian_online"]) {
        [self setHeaderImageStr:@"bank_online"];
    }
    else if ([item.pid isEqualToString:@"tenpay_transfer"]) {
        [self setHeaderImageStr:@"cft_icon"];
    }
    else if ([item.pid isEqualToString:@"tenpay_transfer"]) {//财付通转账
        [self setHeaderImageStr:@"cft_icon"];
    }
    else if ([item.pid isEqualToString:@"qq_online"]||[item.pid isEqualToString:@"qqpay_transfer"]) {//QQ钱包在线支付
        [self setHeaderImageStr:@"qq_online"];
    }
    else if ([item.pid isEqualToString:@"baidu_online"]) {//百度钱包在线支付
        [self setHeaderImageStr:@"baidu"];
    }
    else if ([item.pid isEqualToString:@"quick_online"]) {//银联快捷支付[成功率100%]
        [self setHeaderImageStr:@"quick_online"];
    }
    else if ([item.pid isEqualToString:@"yunshanfu_transfer"]) {//云闪付[成功率100%]
        [self setHeaderImageStr:@"yunshanfu"];
    }
    else if ([item.pid isEqualToString:@"wechat_alipay_transfer"]) {//微信,支付宝转账[成功率100%]
        [self setHeaderImageStr:@"wx_zfb"];
    }
    else if ([item.pid isEqualToString:@"alihb_online"]) {//支付宝扫码支付成功率100%"
        [self setHeaderImageStr:@"xnb_icon"];
    }
    else if ([item.pid isEqualToString:@"jdzz_transfer"]) {//京东钱包转账
        [self setHeaderImageStr:@"jd"];
    }
    else if ([item.pid isEqualToString:@"ddhb_transfer"]) {//钉钉红包
        [self setHeaderImageStr:@"dingding"];
    }
    else if ([item.pid isEqualToString:@"dshb_transfer"]) {//多闪红包
        [self setHeaderImageStr:@"duosan"];
    }
    else if ([item.pid isEqualToString:@"xlsm_transfer"]) {//闲聊扫码
        [self setHeaderImageStr:@"xlsm"];
    }
    else if ([item.pid isEqualToString:@"tenpay_online"]) {//云闪付
        [self setHeaderImageStr:@"yunshanfu"];
    }
   
}
@end
