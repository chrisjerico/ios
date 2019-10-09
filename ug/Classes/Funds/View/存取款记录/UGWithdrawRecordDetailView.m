//
//  UGWithdrawRecordDetailView.m
//  ug
//
//  Created by ug on 2019/9/1.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGWithdrawRecordDetailView.h"
#import "UGRechargeLogsModel.h"
@interface UGWithdrawRecordDetailView()

@property (weak, nonatomic) IBOutlet UILabel *orderNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *applyLabel;
@property (weak, nonatomic) IBOutlet UILabel *amoutLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankCardLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankAccountLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;



@end

@implementation UGWithdrawRecordDetailView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"UGWithdrawRecordDetailView" owner:self options:0].firstObject;
        self.frame = frame;
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        [self setBackgroundColor: [[UGSkinManagers shareInstance] setbgColor]];

    }
    
    return self;
}

- (void)setItem:(UGRechargeLogsModel *)item {
    _item = item;
    self.orderNoLabel.text = [NSString stringWithFormat:@"交易编号：%@",item.orderNo];
    self.applyLabel.text = [NSString stringWithFormat:@"申请时间：%@",item.applyTime];
    self.statusLabel.text = [NSString stringWithFormat:@"交易状态：%@",item.status];
    self.amoutLabel.text = [NSString stringWithFormat:@"取款金额：%@",item.amount];
    self.bankCardLabel.text = [NSString stringWithFormat:@"银行卡号：%@",item.bankCard];
    self.bankAccountLabel.text = [NSString stringWithFormat:@"银行账户：%@",item.bankAccount];
    self.remarkLabel.text  = [NSString stringWithFormat:@"备注：%@",item.remark];
}


- (IBAction)closeClick:(id)sender {
    [self hiddenSelf];
    
}

- (void)show {
    
    UIWindow* window = UIApplication.sharedApplication.keyWindow;
    UIView* maskView = [[UIView alloc] initWithFrame:window.bounds];
    UIView* view = self;
    view.hidden = NO;
    
    maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    maskView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    [maskView addSubview:view];
    [window addSubview:maskView];
    
}

- (void)hiddenSelf {
    
    UIView* view = self;
    self.superview.backgroundColor = [UIColor clearColor];
    [view.superview removeFromSuperview];
    [view removeFromSuperview];
    
}

@end
