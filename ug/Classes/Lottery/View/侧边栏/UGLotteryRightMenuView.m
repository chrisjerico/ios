//
//  UGLotteryRightMenuView.m
//  UGBWApp
//
//  Created by fish on 2020/9/25.
//  Copyright © 2020 ug. All rights reserved.
//

#import "UGLotteryRightMenuView.h"
@interface UGLotteryRightMenuView ()
@property (weak, nonatomic) IBOutlet UIButton *returnHomeBtn;
@end
@implementation UGLotteryRightMenuView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:APP.Bounds];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"UGLotteryRightMenuView" owner:self options:nil].firstObject;

    }
    return self;
    
}

#pragma mark - 显示

- (void)show {
    self.frame = APP.Bounds;
    [APP.Window addSubview:self];
    self.returnHomeBtn.superview.superview.cc_constraints.left.constant = -APP.Width;
    [self layoutIfNeeded];
    [UIView animateWithDuration:0.35 animations:^{
        self.returnHomeBtn.superview.superview.cc_constraints.left.constant = 0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}
#pragma mark - 隐藏

- (IBAction)hiddenSelf {
    [UIView animateWithDuration:0.35 animations:^{
        self.returnHomeBtn.superview.superview.cc_constraints.left.constant = -APP.Width;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
