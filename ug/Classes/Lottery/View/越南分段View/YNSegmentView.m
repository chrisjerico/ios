//
//  YNSegmentView.m
//  UGBWApp
//
//  Created by andrew on 2020/7/25.
//  Copyright © 2020 ug. All rights reserved.
//

#import "YNSegmentView.h"

@interface YNSegmentView ()



@end

@implementation YNSegmentView

- (instancetype)initWithFrame:(CGRect)frame titleArray:(nonnull NSArray<NSString *> *)array {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(5, 10, 30, 30);
        UIImage* icon1 = [UIImage imageNamed:@"bangzhu"];
        [_button setImage:icon1 forState:UIControlStateNormal];
        [self addSubview:_button];
        
        //初始化UISegmentedControl
        self.segment = [[HMSegmentedControl alloc]initWithSectionTitles:array];
        //设置frame
        _segment.frame = CGRectMake(10, 10, self.frame.size.width-60, 30);
        //添加到视图
        [self addSubview:_segment];
        
        [_button  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).with.offset(5);
            make.height.width.mas_equalTo(30);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
        [_segment  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.button.mas_right).with.offset(5);
            make.height.width.mas_equalTo(40);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.right.equalTo(self.mas_right).with.offset(10);
        }];

    }
    return self;
}

@end
