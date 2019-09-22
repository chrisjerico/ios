//
//  UGSignInCollectionViewCell.m
//  ug
//
//  Created by ug on 2019/9/5.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGSignInCollectionViewCell.h"
#import "UGSignInModel.h"

@interface UGSignInCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *dateLbl;//9月2
@property (weak, nonatomic) IBOutlet UILabel *weekLbl;//星期1
@property (weak, nonatomic) IBOutlet UILabel *number_gold_lbl;//+10.00
@property (weak, nonatomic) IBOutlet UILabel *stateLable;//已签到
@property (weak, nonatomic) IBOutlet UIImageView *stateImageView;//已签到（灰）补签（红）签到（蓝）
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;//已签到（深）签到（浅）
@property (weak, nonatomic) IBOutlet UIButton *signInButton;



@end

@implementation UGSignInCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)signInClick:(id)sender {
    if (self.signInBlock) {
        self.signInBlock();
    }
}

- (void)setDateStr:(NSString *)dateStr {
    _dateStr = dateStr;
    self.dateLbl.text = dateStr;
    
}

- (void)setWeekStr:(NSString *)weekStr {
    _weekStr = weekStr;
    self.weekLbl.text = weekStr;
    
}

- (void)setNumber_gold_Str:(NSString *)number_gold_Str {
    _number_gold_Str = number_gold_Str;
    self.number_gold_lbl.text = number_gold_Str;
    
}

- (void)setStateStr:(NSString *)stateStr {
    _stateStr = stateStr;
    self.stateLable.text = stateStr;
    
}

- (void)setStateImageStr:(NSString *)stateImageStr {
    _stateImageStr = stateImageStr;
    self.stateImageView.image = [UIImage imageNamed:stateImageStr];
    
}

- (void)setBgImageStr:(NSString *)bgImageStr {
    _bgImageStr = bgImageStr;
    self.bgImageView.image = [UIImage imageNamed:bgImageStr];
    
}

- (void)setItem:(UGCheckinListModel *)item {
    _item = item;
    
    if (![CMCommon stringIsNull:item.whichDay]) {
        //以字符串中的字符作为分割条件进行分割
        NSArray * array = [item.whichDay componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"-"]];
        NSString *data = [NSString stringWithFormat:@"%@月%@日",[array objectAtIndex:1],[array objectAtIndex:2]];
        [self setDateStr:data];
    }
    if (![CMCommon stringIsNull:item.week]) {
        [self setWeekStr:item.week];
    }
    if (item.integral) {
        [self setNumber_gold_Str:[NSString stringWithFormat:@"+%@",item.integral]];
    }
    
    //isCheckin：false；还没有签到 isMakeup：true：已经签到
//   isMakeup false；不可以 isMakeup：true：可以补签
    //
    //如果日期大于今天，显示签到
    //如果日期小于今天，是显示补签
    
    if (item.isCheckin == true) {
        //按钮不可点击
        // 显示已签到灰色按钮；可以点击补签事件 已签到bg
        self.signInButton.userInteractionEnabled=NO;//交互关闭
        self.signInButton.alpha=0.4;//透明度
        [self setStateStr:@"已签到"];
        [self setStateImageStr:@"signIn_grey"];
        [self setBgImageStr:@"signed"];
    }
    else if(item.isCheckin == false && item.isMakeup == true){
        //按钮可点击
        // 显示签到的蓝色按钮；可以点击签到事件 未签到bg
        self.signInButton.userInteractionEnabled=YES;//交互
        self.signInButton.alpha= 1;//透明度
        [self setBgImageStr:@"nosign"];
        
        int a = [CMCommon compareDate:item.serverTime withDate:item.whichDay withFormat:@"yyyy-MM-dd" ];
        if (a >= 0) {
            [self setStateStr:@"签到"];
            [self setStateImageStr:@"signIn_blue"];
        } else {
            
            if (item.mkCheckinSwitch) {
                [self setStateStr:@"补签"];
                [self setStateImageStr:@"signIn_red"];
            } else {
                [self setStateStr:@"补签"];
                [self setStateImageStr:@"signIn_grey"];
            }
            
        }
        
    }
    else if(item.isCheckin == false && item.isMakeup == false){

        self.signInButton.userInteractionEnabled=YES;//交互
        self.signInButton.alpha= 1;//透明度
        
        [self setBgImageStr:@"nosign"];

        [self setStateStr:@"签到"];
        [self setStateImageStr:@"signIn_blue"];

    }
    
    
    
    
}

@end
