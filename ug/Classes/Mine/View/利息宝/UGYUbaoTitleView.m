//
//  UGYUbaoTitleView.m
//  ug
//
//  Created by ug on 2019/10/13.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGYUbaoTitleView.h"

@implementation UGYUbaoTitleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"UGYUbaoTitleView" owner:self options:0].firstObject;
        self.frame = frame;
       self.progressView.startAngle = 0;
       self.progressView.strokeWidth = 3;
       self.progressView.showPoint = NO;
       self.progressView.showProgressText = YES;
       self.progressView.progressLabel.font = [UIFont systemFontOfSize:14];
       self.progressView.pathBackColor = UGRGBColor(85, 117, 245);
       self.progressView.pathFillColor = UGRGBColor(255, 255, 255);
       self.progressView.progress = 1;
       self.progressView.progressLabel.text = @"60";
       self.progressView.progressLabel.textColor = Skin1.textColor1;
       self.progressView.duration = 0;
       self.progressView.increaseFromLast = YES;
  
    }
    return self;
}

@end
