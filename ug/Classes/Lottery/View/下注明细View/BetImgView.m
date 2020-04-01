//
//  BetImgView.m
//  ug
//
//  Created by ug on 2020/2/14.
//  Copyright © 2020 ug. All rights reserved.
//

#import "BetImgView.h"

@implementation BetImgView

- (instancetype)BetImgView {
    NSBundle *bundle=[NSBundle mainBundle];
    NSArray *objs=[bundle loadNibNamed:@"BetImgView" owner:nil options:nil];
    return [objs firstObject];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (!self.subviews.count) {
        BetImgView *v = [[BetImgView alloc] initView];
        [self addSubview:v];
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (instancetype)initView {
    if (self = [super init]) {
        self = [self BetImgView];
    }
    return self;
}

@end
