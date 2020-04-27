//
//  DZPTwo.m
//  UGBWApp
//
//  Created by ug on 2020/4/27.
//  Copyright © 2020 ug. All rights reserved.
//

#import "DZPTwoView.h"


@interface DZPTwoView ()

//@property (strong, nonatomic) IBOutlet UIView *contentView;//


@end

@implementation DZPTwoView

- (instancetype)DZPTwoView {
    NSArray *objs= [[UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil] instantiateWithOwner:self options:nil];
    return [objs firstObject];

}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (!self.subviews.count) {
        DZPTwoView *v = [[DZPTwoView alloc] initWithFrame:CGRectZero];
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
        self = [self DZPTwoView];
    }
    return self;
}


@end
