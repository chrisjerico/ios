//
//  LoadingStateView.m
//  C
//
//  Created by fish on 2018/5/24.
//  Copyright © 2018年 fish. All rights reserved.
//

#import "LoadingStateView.h"


@interface LoadingStateView ()
@property (weak, nonatomic) IBOutlet UILabel *loadingLabel;
@property (weak, nonatomic) IBOutlet UIView *loadFailView;
@property (nonatomic) BOOL noNetworkHidden;
@end

@implementation LoadingStateView

+ (instancetype)showWithSuperview:(UIView *)superview state:(ZJLoadingState)state {
    LoadingStateView *lsv = nil;
    for (UIView *view in superview.subviews) {
        if ([view isKindOfClass:[LoadingStateView class]]) {
            lsv = (id)view;
            break;
        }
    }
    if (!lsv) {
        lsv = _LoadView_from_nib_(@"LoadingStateView");
        lsv.frame = superview.bounds;
        [superview addSubview:lsv];
    }
    lsv.state = state;
    return lsv;
}

- (void)setOffsetY:(CGFloat)offsetY {
    self.frame = CGRectMake(self.x, offsetY, self.width, self.superview.height-offsetY);
    _stackViewCenterYConstraint.constant = -offsetY/2;
}

- (void)setState:(ZJLoadingState)state {
    [self.superview bringSubviewToFront:self];
    _loadingLabel.hidden = state != ZJLoadingStateLoading;
    _loadFailView.hidden = state != ZJLoadingStateFail;
    _tipsLabel.hidden = state != ZJLoadingStateTips;
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = state != ZJLoadingStateSucc;
    } completion:^(BOOL finished) {
        self.hidden = state == ZJLoadingStateSucc;
    }];
}

- (IBAction)onRefreshBtnClick:(UIButton *)sender {
    self.state = ZJLoadingStateLoading;
    if (_didRefreshBtnClick)
        _didRefreshBtnClick();
}

@end

