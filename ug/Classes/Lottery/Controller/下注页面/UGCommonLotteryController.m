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
    
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [UGCommonLotteryController cc_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionAfter usingBlock:^(id <AspectInfo> aspectInfo) {
            NSLog(@"%@-->:%@", @"Appear 下注界面:😜😜😜", NSStringFromClass([aspectInfo.instance class]));
            UIViewController *vc = (UIViewController *)aspectInfo.instance;
            FastSubViewCode(vc.view);
            if ([Skin1.skitType isEqualToString:@"黑色模板"]) {
                vc.view.backgroundColor =  Skin1.bgColor;
                [subView(@"上背景View") setBackgroundColor:Skin1.bgColor];
                [subLabel(@"期数label") setTextColor:Skin1.textColor1];
                [subLabel(@"聊天室label") setTextColor:Skin1.textColor1];
                [subLabel(@"线label") setBackgroundColor:Skin1.textColor1];
                [subView(@"中间view") setBackgroundColor:Skin1.bgColor];
                [[vc valueForKey:@"nextIssueLabel"] setTextColor:Skin1.textColor1];
                [[vc valueForKey:@"closeTimeLabel"] setTextColor:Skin1.textColor1];
                [[vc valueForKey:@"openTimeLabel"] setTextColor:Skin1.textColor1];
                [subLabel(@"中间线label") setBackgroundColor:Skin1.textColor1];
                [[vc valueForKey:@"tableView"] setBackgroundColor:[UIColor clearColor]];
                [[vc valueForKey:@"bottomView"] setBackgroundColor:Skin1.bgColor];
                
            } else {
                vc.view.backgroundColor =  [UIColor whiteColor];
                [subView(@"上背景View") setBackgroundColor: [UIColor whiteColor]];
                [subLabel(@"期数label") setTextColor: [UIColor blackColor]];
                [subLabel(@"聊天室label") setTextColor:[UIColor blackColor]];
                [subLabel(@"线label") setBackgroundColor:[UIColor lightGrayColor]];
                [[vc valueForKey:@"nextIssueLabel"] setTextColor:[UIColor blackColor]];
                [[vc valueForKey:@"closeTimeLabel"] setTextColor:[UIColor blackColor]];
                [[vc valueForKey:@"openTimeLabel"] setTextColor:[UIColor blackColor]];
                [subLabel(@"中间线label") setBackgroundColor:[UIColor lightGrayColor]];
                [[vc valueForKey:@"tableView"] setBackgroundColor:[UIColor whiteColor]];
                [[vc valueForKey:@"bottomView"] setBackgroundColor:RGBA(100, 101, 103, 1)];
            }
        } error:NULL];
        
        // 处理OpenLabel
        [UGCommonLotteryController cc_hookSelector:@selector(updateOpenLabel) withOptions:AspectPositionAfter usingBlock:^(id <AspectInfo> aspectInfo) {
            UIViewController *vc = (UIViewController *)aspectInfo.instance;
            UILabel *openTimeLabel = [vc valueForKey:@"openTimeLabel"];
            if ([Skin1.skitType isEqualToString:@"黑色模板"]) {
                if (openTimeLabel.text.length) {
                    NSMutableAttributedString *abStr = [[NSMutableAttributedString alloc] initWithString:openTimeLabel.text];
                    [abStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(3, openTimeLabel.text.length - 3)];
                    openTimeLabel.attributedText = abStr;
                }
            } else {
                if (openTimeLabel.text.length) {
                    NSMutableAttributedString *abStr = [[NSMutableAttributedString alloc] initWithString:openTimeLabel.text];
                    [abStr addAttribute:NSForegroundColorAttributeName value:Skin1.navBarBgColor range:NSMakeRange(3, openTimeLabel.text.length - 3)];
                    openTimeLabel.attributedText = abStr;
                }
            }
        } error:NULL];
    });
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
        [self.navigationItem cc_hookSelector:@selector(setTitle:) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> ai) {
            NSString *title = ai.arguments.lastObject;
            [(UIButton *)item0.customView setTitle:_NSString(@"%@ ▼", title) forState:UIControlStateNormal];
            [(UIButton *)item0.customView sizeToFit];
        } error:nil];
    }
}

- (void)onTitleClick {
    UGLotterySelectController * vc = [UGLotterySelectController new];
    vc.didSelectedItemBlock = ^(UGNextIssueModel *nextModel) {
        [NavController1 pushViewControllerWithNextIssueModel:nextModel];
    };
    UGNavigationController * nav = [[UGNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:true completion:nil];
}

@end
