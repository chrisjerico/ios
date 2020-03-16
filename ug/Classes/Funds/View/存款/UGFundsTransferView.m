//
//  UGFundsTransferView.m
//  ug
//
//  Created by ug on 2019/9/12.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGFundsTransferView.h"
#import "UGdepositModel.h"

@interface UGFundsTransferView ()

@property (weak, nonatomic) IBOutlet UIView *bgView;

//============================================================
@property (weak, nonatomic) IBOutlet UILabel *name1Label;

@property (weak, nonatomic) IBOutlet UILabel *name2Label;

@property (weak, nonatomic) IBOutlet UILabel *name3Label;

@property (weak, nonatomic) IBOutlet UILabel *name4Label;

@property (weak, nonatomic) IBOutlet UILabel *remark1Label;

@property (weak, nonatomic) IBOutlet UILabel *remark2Label;

@property (weak, nonatomic) IBOutlet UILabel *remark3Label;

@property (weak, nonatomic) IBOutlet UILabel *remark4Label;

@end


@implementation UGFundsTransferView

- (instancetype) UGFundsTransferView {
    NSBundle *bundle=[NSBundle mainBundle];
    NSArray *objs=[bundle loadNibNamed:@"UGFundsTransferView" owner:nil options:nil];
    return [objs lastObject];
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"UGFundsTransferView" owner:self options:0].firstObject;
        self.frame = frame;
        
        _bgView.layer.cornerRadius = 8;
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.borderColor= UGRGBColor(221, 221, 221).CGColor;
        _bgView.layer.borderWidth=1;
        _name1Label.textColor = Skin1.textColor1;
        _name2Label.textColor = Skin1.textColor1;
        _name3Label.textColor = Skin1.textColor1;
        _name4Label.textColor = Skin1.textColor1;
        _remark1Label.textColor = Skin1.textColor1;
        _remark2Label.textColor = Skin1.textColor1;
        _remark3Label.textColor = Skin1.textColor1;
        _remark4Label.textColor = Skin1.textColor1;
    }
    return self;
}

- (instancetype)initView {
    if (self = [super init]) {
        self = [self UGFundsTransferView];
    }
    _bgView.layer.cornerRadius = 8;
    _bgView.layer.masksToBounds = YES;
    _bgView.layer.borderColor= UGRGBColor(221, 221, 221).CGColor;
    _bgView.layer.borderWidth=1;
    return self;
}

- (void)setItem:(UGchannelModel *)item {
    _item = item;

    NSString *paymentid = item.paymentid;
     if([paymentid isEqualToString:@"alipay_transfer"]
        || [paymentid isEqualToString:@"tenpay_transfer"]
        || [paymentid isEqualToString:@"qqpay_transfer"]
        || [paymentid isEqualToString:@"wechat_alipay_transfer"]
        || [paymentid isEqualToString:@"jdzz_transfer"]
        || [paymentid isEqualToString:@"ddhb_transfer"]
        || [paymentid isEqualToString:@"wxsm_transfer"]
        || [paymentid isEqualToString:@"dshb_transfer"]
        || [paymentid isEqualToString:@"xlsm_transfer"]
        || [paymentid isEqualToString:@"zhifubao_transfer"]
        || [paymentid isEqualToString:@"wechat_transfer"]) {
         self.name1Label.text = @"银行名称：";
         self.name2Label.text = @"收款账号：";
         self.name3Label.text = @"收款姓名：";
         self.name4Label.text = @"支行名称：";
         self.remark1Label.text = item.address;
         self.remark2Label.text = item.account;
         self.remark3Label.text = item.domain;
         self.remark4Label.text = item.branchAddress;
    }
    else {
        self.name1Label.text = @"银行名称：";
        self.name2Label.text = @"银行账户：";
        self.name3Label.text = @"收款姓名：";
        self.name4Label.text = @"开户地址：";
        self.remark1Label.text = item.address;
        self.remark2Label.text = item.account;
        self.remark3Label.text = item.domain;
        self.remark4Label.text = item.branchAddress;
    }
}


#pragma mark - IBAction

- (IBAction)copyButton1Clicked:(id)sender {
    [UIPasteboard generalPasteboard].string = self.remark1Label.text;
    [SVProgressHUD showInfoWithStatus:@"复制成功"];
}

- (IBAction)copyButton2Clicked:(id)sender {
    [UIPasteboard generalPasteboard].string = self.remark2Label.text;
    [SVProgressHUD showInfoWithStatus:@"复制成功"];
}

- (IBAction)copyButton3Clicked:(id)sender {
    [UIPasteboard generalPasteboard].string = self.remark3Label.text;
    [SVProgressHUD showInfoWithStatus:@"复制成功"];
}

- (IBAction)copyButton4Clicked:(id)sender {
    [UIPasteboard generalPasteboard].string = self.remark4Label.text;
    [SVProgressHUD showInfoWithStatus:@"复制成功"];
}



@end
