//
//  UGUserinfoView.m
//  ug
//
//  Created by ug on 2019/5/28.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGUserinfoView.h"

@implementation UGUserinfoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"UGUserinfoView" owner:self options:0].firstObject;
        self.frame = frame;
    }
    return self;
}

@end
