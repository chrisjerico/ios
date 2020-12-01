//
//  LotteryView.m
//  UGBWApp
//
//  Created by andrew on 2020/11/22.
//  Copyright © 2020 ug. All rights reserved.
//

#import "LotteryView.h"
@interface LotteryView ()

@end
@implementation LotteryView

- (void)awakeFromNib {
    [super awakeFromNib];
    FastSubViewCode(self);
    [subView(@"天空蓝下注View") setBackgroundColor:Skin1.bgColor];
    [subView(@"天空蓝下注View") insertSubview:({
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP.Width, 200)];
        bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        bgView;
    }) atIndex:0];
    subTextField(@"TKL下注TxtF").keyboardType = UIKeyboardTypeDecimalPad;
    subButton(@"TKL追号btn").layer.cornerRadius = 5;
    subButton(@"TKL追号btn").layer.masksToBounds = YES;
    subButton(@"TKL机选btn").layer.cornerRadius = 5;
    subButton(@"TKL机选btn").layer.masksToBounds = YES;
    subButton(@"TKL机选btn").layer.cornerRadius = 5;
    subButton(@"TKL机选btn").layer.masksToBounds = YES;
    subButton(@"TKL下注Button").layer.cornerRadius = 5;
    subButton(@"TKL下注Button").layer.masksToBounds = YES;
    subButton(@"TKL重置Button").layer.cornerRadius = 5;
    subButton(@"TKL重置Button").layer.masksToBounds = YES;
    subButton(@"TKL筹码Btn").layer.cornerRadius = 5;
    subButton(@"TKL筹码Btn").layer.masksToBounds = YES;
    [subButton(@"TKL重置Button") setBackgroundColor:RGBA(247, 162, 0, 1)];
    [subButton(@"TKL追号btn") setBackgroundColor:RGBA(247, 162, 0, 1)];
    [subButton(@"TKL机选btn") setBackgroundColor:RGBA(247, 162, 0, 1)];
    [subButton(@"TKL下注Button") setBackgroundColor:Skin1.navBarBgColor];
 
//    [subButton(@"TKL筹码Btn") removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
//    [subButton(@"TKL筹码Btn") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
//        if (self.cmllock) {
//            self.cmllock(sender);
//        }
//    }];//封盘View

    subView(@"封盘View").backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    subView(@"封盘View").hidden = YES;
}

-(void)setGameId:(NSString *)gameId{
    FastSubViewCode(self);
    if ([CMCommon hasGengHao:gameId]) {
        [subButton(@"TKL追号btn") setEnabled:YES];
        [subButton(@"TKL追号btn") setAlpha:1.0];
    } else {
        [subButton(@"TKL追号btn") setEnabled:NO];
        [subButton(@"TKL追号btn") setAlpha:0.3];
    }
}


//首页广告图片
- (void)reloadData:(void (^)(BOOL succ))completion {
    WeakSelf;
    [CMNetwork getSystemConfigWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
            NSLog(@"model = %@",model);
            FastSubViewCode(weakSelf);
            UGSystemConfigModel *config = model.data;
            UGSystemConfigModel.currentConfig = config;
            if (SysConf.betAmountIsDecimal  == 1) {//betAmountIsDecimal  1=允许小数点，0=不允许，以前默认是允许投注金额带小数点的，默认为1
                //                [subTextView(@"下注TxtF") set仅数字:false];
                //                [subTextView(@"下注TxtF") set仅数字含小数:true];
            } else {
                //                [subTextView(@"下注TxtF") set仅数字:true];
            }
            if (SysConf.chaseNumber  == 1) {//追号开关  默认关
                [subButton(@"TkL追号btn") setHidden:NO];
            } else {
                [subButton(@"TKL追号btn") setHidden:YES];
            }
            
            if (SysConf.selectNumber == 1) {
                [subButton(@"TKL机选btn") setHidden:NO];
            } else {
                [subButton(@"TKL机选btn") setHidden:YES];
            }
  
        } failure:^(id msg) {
//            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }];

}

@end
