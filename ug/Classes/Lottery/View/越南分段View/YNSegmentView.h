//
//  YNSegmentView.h
//  UGBWApp
//
//  Created by andrew on 2020/7/25.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

@import HMSegmentedControl;

NS_ASSUME_NONNULL_BEGIN

@interface YNSegmentView : UIView

@property (nonatomic, strong) UIButton* button;
@property (nonatomic, strong) HMSegmentedControl *segment;
- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray <NSString *> *)array;
@end

NS_ASSUME_NONNULL_END
