//
//  UGOnlineWithdrawalsView.m
//  ug
//
//  Created by ug on 2019/10/30.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGOnlineWithdrawalsView.h"

@implementation UGOnlineWithdrawalsView

-(instancetype) UGOnlineWithdrawalsView{
    NSBundle *bundle=[NSBundle mainBundle];
    NSArray *objs=[bundle loadNibNamed:@"UGOnlineWithdrawalsView" owner:nil options:nil];
    return [objs firstObject];
}

-(instancetype)initView{
    if (self = [super init]) {
        self = [self UGOnlineWithdrawalsView];
    }
    return self;
}

@end
