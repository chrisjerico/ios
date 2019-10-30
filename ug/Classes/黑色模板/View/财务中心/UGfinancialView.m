//
//  UGfinancialView.m
//  ug
//
//  Created by ug on 2019/10/30.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGfinancialView.h"

@implementation UGfinancialView

-(instancetype) UGfinancialView{
    NSBundle *bundle=[NSBundle mainBundle];
    NSArray *objs=[bundle loadNibNamed:@"UGfinancialView" owner:nil options:nil];
    return [objs firstObject];
}

-(instancetype)initView{
    if (self = [super init]) {
        self = [self UGfinancialView];
    }
    return self;
}

@end
