//
//  DZPMainView.m
//  UGBWApp
//
//  Created by ug on 2020/4/25.
//  Copyright © 2020 ug. All rights reserved.
//

#import "DZPMainView.h"
#import "LYLuckyCardRotationView.h"
#import "FLAnimatedImageView.h"
@interface DZPMainView ()

@property (weak, nonatomic) IBOutlet FLAnimatedImageView *imgGif;//转盘头部gif
@property (weak, nonatomic) IBOutlet LYLuckyCardRotationView *mDZPView;//转盘
@end

@implementation DZPMainView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (!self.subviews.count) {
        DZPMainView *v = [[DZPMainView alloc] initWithFrame:CGRectZero];
        [self addSubview:v];
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}


- (instancetype)DZPMainView {
    NSBundle *bundle=[NSBundle mainBundle];
    NSArray *objs=[bundle loadNibNamed:@"DZPMainView" owner:nil options:nil];

    // 按屏幕比例缩放（因为等比例约束太复杂，所以直接缩放得了）
//    CGFloat scale = APP.Width/414;
//    self.transform = CGAffineTransformMakeScale(scale, scale);
    return [objs firstObject];
}


- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self = [self DZPMainView];
        _imgGif.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}


- (void)hiddenSelf {

//    [view.superview removeFromSuperview];
    [self  removeFromSuperview];
}

- (IBAction)close:(id)sender {
    [self hiddenSelf];
}
@end
