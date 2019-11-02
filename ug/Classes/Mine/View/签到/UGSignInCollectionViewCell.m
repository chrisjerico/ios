//
//  UGSignInCollectionViewCell.m
//  ug
//
//  Created by ug on 2019/9/5.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGSignInCollectionViewCell.h"

@interface UGSignInCollectionViewCell ()

@end


@implementation UGSignInCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setBackgroundColor: [UIColor whiteColor]];
}

- (void)setItem:(UGCheckinListModel *)item {
    _item = item;
    FastSubViewCode(self);
    
    subLabel(@"日期Label").text = [[item.whichDay dateWithFormat:@"yyyy-MM-dd"] stringWithFormat:@"MM月dd日"];
    subLabel(@"星期Label").text = item.week;
    subLabel(@"金币Label").text = _NSString(@"+%@",item.integral);
    
    subButton(@"签到Button").userInteractionEnabled = !item.isCheckin;
    subButton(@"签到Button").alpha = !item.isCheckin ? 0.4 : 1;
    subImageView(@"背景ImageView").image = [[UIImage imageNamed:item.isCheckin ? @"signed" : @"nosign"] qmui_imageWithBlendColor:Skin1.navBarBgColor];
    
    if (item.isCheckin) {
        subLabel(@"签到状态Label").text = @"已签到";
        subImageView(@"签到状态ImageView").image = [UIImage imageNamed:@"signIn_grey"];
    } else {
        int a = [CMCommon compareDate:item.serverTime withDate:item.whichDay withFormat:@"yyyy-MM-dd" ];
        if (a >= 0) {
            subLabel(@"签到状态Label").text = @"签到";
            subImageView(@"签到状态ImageView").image = [UIImage imageNamed:@"signIn_blue"];
        } else if (item.mkCheckinSwitch && item.isMakeup) {
            subLabel(@"签到状态Label").text = @"补签";
            subImageView(@"签到状态ImageView").image = [UIImage imageNamed:@"signIn_red"];
        } else {
            subLabel(@"签到状态Label").text = @"补签";
            subImageView(@"签到状态ImageView").image = [UIImage imageNamed:@"signIn_grey"];
        }
    }
}


#pragma mark - IBAction

- (IBAction)signInClick:(id)sender {
    if (self.signInBlock)
        self.signInBlock();
}


@end
