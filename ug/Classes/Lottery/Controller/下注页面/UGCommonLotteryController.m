//
//  UGCommonLotteryController.m
//  ug
//
//  Created by xionghx on 2019/10/1.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGCommonLotteryController.h"
#import "UGLotterySelectController.h"

// View
#import "STBarButtonItem.h"

@interface UGCommonLotteryController ()

@end


@implementation UGCommonLotteryController

- (BOOL)允许游客访问 { return true; }

- (void)viewDidLoad {
	[super viewDidLoad];
	[self setupTitleView];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	if (self.shoulHideHeader) {
		[self hideHeader];
	}
}

- (void)hideHeader {
	UIImageView * mmcHeader = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mmcbg" ]];
	[self.view addSubview:mmcHeader];
	[mmcHeader mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.top.equalTo(self.view);
		make.height.equalTo(@114);
	}];
}

- (void)getGameDatas {}

- (void)setupTitleView {
    STBarButtonItem *item0 = [STBarButtonItem barButtonItemWithTitle:_NSString(@"%@ ▼", self.nextIssueModel.title ? : @"") target:self action:@selector(onTitleClick)];
    self.navigationItem.leftBarButtonItems = @[self.navigationItem.leftBarButtonItems.firstObject, item0];
    self.navigationItem.titleView = [UIView new];   // 隐藏标题
    
    if (OBJOnceToken(self)) {
        [self.navigationItem aspect_hookSelector:@selector(setTitle:) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> ai) {
            NSString *title = ai.arguments.lastObject;
            [(UIButton *)item0.customView setTitle:_NSString(@"%@ ▼", title) forState:UIControlStateNormal];
            [(UIButton *)item0.customView sizeToFit];
        } error:nil];
    }
}

- (void)onTitleClick {
    UGLotterySelectController * vc = [UGLotterySelectController new];
    vc.didSelectedItemBlock = ^(UGNextIssueModel *nextModel) {
        [UGCommonLotteryController pushWithModel:nextModel];
    };
    UGNavigationController * nav = [[UGNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:true completion:nil];
}

@end
