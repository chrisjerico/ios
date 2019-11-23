//
//  UGLHOldYearViewController.m
//  ug
//
//  Created by ug on 2019/11/22.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGLHOldYearViewController.h"
#import "UGLHLhlModel.h"

@interface UGLHOldYearViewController ()
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation UGLHOldYearViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 按屏幕比例缩放（因为等比例约束太复杂，所以直接缩放得了）
    CGFloat scale = APP.Width/414;
    _contentView.transform = CGAffineTransformMakeScale(scale, scale);
    

    [self setTestDate];
}

-(void)setTestDate{
    FastSubViewCode(self.view)
    subLabel(@"月份中文label").text = @"11";
    subLabel(@"月份英文label").text = @"September";
    subLabel(@"年份label").text = @"2019年";
    subLabel(@"数字label").text = @"22";
    subLabel(@"中label").text = @"已亥年  十月 大";
    subLabel(@"星期label").text = @"星期五";
    subLabel(@"日期label").text = @"二十六";
    subLabel(@"宜详细label").text = @"祭祀 沐浴 馀事勿取";
    subLabel(@"吉神宜趋详细label").text = @"王日 续世 宝光";
    subLabel(@"六合吉数详细label").text = @"17 28 36 21 31";
    subLabel(@"凶煞宜忌详细label").text = @" 月建 小时 土府 月刑 四废 九坎 九焦 血忌 重日 阳错 ";
    subLabel(@"忌详细label").text = @"诸事不宜";
    subLabel(@"时辰吉凶详细label").text = @"凶 吉 凶 凶 吉 凶 吉 吉 凶 凶 吉 凶";
    subLabel(@"冲煞详细label").text = @"冲蛇(丁已)煞西";
    subLabel(@"天干地支详细label").text = @" 癸亥";
    subLabel(@"喜神详细label").text = @"东南";
    subLabel(@"福神label").text = @"正西";
    subLabel(@"财神详细label").text = @"正南";
    subLabel(@"白忌详细label").text = @"癸不词讼理弱敌强 亥不嫁娶不利新郎";
    subLabel(@"日五行详细label").text = @"大海水 建执位";
    
}

- (IBAction)leftClicked:(id)sender {
    NSLog(@"leftClicked");
}
- (IBAction)rightClicked:(id)sender {
    NSLog(@"rightClicked");
}


@end
