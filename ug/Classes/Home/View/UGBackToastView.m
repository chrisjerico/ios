//
//  UGBackToastView.m
//  ugqp
//
//  Created by ug on 2019/8/10.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGBackToastView.h"

@interface UGBackToastView ()

@end
@implementation UGBackToastView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"UGBackToastView" owner:self options:0].firstObject;
        self.frame = frame;
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 1;
        self.layer.borderColor = UGTextColor.CGColor;
    }
    return self;
}

- (IBAction)cancelClick:(id)sender {
    [self popupHidden];
}

- (IBAction)sureClick:(id)sender {
    if (self.backHomeBlock) {
        self.backHomeBlock();
    }
    [self popupHidden];
    
}

@end
