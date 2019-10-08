//
//  UGCommonLotteryController.m
//  ug
//
//  Created by xionghx on 2019/10/1.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGCommonLotteryController.h"
#import "UGLotterySelectController.h"
@interface UGCommonLotteryController ()

@end

@implementation UGCommonLotteryController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	if (self.shoulHideHeader) {
		[self hideHeader];
	}
	if (self.shoulHideContent) {
		[self hideContent];
	}
	[self setupTitleView];
	
}

- (void)hideHeader {
	UIImageView * mmcHeader = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mmcbg" ]];
	[self.view addSubview:mmcHeader];
	[mmcHeader mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.top.equalTo(self.view);
		make.height.equalTo(@114);
	}];
}
- (void)hideContent {
	
}

- (void)setupTitleView {
	
	UILabel * titleLabel = [UILabel new];
	[titleLabel setUserInteractionEnabled:true];
	
	self.navigationItem.titleView = titleLabel;
	titleLabel.text = [NSString stringWithFormat:@"%@ ▼", self.model.name];
	titleLabel.textColor = UIColor.whiteColor;
	[titleLabel addGestureRecognizer: [UITapGestureRecognizer gestureRecognizer:^(__kindof UIGestureRecognizer *gr) {
		UGLotterySelectController * vc = [UGLotterySelectController new];
		vc.dataArray = [self.allList mutableCopy];
		[self presentViewController: vc animated:true completion:nil];
		
		
	}]];
	
}
@end
