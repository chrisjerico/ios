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
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *name2Label;

@property (weak, nonatomic) IBOutlet UILabel *name3Label;

@property (weak, nonatomic) IBOutlet UILabel *name4Label;

@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;

@property (weak, nonatomic) IBOutlet UILabel *remark2Label;

@property (weak, nonatomic) IBOutlet UILabel *remark3Label;

@property (weak, nonatomic) IBOutlet UILabel *remark4Label;



@end

@implementation UGFundsTransferView



-(instancetype) UGFundsTransferView{
    
    
    NSBundle *bundle=[NSBundle mainBundle];
    NSArray *objs=[bundle loadNibNamed:@"UGFundsTransferView" owner:nil options:nil];
    return [objs lastObject];
    
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"UGFundsTransferView" owner:self options:0].firstObject;
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
        
        _bgView.layer.cornerRadius = 8;
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.borderColor= UGRGBColor(221, 221, 221).CGColor;
        _bgView.layer.borderWidth=1;
        
        [self setBackgroundColor: [UIColor whiteColor]];

        
        
    }
    return self;
    
}

-(instancetype)initView{
    
    if (self = [super init]) {
        self = [self UGFundsTransferView];
    }
    
    _bgView.layer.cornerRadius = 8;
    _bgView.layer.masksToBounds = YES;
    _bgView.layer.borderColor= UGRGBColor(221, 221, 221).CGColor;
    _bgView.layer.borderWidth=1;
    [self setBackgroundColor: [[UGSkinManagers shareInstance] setbgColor]];

    
    return self;
    
}


#pragma mark - 其他方法

- (IBAction)copyButton1Clicked:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.remarkLabel.text;
    [SVProgressHUD showInfoWithStatus:@"复制成功"];
}

- (IBAction)copyButton2Clicked:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.remark2Label.text;
    [SVProgressHUD showInfoWithStatus:@"复制成功"];
}

- (IBAction)copyButton3Clicked:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.remark3Label.text;
    [SVProgressHUD showInfoWithStatus:@"复制成功"];
}

- (IBAction)copyButton4Clicked:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.remark4Label.text;
    [SVProgressHUD showInfoWithStatus:@"复制成功"];
}


- (void)setItem:(UGchannelModel *)item {
    _item = item;
    
    self.remarkLabel.text = item.address;
    self.remark2Label.text = item.domain;
    self.remark3Label.text = item.account;
    self.remark4Label.text = item.branchAddress;
    
    
    NSString *paymentid = item.paymentid;
     if([paymentid isEqualToString:@"alipay_transfer"]||[paymentid isEqualToString:@"tenpay_transfer"]||[paymentid isEqualToString:@"qqpay_transfer"]||[paymentid isEqualToString:@"wechat_alipay_transfer"]||[paymentid isEqualToString:@"jdzz_transfer"]||[paymentid isEqualToString:@"ddhb_transfer"]||[paymentid isEqualToString:@"wxsm_transfer"]||[paymentid isEqualToString:@"dshb_transfer"]||[paymentid isEqualToString:@"xlsm_transfer"]||[paymentid isEqualToString:@"zhifubao_transfer"]) {
        self.nameLabel.text = @"收款姓名：";
        self.name2Label.text = @"收款账号：";
        self.name3Label.text = @"银行名称：";
        self.name4Label.text = @"支行名称：";
    }
    else{
        self.nameLabel.text = @"银行名称：";
              self.name2Label.text = @"收款姓名：";
              self.name3Label.text = @"银行账户：";
              self.name4Label.text = @"开户地址：";
    }
 
    
}
@end
