//
//  MyPromotionMembersVC.m
//  ug
//
//  Created by xionghx on 2020/1/10.
//  Copyright © 2020 ug. All rights reserved.
//

#import "MyPromotionMembersVC.h"
#import "UGinviteLisModel.h"
#import <objc/runtime.h>
#import "PromotionMemberRechargeVC.h"
#import "YBPopupMenu.h"
static NSString * promotionMemberItemKey = @"promotionMemberItemKey";
@interface UIStackView (bindText)
- (void)bindContent: (NSString *)content;
- (void)bindHandle: (void (^)(UIButton *)) handle;
@end
@interface UIButton (hasItem)
@property(nonatomic, strong) UGinviteLisModel* promotionMember;
@end
@interface MyPromotionMembersVC ()<YBPopupMenuDelegate>
{
	NSInteger _levelindex;
	NSArray * _levelArray;
}
@property (weak, nonatomic) IBOutlet UIScrollView *rootScrollView;
@property (weak, nonatomic) IBOutlet UIStackView *nameStack;
@property (weak, nonatomic) IBOutlet UIStackView *handleStack;
@property (weak, nonatomic) IBOutlet UIStackView *levelStack;
@property (weak, nonatomic) IBOutlet UIStackView *statusStack;
@property (weak, nonatomic) IBOutlet UIStackView *ifWinStack;
@property (weak, nonatomic) IBOutlet UIStackView *lastLoginStack;
@property (weak, nonatomic) IBOutlet UIStackView *regTimeStack;
@property (weak, nonatomic) IBOutlet UIView *levelSelectView;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImage;
@property (weak, nonatomic) IBOutlet UIButton *levelSelectButton;

@property(nonatomic, strong) NSMutableArray * items;
@end

@implementation MyPromotionMembersVC

- (void)viewDidLoad {
	[super viewDidLoad];
	self.items = [NSMutableArray array];
	_levelArray = @[@"全部下线",@"1级下线",@"2级下线",@"3级下线",@"4级下线",@"5级下线",@"6级下线",@"7级下线",@"8级下线",@"9级下线",@"10级下线"];
	_levelindex = 0;
	WeakSelf;
	self.rootScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
		[weakSelf loadData];
	}];
	[self cleanAllStack];
	[self loadData];
	
}
- (void)loadData {
	if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
		return;
	}
	if ([UGUserModel currentUser].isTest) {
		return;
	}
	NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
							 @"level":[NSString stringWithFormat:@"%ld",(long)_levelindex],
	};
	
	[SVProgressHUD showWithStatus:nil];
	WeakSelf;
	[CMNetwork teamInviteListWithParams:params completion:^(CMResult<id> *model, NSError *err) {
		[CMResult processWithResult:model success:^{
			
			[SVProgressHUD dismiss];
			
			NSDictionary *data =  model.data;
			NSArray *list = [data objectForKey:@"list"];
			NSArray *array =  [UGinviteLisModel arrayOfModelsFromDictionaries:list error:nil];
			[weakSelf bind:array];
			
			[self.rootScrollView.mj_header endRefreshing];
			
		} failure:^(id msg) {
			[SVProgressHUD showErrorWithStatus:msg];
			
		}];
		
		
	}];
}
- (void)bind: (NSArray<UGinviteLisModel*> *) items {
	
	self.items = items.mutableCopy;
	[self cleanAllStack];
	for (NSInteger i = 0; i < items.count; i++) {
		UGinviteLisModel * item = items[i];
		[self.nameStack bindContent:[NSString stringWithFormat:@"%@\n%@", item.username,item.name]];
		[self.levelStack bindContent:item.level];
		[self.statusStack bindContent:item.enable];
		[self.ifWinStack bindContent:item.sunyi];
		[self.lastLoginStack bindContent:item.accessTime];
		[self.regTimeStack bindContent:item.regtime];
		WeakSelf
		[self.handleStack bindHandle:^(UIButton * button) {
			button.promotionMember = item;
			[button addTarget:weakSelf action:@selector(rechargeButtonTaped:) forControlEvents:UIControlEventTouchUpInside];
		}];
	}
}
- (void)cleanAllStack {
	
	NSArray * allStack = @[self.nameStack,
						   self.levelStack,
						   self.statusStack,
						   self.ifWinStack,
						   self.lastLoginStack,
						   self.regTimeStack,
						   self.handleStack,];
	for (UIStackView * stack in allStack) {
		for (UIView * view in stack.arrangedSubviews) {
			[stack removeArrangedSubview:view];
			[view removeFromSuperview];
		}
	}
}
-(void)rechargeButtonTaped: (UIButton *)sender {
	UGinviteLisModel * member = sender.promotionMember;
	if (![member.is_setting isEqualToString:@"1"]) {
		[SVProgressHUD showErrorWithStatus:@"充值功能已关闭"];
		return;
	}
	PromotionMemberRechargeVC * vc = [[UIStoryboard storyboardWithName:@"MyPromotion" bundle:nil] instantiateViewControllerWithIdentifier:@"PromotionMemberRechargeVC"];
	vc.modalPresentationStyle = UIModalPresentationFullScreen;
	[self presentViewController: [[UGNavigationController alloc] initWithRootViewController:vc] animated:true completion:^{
		[vc bindMember:member];
	}];
	
}
- (IBAction)levelButtonTaped:(id)sender {
	CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI);
	self.arrowImage.transform = transform;
	
	YBPopupMenu *popView = [[YBPopupMenu alloc] initWithTitles:_levelArray icons:nil menuWidth:CGSizeMake(UGScreenW / _levelArray.count + 70, 180) delegate:self];
	popView.type = YBPopupMenuTypeDefault;
	popView.fontSize = 12;
	popView.textColor = [UIColor colorWithHex:0x484D52];
	[popView showRelyOnView:self.levelSelectView];
}

#pragma mark YBPopupMenuDelegate

- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu {
	if (index >= 0) {
		_levelindex = index;
		[self.levelSelectButton setTitle:_levelArray[index] forState:UIControlStateNormal];
		[self loadData];
		//       [self swithAction];
	}
	
	CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI * 2);
	self.arrowImage.transform = transform;
}
@end


@implementation UIStackView (bindText)

- (void)bindContent: (NSString *)content {
	UIView * view = [UIView new];
	view.backgroundColor = UIColor.whiteColor;
	UILabel * label = [UILabel new];
	label.textColor = [UIColor colorWithHex:0x484D52];
	label.font = [UIFont systemFontOfSize:12];
	label.textAlignment = NSTextAlignmentCenter;
	label.numberOfLines = 0;
	[view addSubview:label];
	[label mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(view);
		make.height.equalTo(@52);
	}];
	label.text = content;
	[self addArrangedSubview:view];
}

- (void)bindHandle: (void (^)(UIButton *)) handle {
	UIView * view = [UIView new];
	view.backgroundColor = UIColor.whiteColor;
	UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setTitle:@"充值" forState:UIControlStateNormal];
	[button setTitleColor: [UIColor colorWithHex:0xF15C5F] forState:UIControlStateNormal];
	button.titleLabel.font = [UIFont systemFontOfSize:12];
	[view addSubview:button];
	[button mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(view);
		make.height.equalTo(@52);
	}];
	[self addArrangedSubview:view];
	handle(button);
}
@end

@implementation UIButton (hasItem)
-(void)setPromotionMember:(UGinviteLisModel *)promotionMember {
	objc_setAssociatedObject(self, &promotionMemberItemKey, promotionMember, OBJC_ASSOCIATION_COPY);
}
- (UGinviteLisModel *)promotionMember {
	return objc_getAssociatedObject(self, &promotionMemberItemKey);
}
@end
