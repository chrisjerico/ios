//
//  UGBetRecorddHeaderView.m
//  ug
//
//  Created by ug on 2019/5/30.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGBetRecorddHeaderView.h"

@interface UGBetRecorddHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *rightTitleLabel;
@end
@implementation UGBetRecorddHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"UGBetRecorddHeaderView" owner:self options:0].firstObject;
        self.frame = frame;
    }
    return self;
}

- (void)setRightTitle:(NSString *)rightTitle {
    _rightTitle = rightTitle;
    self.rightTitleLabel.text = rightTitle;
}

@end
