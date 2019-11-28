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
@property (weak, nonatomic) IBOutlet UIView *answerView;
@property (weak, nonatomic) IBOutlet UIView *answer2View;
@property (weak, nonatomic) IBOutlet UIView *scratchView;
@property (weak, nonatomic) IBOutlet UIButton *showButton;


@end

@implementation UGScratchMusicView

- (instancetype)UGScratchMusicView {
    return _LoadView_from_nib_(@"UGScratchMusicView");
}

-(instancetype)initView{
    if (self = [super init]) {
        self = [self UGScratchMusicView];
        [self scratchViewInit];
    }
    return self;
}

- (void)scratchViewInit{
    [self.ottoScratchView removeFromSuperview];
    [self.answer2View setHidden:YES];
    self.ottoScratchView = [[OttoScratchView alloc] initWithFrame:CGRectMake(0, 0, self.scratchView.frame.size.width, self.scratchView.frame.size.height)];
    self.ottoScratchView.delegate = self;
    self.ottoScratchView.scratchLineWidth = 14;
    self.ottoScratchView.passCount = 9;
    [self.ottoScratchView addSubview:self.answerView];
    [self.scratchView insertSubview:self.ottoScratchView belowSubview:self.showButton];
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
