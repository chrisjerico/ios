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
//@property (strong, nonatomic)  UIView *contentView;

@end


@implementation UGFundsTransferView

- (instancetype) UGFundsTransferView {
    NSBundle *bundle=[NSBundle mainBundle];
    NSArray *objs=[bundle loadNibNamed:@"UGFundsTransferView" owner:nil options:nil];
    return [objs lastObject];
}


-(void)initSubView{
    FastSubViewCode(self)

    subView(@"背景View").layer.borderColor= UGRGBColor(221, 221, 221).CGColor;
    subView(@"背景View").layer.borderWidth=1;
    subLabel(@"标题1label").textColor = Skin1.textColor1;
     subLabel(@"标题2label").textColor = Skin1.textColor1;
     subLabel(@"标题3label").textColor = Skin1.textColor1;
     subLabel(@"标题4label").textColor = Skin1.textColor1;
     subLabel(@"备注1label").textColor = Skin1.textColor1;
     subLabel(@"备注2label").textColor = Skin1.textColor1;
     subLabel(@"备注3label").textColor = Skin1.textColor1;
     subLabel(@"备注4label").textColor = Skin1.textColor1;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (!self.subviews.count) {
//        self.contentView = [self UGFundsTransferView];
//        CGRect frame = CGRectMake(0, 0, APP.Width, 208);
//        self.frame = frame;
//        self.contentView.frame = frame;
//        [self addSubview:self.contentView];
//        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self);
//        }];
//        [self initSubView];
        
        UGFundsTransferView *v = [[UGFundsTransferView alloc] initWithFrame:CGRectMake(0, 0,  APP.Width, 208)];
        [self addSubview:v];
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [self UGFundsTransferView];
        self.frame = frame;
        [self initSubView];
    }
    return self;
}




- (void)setItem:(UGchannelModel *)item {
    _item = item;
    FastSubViewCode(self)
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
         subLabel(@"标题1label").text = @"银行名称：";
         subLabel(@"标题2label").text = @"收款账号：";
         subLabel(@"标题3label").text = @"收款姓名：";
         subLabel(@"标题4label").text = @"支行名称：";
         subLabel(@"备注1label").text = item.address;
         subLabel(@"备注2label").text = item.account;
         subLabel(@"备注3label").text = item.domain;
         subLabel(@"备注4label").text = item.branchAddress;
    }
    else {
        subLabel(@"标题1label").text = @"银行名称：";
        subLabel(@"标题2label").text = @"银行账户：";
        subLabel(@"标题3label").text = @"收款姓名：";
        subLabel(@"标题4label").text = @"开户地址：";
        subLabel(@"备注1label").text = item.address;
        subLabel(@"备注2label").text = item.account;
        subLabel(@"备注3label").text = item.domain;
        subLabel(@"备注4label").text = item.branchAddress;
    }
}


#pragma mark - IBAction

- (IBAction)copyButton1Clicked:(id)sender {
    FastSubViewCode(self)
    [UIPasteboard generalPasteboard].string = subLabel(@"备注1label").text;
    [SVProgressHUD showInfoWithStatus:@"复制成功"];
}

- (IBAction)copyButton2Clicked:(id)sender {
    FastSubViewCode(self)
    [UIPasteboard generalPasteboard].string = subLabel(@"备注2label").text;
    [SVProgressHUD showInfoWithStatus:@"复制成功"];
}

- (IBAction)copyButton3Clicked:(id)sender {
    FastSubViewCode(self)
    [UIPasteboard generalPasteboard].string = subLabel(@"备注3label").text;
    [SVProgressHUD showInfoWithStatus:@"复制成功"];
}

- (IBAction)copyButton4Clicked:(id)sender {
    FastSubViewCode(self)
    [UIPasteboard generalPasteboard].string = subLabel(@"备注4label").text;
    [SVProgressHUD showInfoWithStatus:@"复制成功"];
}



@end
