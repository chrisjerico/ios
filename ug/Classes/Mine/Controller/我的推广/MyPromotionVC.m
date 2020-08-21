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
#import "UGinviteInfoModel.h"
#import "CMLabelCommon.h"
#import "PromotionDepositListVC.h"


@interface MyPromotionVC ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UILabel *promotionIdlabel;
@property (weak, nonatomic) IBOutlet UILabel *incomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthMembers;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *headerLabels;
@property (strong, nonatomic) NSArray * items;
@property (strong, nonatomic)  UGinviteInfoModel *mUGinviteInfoModel;
@end

@implementation MyPromotionVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self teamInviteInfoData];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	_headView.backgroundColor = [[UGSkinManagers currentSkin] navBarBgColor];
	_items = @[@"推广赚钱", @"我的推广链接", @"我的会员", @"会员投注", @"会员交易", @"推荐收益说明"];
	_tableView.delegate = self;
	_tableView.dataSource = self;
	[_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
	//	[_tableView reloadData];
    _avatarImageView.layer.cornerRadius = 42;
    _avatarImageView.layer. masksToBounds = YES; // 部分UIView需要设置这个属性
    if (Skin1.isBlack) {
        [self.tableView setBackgroundColor:Skin1.CLBgColor];
        [self.view setBackgroundColor:Skin1.CLBgColor];
//        [self.tableView setSeparatorColor : Skin1.textColor1];
//        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }

    _avatarImageView.layer.borderWidth = 4;
    _avatarImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    
	
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
    if (Skin1.isBlack) {
       cell.textLabel.textColor = Skin1.textColor1;
       cell.backgroundColor = Skin1.cellBgColor;
    }
    else{
        cell.textLabel.textColor = [UIColor colorWithHex:0x484D52];
        cell.backgroundColor = [UIColor whiteColor];
    }
	
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
			PromotionDepositListVC * vc = [[UIStoryboard storyboardWithName:@"MyPromotion" bundle:nil] instantiateViewControllerWithIdentifier:@"PromotionDepositListVC"];
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

#pragma mark - 得到数据
//得到推荐信息数据
- (void)teamInviteInfoData {
    if ([UGUserModel currentUser].isTest) {
        return;
    }
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid};
    
    [SVProgressHUD showWithStatus:nil];
    WeakSelf;
    [CMNetwork teamInviteInfoWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
            [SVProgressHUD dismiss];
            weakSelf.mUGinviteInfoModel = model.data;
            NSLog(@"rid = %@",self.mUGinviteInfoModel.rid);
           
            [weakSelf setUIDate];

        } failure:^(id msg) {
            
            [SVProgressHUD dismiss];
            
        }];
    }];
}

#pragma mark -- UI数据
-(void)setUIDate{
    UGUserModel *user = [UGUserModel currentUser];
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"touxiang-1"]];
    self.nameLabel.text = self.mUGinviteInfoModel.username;
    self.promotionIdlabel.text =self.mUGinviteInfoModel.rid;
    self.incomeLabel.text = self.mUGinviteInfoModel.month_earn;
    NSLog(@"本月推荐会员=%@",self.mUGinviteInfoModel.month_member);
    self.monthMembers.text = [NSString stringWithFormat:@"本月推荐会员:%@",self.mUGinviteInfoModel.month_member];
    
    [CMLabelCommon setRichNumberWithLabel:self.monthMembers Color:RGBA(250, 234, 168, 1) FontSize:12.0];
    
    CGFloat h =  [CMCommon getLabelWidthWithText:self.monthMembers.text stringFont:[UIFont systemFontOfSize:12.0] allowWidth:APP.Width - 80];
//    self.headView.cc_constraints.height.constant = 116 + h -20;
//    [self.tableView reloadData];
//    CGRect frame  =  self.headView.frame;
//    frame.size.height = 116 + h ;
//    self.headView.frame = frame;
    [CMCommon changeHeight:self.headView Height:(116+h)];
    [self.tableView reloadData];
}
@end
