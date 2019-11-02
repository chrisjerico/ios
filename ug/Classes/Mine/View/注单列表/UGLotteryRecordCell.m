//
//  UGLotteryRecordCell.m
//  ug
//
//  Created by ug on 2019/7/24.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGLotteryRecordCell.h"
#import "UGBetsRecordListModel.h"

#import "UGSystemConfigModel.h"

@interface UGLotteryRecordCell ()
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;    /**<   撤单按钮 */

@end

@implementation UGLotteryRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.cancelButton.layer.cornerRadius = 5;
    self.cancelButton.layer.masksToBounds = YES;
    self.cancelButton.backgroundColor = Skin1.navBarBgColor;
}

- (void)setItem:(UGBetsRecordModel *)item {
    _item = item;
    
    FastSubViewCode(self);
    subLabel(@"彩种Label").text = item.gameName;
    subLabel(@"期数Label").text = item.issue;
    subLabel(@"注单号Label").text = item.betId;
    subLabel(@"赔率Label").text = item.odds;
    subLabel(@"注单金额Label").text = item.betAmount;
    subLabel(@"盈亏Label2").text = _NSString(@"%@%@元", (item.settleAmount.doubleValue>0 ? @"+" : @""), item.settleAmount);
    subLabel(@"玩法Label").text = _NSString(@"%@ %@ %@", item.playGroupName, item.playName, item.betInfo);
    subLabel(@"开奖号码Label").text = item.lotteryNo;
    subButton(@"撤单Button").hidden = !(item.status==1 && [UGSystemConfigModel currentConfig].allowMemberCancelBet); // 等待开奖时才显示
    
    if (item.status == 1) {
        subLabel(@"开奖号码Label").text = @"等待开奖";
        subLabel(@"盈亏Label1").text = @"可赢金额:";
        subLabel(@"盈亏Label2").text = _NSString(@"%@%@元", (item.expectAmount.doubleValue>0 ? @"+" : @""), item.expectAmount);
    } else if (item.status == 4) {
        subLabel(@"开奖号码Label").text = @"已撤单";
        subLabel(@"盈亏Label2").text = @"--";
    }
}

- (IBAction)cancelClick:(id)sender {
    if (self.cancelBlock)
        self.cancelBlock();
}

@end
