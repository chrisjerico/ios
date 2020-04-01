//
//  LHPostPayView.m
//  ug
//
//  Created by fish on 2019/12/1.
//  Copyright © 2019 ug. All rights reserved.
//

#import "LHPostPayView.h"

@implementation LHPostPayView

- (void)setPm:(UGLHPostModel *)pm {
    _pm = pm;
    FastSubViewCode(self);
    subLabel(@"标题Label").text = pm.title;
    subLabel(@"价格Label").text = _NSString(@"打赏 %.2f 元", pm.price);
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
    }];
}

- (IBAction)onConfirmBtnClick:(UIButton *)sender {
    if (_didConfirmBtnClick) {
        _didConfirmBtnClick(self);
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
