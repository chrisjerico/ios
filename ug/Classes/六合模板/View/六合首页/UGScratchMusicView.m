//
//  UGScratchMusicView.m
//  ug
//
//  Created by ug on 2019/10/28.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGScratchMusicView.h"
#import "OttoScratchView.h"
#import "UIView+Events.h"
#import "SGBrowserView.h"

@interface UGScratchMusicView ()<OttoScratchViewDelegate>
@property (nonatomic,strong) OttoScratchView * ottoScratchView;
@property (weak, nonatomic) IBOutlet UIView *oc2View;
@property (weak, nonatomic) IBOutlet UIView *ocView;
@property (weak, nonatomic) IBOutlet UIView *answerView;
@property (weak, nonatomic) IBOutlet UIView *answer2View;
@property (weak, nonatomic) IBOutlet UIView *scratchView;
@property (weak, nonatomic) IBOutlet UIButton *showButton;

@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
@property (weak, nonatomic) IBOutlet UILabel *upTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *drowTitleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *icon2ImgV;
@property (weak, nonatomic) IBOutlet UILabel *upTitle2Label;
@property (weak, nonatomic) IBOutlet UILabel *drowTitle2Label;
@end

@implementation UGScratchMusicView

- (instancetype)UGScratchMusicView {
    return _LoadView_from_nib_(@"UGScratchMusicView");
}

-(instancetype)initViewWithImgStr:(NSString *)imgStr upTitle:(NSString *)upTitle downTitle:(NSString *)downTitle  bgColor:(NSString *)bgColorStr{
    if (self = [super init]) {
        self = [self UGScratchMusicView];
        [self.iconImgV setImage:[UIImage imageNamed:imgStr]];
        self.upTitleLabel.text = upTitle;
        self.drowTitleLabel.text = downTitle;
        [self.icon2ImgV setImage:[UIImage imageNamed:imgStr]];
        self.upTitle2Label.text = upTitle;
        self.drowTitle2Label.text = downTitle;
        UIColor *bgColor;
        if ([bgColorStr isEqualToString:@"green"]) {
            bgColor = RGBA(196, 234, 160, 1);
        }
        else if([bgColorStr isEqualToString:@"red"]){
            bgColor = RGBA(230, 53, 127, 1);
        }
        else if([bgColorStr isEqualToString:@"blue"]){
            bgColor = RGBA(117, 240, 243, 1);
        }
        [self.answer2View setBackgroundColor:bgColor];
        [self.answerView setBackgroundColor:bgColor]; 
        [self scratchViewInit];
    }
    return self;
}

- (void)scratchViewInit{
    [self.ottoScratchView removeFromSuperview];
    [self.answer2View setHidden:YES];
    self.ottoScratchView = [[OttoScratchView alloc] initWithFrame:CGRectMake(0, 0, self.oc2View.frame.size.width, self.oc2View.frame.size.height)];
    self.ottoScratchView.delegate = self;
    self.ottoScratchView.scratchLineWidth = 14;
    self.ottoScratchView.passCount = 9;
    [self.ottoScratchView addSubview:self.ocView];
    [self.oc2View insertSubview:self.ottoScratchView belowSubview:self.showButton];
    [self.showButton setHidden:YES];
    // 一行代码为 view 添加手势事件
    [self addGestureTapEventHandle:^(id sender, UITapGestureRecognizer *gestureRecognizer) {
        NSLog(@"tap");
         [SGBrowserView hide];
    }];
}

#pragma mark - OttoScratchViewDelegate
- (void)scratchViewDone{
    [self.ottoScratchView removeFromSuperview];
    [self.answer2View setHidden:NO];
}


@end
