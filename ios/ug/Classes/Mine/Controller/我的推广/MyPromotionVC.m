//
//  MyPromotionVC.m
//  ug
//
//  Created by xionghx on 2020/1/9.
//  Copyright © 2020 ug. All rights reserved.
//

#import "MyPromotionVC.h"
#import "MyPromotionUrlVC.h"
#import "MyPromotionMembersVC.h"
#import "PromotionIntroductionVC.h"
#import "PromotionMemberRechargeVC.h"
#import "PromotionBetRecordVC.h"
#import "PromotionBetReportVC.h"
#import "PromotionAdvertisementVC.h"


@interface MyPromotionVC ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *headView;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *headerLabels;
@property (strong, nonatomic) NSArray * items;
@end

@implementation MyPromotionVC

- (void)viewDidLoad {
	[super viewDidLoad];
	_headView.backgroundColor = [[UGSkinManagers currentSkin] navBarBgColor];
	_items = @[@"推广赚钱", @"我的推广链接", @"我的会员", @"会员投注", @"会员交易", @"推荐收益说明"];
	_tableView.delegate = self;
	_tableView.dataSource = self;
	[_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
	//	[_tableView reloadData];
	
}

#pragma mark<UITableViewDelegate, UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.items.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
	cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
	cell.textLabel.textColor = [UIColor colorWithHex:0x484D52];
	cell.textLabel.text = _items[indexPath.row];
	cell.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
	cell.imageView.image = [UIImage imageNamed:@[@"my_promotion_tuiguangzhuanqian.png",
												 @"my_promotion_wodetuijianlianjie.png",
												 @"my_promotion_wodehuiyuan.png",
												 @"my_promotion_huiyuantouzhu.png",
												 @"my_promotion_huiyuanjiaoyi.png",
												 @"my_promotion_tuijianshouyishuoming.png"][indexPath.row]];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 56;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.row) {
		case 0:
		{
			PromotionAdvertisementVC * vc = [[UIStoryboard storyboardWithName:@"MyPromotion" bundle:nil] instantiateViewControllerWithIdentifier:@"PromotionAdvertisementVC"];
			[self.navigationController pushViewController:vc animated:true];
		}
			break;
		case 1:
		{
			MyPromotionUrlVC * vc = [[UIStoryboard storyboardWithName:@"MyPromotion" bundle:nil] instantiateViewControllerWithIdentifier:@"MyPromotionUrlVC"];
			[self.navigationController pushViewController:vc animated:true];
		}
			break;
			
		case 2:
		{
			MyPromotionMembersVC * vc = [[UIStoryboard storyboardWithName:@"MyPromotion" bundle:nil] instantiateViewControllerWithIdentifier:@"MyPromotionMembersVC"];
			[self.navigationController pushViewController:vc animated:true];
		}
			break;
		case 3:
		{
			PromotionBetReportVC * vc = [[UIStoryboard storyboardWithName:@"MyPromotion" bundle:nil] instantiateViewControllerWithIdentifier:@"PromotionBetReportVC"];
			[self.navigationController pushViewController:vc animated:true];
		}
			break;
		case 4:
		{
			PromotionBetRecordVC * vc = [[UIStoryboard storyboardWithName:@"MyPromotion" bundle:nil] instantiateViewControllerWithIdentifier:@"PromotionBetRecordVC"];
			[self.navigationController pushViewController:vc animated:true];
		}
			break;
		case 5:
		{
			PromotionIntroductionVC * vc = [[UIStoryboard storyboardWithName:@"MyPromotion" bundle:nil] instantiateViewControllerWithIdentifier:@"PromotionIntroductionVC"];
			[self.navigationController pushViewController:vc animated:true];
		}
			break;
			
		default:
			break;
	}
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 12;
}
@end
