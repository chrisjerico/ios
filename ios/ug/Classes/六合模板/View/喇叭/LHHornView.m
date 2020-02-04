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
        [_imgGif1 sd_setImageWithURL:[[NSBundle mainBundle] URLForResource:@"LH_l001jt" withExtension:@"gif"]];
        [_imgGif2 sd_setImageWithURL:[[NSBundle mainBundle] URLForResource:@"LH_laba" withExtension:@"gif"]];
        [_imgGif3 sd_setImageWithURL:[[NSBundle mainBundle] URLForResource:@"LH_laba" withExtension:@"gif"]];
        
        if ([APP.SiteId isEqualToString:@"l001"]) {
            _titleLab1.text = @"推荐下载4988.com六合宝典APP,体验全网最快开奖查询!";
            _titleLab2.text = @"一个发帖就能赚钱的论坛，你们还在等什么呢!!!";
            _titleLab3.text = @"本站备用网址一:889777.com备用网址二:668000.com截图保存相册";
            
        } else if([APP.SiteId isEqualToString:@"l002"]) {
            _titleLab1.text = @"推荐下载70333.com王中王APP,体验全网最快开奖查询!";
            _titleLab2.text = @"一个发帖就能赚钱的论坛，你们还在等什么呢!!!";
            _titleLab3.text = @"本站备用网址一:300777.com备用网址二:400777.com截图保存相册";
        }
        
    }
    return self;
}

@end
