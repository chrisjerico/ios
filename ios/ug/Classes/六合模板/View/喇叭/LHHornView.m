//
//  LHHornView.m
//  ug
//
//  Created by ug on 2020/2/4.
//  Copyright © 2020 ug. All rights reserved.
//

#import "LHHornView.h"

@implementation LHHornView

- (instancetype)LHHornView {
    NSBundle *bundle=[NSBundle mainBundle];
    NSArray *objs=[bundle loadNibNamed:@"LHHornView" owner:nil options:nil];
    
    
    return [objs firstObject];
}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (!self.subviews.count) {
        LHHornView *v = [[LHHornView alloc] initView];
        [self addSubview:v];
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (instancetype)initView {
    if (self = [super init]) {
        self = [self LHHornView];
        
        _imgGif1.contentMode = UIViewContentModeScaleAspectFit;
        [_imgGif1 sd_setImageWithURL:[[NSBundle mainBundle] URLForResource:@"LH_laba" withExtension:@"gif"]];
        [_imgGif2 sd_setImageWithURL:[[NSBundle mainBundle] URLForResource:@"LH_laba" withExtension:@"gif"]];
        [_imgGif3 sd_setImageWithURL:[[NSBundle mainBundle] URLForResource:@"LH_laba" withExtension:@"gif"]];
        
    }
    return self;
}

@end
