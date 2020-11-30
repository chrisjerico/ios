//
//  LHHornView.m
//  ug
//
//  Created by ug on 2020/2/4.
//  Copyright © 2020 ug. All rights reserved.
//

#import "LHHornView.h"
#import "CMLabelCommon.h"

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
            
//            NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc] initWithString:_titleLab3.text];
//            [attriStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(8, 10)];
//            [attriStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(24, 10)];
//            _titleLab3.attributedText = attriStr;
            
            [CMLabelCommon messageSomeAction:_titleLab3 changeString:@"889777.com,668000.com" andMarkColor:[UIColor redColor] andMarkFondSize:0];
            
        } else if([APP.SiteId isEqualToString:@"l002"]) {
            _titleLab1.text = @"推荐下载70333.com威尼斯人APP,体验全网最快开奖查询!";
            _titleLab2.text = @"一个发帖就能赚钱的论坛，你们还在等什么呢!!!";
            _titleLab3.text = @"本站备用网址一:300777.com备用网址二:400777.com截图保存相册";
            


            [CMLabelCommon messageSomeAction:_titleLab3 changeString:@"300777.com,400777.com" andMarkColor:[UIColor redColor] andMarkFondSize:0];

        }
        
        
    }
    return self;
}
- (IBAction)buttonClicked:(id)sender {
    if ([APP.SiteId isEqualToString:@"l001"]) {
        [CMCommon goSLWebUrl:@"https://baidujump.app/eipeyipeyi/jump-218.html"];
        
    } else if([APP.SiteId isEqualToString:@"l002"]) {
        [CMCommon goSLWebUrl:@"https://baidujump.app/eipeyipeyi/jump-239.html"];
    }
            
}

@end
