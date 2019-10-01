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
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//名字
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;//提示
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;//已签到（灰）补签（红）签到（蓝）




@end

@implementation UGRechargeTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
      [self setBackgroundColor: [[UGSkinManagers shareInstance] setCellbgColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setNameStr:(NSString *)nameStr {
    _nameStr = nameStr;
    self.nameLabel.text = nameStr;
    
}

- (void)setTipStr:(NSString *)tipStr {
    _tipStr = tipStr;
    self.tipLabel.text = tipStr;
    
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
    else if ([item.pid isEqualToString:@"bank_online"]||[item.pid isEqualToString:@"tenpay_online"]||[item.pid isEqualToString:@"yinlian_online"]) {
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
   
}
@end
