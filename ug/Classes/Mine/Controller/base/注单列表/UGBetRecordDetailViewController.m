//
//  UGBetRecordDetailViewController.m
//  ug
//
//  Created by ug on 2019/5/17.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGBetRecordDetailViewController.h"

#import "UGChanglongBetRecordModel.h"

#import "UGSystemConfigModel.h"

@interface UGBetRecordDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *issueLabel;
@property (weak, nonatomic) IBOutlet UILabel *betTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *betAmontLabel;
@property (weak, nonatomic) IBOutlet UILabel *winAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UILabel *playTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultMoneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelBetButton;

@end

@implementation UGBetRecordDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor: Skin1.bgColor];
    self.navigationItem.title = @"注单详情";
    self.cancelBetButton.layer.cornerRadius = 3;
    self.cancelBetButton.layer.masksToBounds = YES;
    self.titleLabel.textColor = Skin1.textColor1;
    self.issueLabel.textColor = Skin1.textColor1;
    self.betTimeLabel.textColor = Skin1.textColor1;
    self.orderNoLabel.textColor = Skin1.textColor1;
    self.winAmountLabel.textColor = Skin1.textColor1;
    self.playTitleLabel.textColor = Skin1.textColor3;
    self.resultMoneyLabel.textColor = Skin1.textColor3;
    FastSubViewCode(self.view);
    subLabel(@"投注时间Label").textColor = Skin1.textColor1;
    subLabel(@"投注单号Label").textColor = Skin1.textColor1;
    subLabel(@"投注金额Label").textColor = Skin1.textColor1;
    subLabel(@"派奖金额Label").textColor = Skin1.textColor1;
    subLabel(@"开奖号码Label").textColor = Skin1.textColor1;
    [self setupInfo];
}

- (void)setupInfo {
    self.cancelBetButton.hidden = !self.item.isAllowCancel;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:self.item.pic] placeholderImage:[UIImage imageNamed:@"loading"]];
    self.titleLabel.text = self.item.title;
    
    if (![CMCommon stringIsNull:self.item.displayNumber]) {
        self.issueLabel.text = [NSString stringWithFormat:@"第%@期",self.item.displayNumber];
    } else {
        self.issueLabel.text = [NSString stringWithFormat:@"第%@期",self.item.issue];
    }
    self.betTimeLabel.text = self.item.addTime;
    self.orderNoLabel.text = self.item.orderNo;
    self.betAmontLabel.text = [NSString stringWithFormat:@"%@元",self.item.money];
    self.winAmountLabel.text = [NSString stringWithFormat:@"%@元",self.item.bonus];
    self.resultLabel.text = self.item.lotteryNo;
    self.playTitleLabel.text = [NSString stringWithFormat:@"%@-%@",self.item.group_name,self.item.play_name];
    if (self.item.status) {
        if (self.item.isWin) {
            
            self.resultMoneyLabel.text = [NSString stringWithFormat:@"奖金：%@元",self.item.bonus];
        }else {
            self.resultMoneyLabel.text = @"奖金：未中奖";
            self.winAmountLabel.text = @"未中奖";
        }
    }else {
        
        self.resultLabel.text = @"等待开奖";
        float win = self.item.odds.floatValue * self.item.money.floatValue;
        NSString *winAmount= [[NSString stringWithFormat:@"%.4f",win] removeFloatAllZero];
        self.winAmountLabel.text = [NSString stringWithFormat:@"%@元",winAmount];
        self.resultMoneyLabel.text = [NSString stringWithFormat:@"奖金：%@元",winAmount];
    }
    
}

- (IBAction)cancelBet:(id)sender {
    [QDAlertView showWithTitle:@"温馨提示" message:@"您确定要撤销该注单吗？" cancelButtonTitle:@"取消" otherButtonTitle:@"确定" completionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self cancelBetWith];
            });
        }
    }];
}

- (void)cancelBetWith {
    if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
        return;
    }
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                             @"orderId":self.item.orderNo
                             };
    [SVProgressHUD showWithStatus:nil];
    [CMNetwork cancelBetWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            [SVProgressHUD showSuccessWithStatus:model.msg];
            SANotificationEventPost(UGNotificationGetChanglongBetRecrod, nil);
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }];
}

@end
