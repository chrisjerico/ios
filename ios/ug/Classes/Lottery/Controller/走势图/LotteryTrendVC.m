//
//  LotteryTrendVC.m
//  ug
//
//  Created by xionghx on 2020/1/18.
//  Copyright © 2020 ug. All rights reserved.
//

#import "LotteryTrendVC.h"

@interface LotteryTrendVC ()

@end

@implementation LotteryTrendVC

- (void)viewDidLoad {
    [super viewDidLoad];
	[SVProgressHUD showWithStatus:nil];
	[CMNetwork getLotteryTrend:@{@"gameMark": @"yflhc"} completion:^(CMResult<id> *model, NSError *err) {
		
		if (err) {
			[SVProgressHUD showErrorWithStatus:err.localizedDescription];
		} else {
			
		}
		
	}];
}



@end
    
