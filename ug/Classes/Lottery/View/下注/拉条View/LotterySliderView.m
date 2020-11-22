//
//  LotterySliderView.m
//  UGBWApp
//
//  Created by andrew on 2020/11/22.
//  Copyright © 2020 ug. All rights reserved.
//

#import "LotterySliderView.h"
@interface LotterySliderView ()
@property (strong, nonatomic)  UILabel *sliderLB;/**<拖动条 刻度显示*/
@property (strong, nonatomic)  UIButton *reductionBtn;/**<拖动条 -按钮*/
@property (strong, nonatomic)  UIButton *addBtn;/**<拖动条 +按钮*/
@property ( nonatomic) float proportion;/**<拖动条 显示的最大值    来自网络数据*/
@property ( nonatomic) float lattice;/**<拖动条 一格的值  */
@end

@implementation LotterySliderView
- (void)awakeFromNib {
    [super awakeFromNib];
    FastSubViewCode(self);
    __weakSelf_(__self);
    self.slider = [[MGSlider alloc] initWithFrame:CGRectMake(190, 5,110 , 50)];
    self.slider.thumbSize = CGSizeMake(40, 40);//锚点的大小
    self.slider.thumbImage = [UIImage imageNamed:[LanguageHelper shared].isCN ? @"icon_activity_ticket_details_rebate" : @"RadioButton-Selected"];//锚点的图片
    self.slider.thumbColor = [UIColor clearColor];//锚点的背景色
    self.slider.trackColor = [UIColor colorWithRed:0.29 green:0.42 blue:0.86 alpha:1.00];//进度条的颜色+
    self.slider.untrackColor = [UIColor grayColor];//进度条的颜色-
    self.slider.zoom = NO; // 默认点击放大
    self.slider.progress = 0;// 默认第一次锚点所在的位置，1：100%
    self.slider.margin = 10; // 距离左右内间距
    [[Global getInstanse] setRebate:0.0];//进入界面，初始退水为0
    //    [self.bottomView addSubview:self.slider];
    [self.slider changeValue:^(CGFloat value) {
        NSLog(@">>>>>>>>>>>>>>>>>>>>>拖动==== %f", value);
        [__self setRebateAndSliderLB:value];
        
    } endValue:^(CGFloat value) {
        
        
    }];
    
    self.reductionBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.reductionBtn setBackgroundImage:[UIImage imageNamed:@"icon_activity_ticket_details_minus"] forState:(UIControlStateNormal)];
    self.reductionBtn.frame = CGRectMake(20, 200, 50, 50);
    [self addSubview:self.reductionBtn];
    [self.reductionBtn addTarget:self  action:@selector(reductionAction:) forControlEvents:(UIControlEventTouchDown)];

    self.addBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.addBtn setBackgroundImage:[UIImage imageNamed:@"icon_activity_ticket_details_add"] forState:(UIControlStateNormal)];
    self.addBtn.frame = CGRectMake(350, 200, 50, 50);
    [self addSubview:self.addBtn];
    [self.addBtn addTarget:self  action:@selector(addImgVAction:) forControlEvents:(UIControlEventTouchDown)];

    self.sliderLB = [[UILabel alloc] initWithFrame:CGRectMake(190, 250, 200, 50)];
    self.sliderLB.font = [UIFont systemFontOfSize:14.0];
    self.sliderLB.text = @"0.00%";
    self.sliderLB.textColor = [UIColor whiteColor];
    [self addSubview:self.sliderLB];

    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) { //数组额你不必须都是view
        
        //        make.right.equalTo(self.bottomView.mas_right).offset(-10);
        make.height.equalTo([NSNumber numberWithFloat:32]);
        make.width.equalTo([NSNumber numberWithFloat:32]);
        make.top.equalTo([NSNumber numberWithFloat:13]);
    }];
    
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) { //数组额你不必须都是view
        
        //        make.right.equalTo(self.bottomView.mas_right).offset(-50);
        make.height.equalTo([NSNumber numberWithFloat:50]);
        make.width.equalTo([NSNumber numberWithFloat:80]);
        make.top.equalTo([NSNumber numberWithFloat:5]);
    }];
    
    [self.reductionBtn mas_makeConstraints:^(MASConstraintMaker *make) { //数组额你不必须都是view
        
        //        make.right.equalTo(self.bottomView.mas_right).offset(-141);
        make.height.equalTo([NSNumber numberWithFloat:32]);
        make.width.equalTo([NSNumber numberWithFloat:32]);
        make.top.equalTo([NSNumber numberWithFloat:13]);
    }];
    
    [self.sliderLB mas_makeConstraints:^(MASConstraintMaker *make) { //数组额你不必须都是view
        make.right.equalTo(self.reductionBtn.mas_left).offset(-6);
        make.height.equalTo([NSNumber numberWithFloat:20]);
        make.top.equalTo([NSNumber numberWithFloat:18]);
    }];
    [self showSliderAction];

}

-(void)setRebateAndSliderLB :(float )value{
    NSString *x =[NSString stringWithFormat:@"%.2f%@",self.lattice * value*100,@"%"];
    [self.sliderLB setText:x];
    
    NSString *rebateStr = [NSString stringWithFormat:@"%.4f",self.lattice * value];
    float rebateF = [rebateStr floatValue];
    [[Global getInstanse] setRebate:rebateF];
    
    if (self.reloadlock) {
        self.reloadlock();
    }
   
}


-(void)showSliderAction{
    if (SysConf.activeReturnCoinStatus) {//是否開啟拉條模式
        self.proportion = SysConf.activeReturnCoinRatio;
        self.lattice = 0.01 * self.proportion;
        
    }
}


-(void)addImgVAction:(UIButton *)sender{

    if (self.slider.moveProgress< 1.0) {
        self.slider.moveProgress = self.slider.moveProgress + 0.0005;
        self.slider.progress = self.slider.moveProgress;
        
        [self setRebateAndSliderLB:self.slider.progress];
        
        if (self.slider.progress >0.8) {
            //该控件的bug
            CGRect frame =  self.slider.valveIV.frame;
            if (frame.origin.x >= 90.0) {
                frame.origin.x = 90.0;
                self.slider.valveIV.frame = frame;
            }
        }
        
    }
}

-(void)reductionAction:(UIButton *)sender{

    if (self.slider.moveProgress> 0) {
        self.slider.moveProgress = self.slider.moveProgress - 0.0005;
        self.slider.progress = self.slider.moveProgress;
        
        [self setRebateAndSliderLB:self.slider.progress];
        
        if (self.slider.progress >0.8) {
            //该控件的bug
            CGRect frame =  self.slider.valveIV.frame;
            if (frame.origin.x >= 90.0) {
                frame.origin.x = 90.0;
                self.slider.valveIV.frame = frame;
            }
        }
    }
    
}

@end
