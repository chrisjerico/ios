//
//  UGViewController.m
//  ug
//
//  Created by ug on 2019/10/1.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGViewController.h"
#import "JS_MineVC.h"
//#import "XBJ_HomeVC.h"

@interface UGViewController ()

@end

@implementation UGViewController




- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	//    [self.view setBackgroundColor: Skin1.bgColor];
	self.edgesForExtendedLayout = UIRectEdgeNone;
	self.extendedLayoutIncludesOpaqueBars = NO;
	
	
	
	
}
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];


}

@end
