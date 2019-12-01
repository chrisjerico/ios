//
//  LHPostRewardView.m
//  ug
//
//  Created by fish on 2019/12/1.
//  Copyright © 2019 ug. All rights reserved.
//

#import "LHPostRewardView.h"

@implementation LHPostRewardView

- (void)setPm:(UGLHPostModel *)pm {
    _pm = pm;
    FastSubViewCode(self);
    [subImageView(@"头像ImageView") sd_setImageWithURL:[NSURL URLWithString:pm.headImg]];
}

- (void)show {
    self.alpha = 0;
    self.frame = APP.Window.bounds;
    [TabBarController1.view addSubview:self];
    UIView *alertView = [self viewWithTagString:@"弹框AlertView"];
    alertView.transform = CGAffineTransformMakeScale(1.5, 1.5);
    
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
        alertView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self onRandomBtnClick:nil];
    }];
}

- (void)random:(NSNumber *)cnt {
    NSArray *prices = @[@"3.99", @"13.14", @"7.11", @"9.99", @"8.88", @"19.99", @"6.66", @"18.88", @"5.2", @"12.12",];
    ((UITextField *)[self viewWithTagString:@"金额TextField"]).text = prices[arc4random()%prices.count];
    cnt = @(cnt.intValue - 1);
    if (cnt.intValue > 0) {
        [self performSelector:@selector(random:) withObject:cnt afterDelay:0.1];
    }
}

- (IBAction)onRandomBtnClick:(UIButton *)sender {
    [self random:@(10)];
}

- (IBAction)onConfirmBtnClick:(UIButton *)sender {
    double price = ((UITextField *)[self viewWithTagString:@"金额TextField"]).text.doubleValue;
    if (price > 0.001) {
        if (_didConfirmBtnClick) {
            _didConfirmBtnClick(self, price);
        }
    } else {
        [HUDHelper showMsg:@"请输入打赏金额"];
    }
}

- (IBAction)hide:(UIButton *)sender {
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
