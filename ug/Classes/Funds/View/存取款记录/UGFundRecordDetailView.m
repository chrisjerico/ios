//
//  UGFundRecordDetailView.m
//  ug
//
//  Created by ug on 2019/8/29.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGFundRecordDetailView.h"
#import "UGRechargeLogsModel.h"
@interface UGFundRecordDetailView()
@property (weak, nonatomic) IBOutlet UILabel *orderNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *applyTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *rechargeUserLabel;
@property (weak, nonatomic) IBOutlet UILabel *rechargeTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet UIButton *myButton;

@end
@implementation UGFundRecordDetailView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"UGFundRecordDetailView" owner:self options:0].firstObject;
        self.frame = frame;
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        [self setBackgroundColor: [UIColor whiteColor]];
        [self.myButton setTitleColor:UGNavColor forState:UIControlStateNormal];
    }
    
    return self;
}

- (void)setItem:(UGRechargeLogsModel *)item {
    _item = item;
    self.orderNoLabel.text = [NSString stringWithFormat:@"交易编号：%@",item.orderNo];
    self.applyTimeLabel.text = [NSString stringWithFormat:@"发起时间：%@",item.applyTime];
    self.categoryLabel.text = [NSString stringWithFormat:@"交易类型：%@",item.category];
    self.statusLabel.text = [NSString stringWithFormat:@"交易状态：%@",item.status];
    self.amountLabel.text = [NSString stringWithFormat:@"交易金额：%@",item.amount];
    self.rechargeUserLabel.text = [NSString stringWithFormat:@"存款人：%@",[UGUserModel currentUser].username];
    self.rechargeTimeLabel.text = [NSString stringWithFormat:@"存款时间：%@",item.arriveTime];
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
