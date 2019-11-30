//
//  LoadingStateView.h
//  C
//
//  Created by fish on 2018/5/24.
//  Copyright © 2018年 fish. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, ZJLoadingState) {
    ZJLoadingStateLoading = 0,
    ZJLoadingStateFail = 1,
    ZJLoadingStateTips = 2,
    ZJLoadingStateSucc = 3,
};


@interface LoadingStateView : UIView

@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stackViewCenterYConstraint;
@property (nonatomic) void (^didRefreshBtnClick)(void);

@property (nonatomic) ZJLoadingState state;
@property (nonatomic) CGFloat offsetY;

+ (instancetype)showWithSuperview:(UIView *)superview state:(ZJLoadingState)state;
@end
