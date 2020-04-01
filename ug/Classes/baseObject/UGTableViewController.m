//
//  UGTableViewController.m
//  ug
//
//  Created by ug on 2019/10/1.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGTableViewController.h"
#import "HSC_MineVC.h"

@interface UGTableViewController ()

@end

@implementation UGTableViewController


- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.edgesForExtendedLayout = UIRectEdgeNone;
	self.extendedLayoutIncludesOpaqueBars = NO;
	
	
}
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	NSArray * hideNavgationbarTypeSet = @[[HSC_MineVC class]];
	if ([hideNavgationbarTypeSet containsValue:self.class]) {
		[self.navigationController setNavigationBarHidden:true];
	} else {
		[self.navigationController setNavigationBarHidden:false];
		
	}
//	[self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//	   [self.navigationController.navigationBar setShadowImage:[UIImage new]];
	
}



@end
