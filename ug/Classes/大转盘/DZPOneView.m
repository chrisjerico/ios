//
//  DZPOneView.m
//  UGBWApp
//
//  Created by ug on 2020/4/27.
//  Copyright © 2020 ug. All rights reserved.
//

#import "DZPOneView.h"

@implementation DZPOneView

- (instancetype)DZPOneView {
    NSBundle *bundle=[NSBundle mainBundle];
    NSArray *objs=[bundle loadNibNamed:@"DZPOneView" owner:nil options:nil];
    
    
    return [objs firstObject];
}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (!self.subviews.count) {
        DZPOneView *v = [[DZPOneView alloc] initWithFrame:CGRectZero];
        [self addSubview:v];
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self = [self DZPOneView];
    }
    return self;
}

@end
