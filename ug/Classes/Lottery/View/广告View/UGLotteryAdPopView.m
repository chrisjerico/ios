//
//  UGLotteryAdPopView.m
//  ug
//
//  Created by ug on 2019/8/2.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGLotteryAdPopView.h"

@interface UGLotteryAdPopView ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *goButton;

@end
@implementation UGLotteryAdPopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"UGLotteryAdPopView" owner:self options:0].firstObject;
        self.frame = frame;
        self.closeButton.layer.cornerRadius = 6;
        self.closeButton.layer.masksToBounds = YES;
        self.goButton.layer.cornerRadius = 6;
        self.goButton.layer.masksToBounds = YES;
        
    }
    
    return self;
}

- (void)setPicUrl:(NSString *)picUrl {
    _picUrl = picUrl;
    if (picUrl) {
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    }
}

- (IBAction)closeClick:(id)sender {
    
    [self hiddenSelf];
}

- (IBAction)goClick:(id)sender {
    
    if (self.adGoBlcok) {
        self.adGoBlcok();
    }
    [self hiddenSelf];
}

- (void)show {
    
    UIWindow* window = UIApplication.sharedApplication.keyWindow;
    UIView* maskView = [[UIView alloc] initWithFrame:window.bounds];
    UIView* view = self;
    view.hidden = NO;
    
    maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    maskView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    [maskView addSubview:view];
    [window addSubview:maskView];
    
}

- (void)hiddenSelf {
    
    UIView* view = self;
    self.superview.backgroundColor = [UIColor clearColor];
    [view.superview removeFromSuperview];
    [view removeFromSuperview];
    
}
@end
