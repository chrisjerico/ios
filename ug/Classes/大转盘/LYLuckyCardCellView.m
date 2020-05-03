//
//  LYLuckyCardCellView.m
//  LYLuckyCardDemo
//
//  Created by leo on 17/2/9.
//  Copyright © 2017年 leo. All rights reserved.
//

#import "LYLuckyCardCellView.h"


@interface LYLuckyCardCellView ()

@end

@implementation LYLuckyCardCellView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)commonInit {
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.font = [UIFont systemFontOfSize:11];
    [self.label setTextColor:[UIColor whiteColor]];
    self.label.center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0 );
    [self addSubview:self.label];
    
    _imageView = [FLAnimatedImageView new];
    _imageView.frame = CGRectMake(0, 0, 50, 50);
    _imageView.center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0 - 45);
    [self addSubview:self.imageView];
}
-(void)configCell:(int )a{
    self.label.text = [NSString stringWithFormat:@"第%d个",a];
}


@end
