//
//  EggFrenzyViewController.m
//  UGBWApp
//
//  Created by xionghx on 2020/8/26.
//  Copyright © 2020 ug. All rights reserved.
//

#import "EggFrenzyViewController.h"
#import "EggGrenzyAwardCollectionCell.h"
#import "EggGrenzyRecordTableCell.h"
#import "GoldEggLogModel.h"

@interface EggFrenzyViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *animationViewCenterX;
@property (weak, nonatomic) IBOutlet UIScrollView *containerScrollView;
@property (weak, nonatomic) IBOutlet UICollectionView *awardsCollectionView;
@property (weak, nonatomic) IBOutlet UITableView *recordTableView;
@property (weak, nonatomic) IBOutlet UITextView *rulesTextView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *eggItems;

@property (weak, nonatomic) IBOutlet UIView *frenzyAnimationView;
@property (weak, nonatomic) IBOutlet UIImageView *frenzyStopImageView;
@property (weak, nonatomic) IBOutlet UIImageView *frenzyAnimationImageView;
@property (weak, nonatomic) IBOutlet UILabel *surplusAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreDescribLabel;

@property (strong, nonatomic) NSArray<GoldEggLogModel*> * recordArray;
@property (weak, nonatomic) IBOutlet UIImageView *awardImageView;
@property (weak, nonatomic) IBOutlet UILabel *awardDescribleLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultDescribleLabel;

@property (strong, nonatomic)dispatch_group_t group;

@end

@implementation EggFrenzyViewController
- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
}
- (void)viewDidLoad {
	[super viewDidLoad];
	[self.titleImageView sd_setImageWithURL: [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"砸金蛋标题" ofType:@"gif"] isDirectory:false]];
	self.surplusAmountLabel.text = [NSString stringWithFormat:@"该局还可以砸4个金蛋"];
	
	self.scoreDescribLabel.text = [NSString stringWithFormat:@"我的积分：%d\n砸蛋所需积分:%@", [UGUserModel currentUser].taskReward.intValue, self.item.param.buy_amount];
	self.rulesTextView.text = nil;
	for (NSString * rule in self.item.param.content_turntable) {
		self.rulesTextView.text = [NSString stringWithFormat:@"%@%@", self.rulesTextView.text? [NSString stringWithFormat:@"%@\n", self.rulesTextView.text]: @"" , rule];
	}
	[self.awardsCollectionView registerNib:[UINib nibWithNibName:@"EggGrenzyAwardCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"EggGrenzyAwardCollectionCell"];
	self.awardsCollectionView.delegate = self;
	self.awardsCollectionView.dataSource = self;
	
	[self.recordTableView registerNib:[UINib nibWithNibName:@"EggGrenzyRecordTableCell" bundle:nil] forCellReuseIdentifier:@"EggGrenzyRecordTableCell"];
	self.recordTableView.delegate = self;
	self.recordTableView.dataSource = self;
	[self refrehRecord];
	WeakSelf;

	SANotificationEventSubscribe(UGNotificationGetUserInfoComplete, self, ^(typeof (self) self, id obj) {
		weakSelf.scoreDescribLabel.text = [NSString stringWithFormat:@"我的积分：%d\n砸蛋所需积分:%@", [UGUserModel currentUser].taskReward.intValue, weakSelf.item.param.buy_amount];
	});
}
- (IBAction)closeButtonAction:(id)sender {
	[self dismissViewControllerAnimated:true completion:nil];
}
- (IBAction)itemButtonTaped:(UIButton *)sender {
	
	[NSLayoutConstraint deactivateConstraints:@[self.animationViewCenterX]];
	self.animationViewCenterX = [NSLayoutConstraint constraintWithItem:self.animationViewCenterX.firstItem attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:sender attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
	[NSLayoutConstraint activateConstraints:@[self.animationViewCenterX]];
	CGFloat width = self.containerScrollView.bounds.size.width;
	[self.containerScrollView setContentOffset:CGPointMake((sender.tag-10000)*width, 0) animated:true];
	
}
- (IBAction)eggButtonTaped:(UIButton *)sender {
	NSUInteger count = 4;
	for (UIButton *item in self.eggItems) {
		if (!item.isEnabled) {
			count --;
		}
	}
	if (count == 0) {
		[SVProgressHUD showErrorWithStatus:@"本局砸蛋次数已用完"];
		return;
	}
	count --;
	[sender setEnabled:false];
	
	self.surplusAmountLabel.text = [NSString stringWithFormat:@"该局还可以砸%ld个金蛋", count];
	[self.frenzyAnimationImageView sd_setImageWithURL: [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"金蛋_打开@3x" ofType:@"gif"] isDirectory:false]];
	
	[self.frenzyAnimationImageView setHidden:false];
	WeakSelf
	dispatch_group_t group = dispatch_group_create();
	dispatch_group_enter(group);
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		dispatch_group_wait(group, DISPATCH_TIME_NOW + 30);
		weakSelf.frenzyAnimationImageView.image = nil;
		[weakSelf.frenzyAnimationImageView setHidden:true];
		[weakSelf.frenzyAnimationView setHidden:false];
	});
	[self frenzy:^{
		dispatch_group_leave(group);
		SANotificationEventPost(UGNotificationGetUserInfo, weakSelf);
	}];
	[self refrehRecord];
	
}
// 砸
- (void)frenzy: (void (^)(void)) completionHandle {
	
	NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
							 @"activityId":self.item.DZPid};
	WeakSelf
	[CMNetwork activityGoldenEggWinWithParams:params completion:^(CMResult<id> *model, NSError *err) {
		[CMResult processWithResult:model success:^{
			NSInteger code  = model.code;
			dispatch_async(dispatch_get_main_queue(), ^{
				if (code == 0) {
					if ([[model.data objectForKey:@"prizeflag"] isEqualToNumber:[[NSNumber alloc] initWithInt:1]]) {
						weakSelf.resultDescribleLabel.text = @"手气不错";
					} else  {
						weakSelf.resultDescribleLabel.text = @"谢谢惠顾";
					}
					weakSelf.awardDescribleLabel.text = [model.data objectForKey:@"prizeName"];
					weakSelf.awardImageView.image = nil;
					[weakSelf.awardImageView sd_setImageWithURL:[NSURL URLWithString:[model.data objectForKey:@"prizeIcon"]]];
				}
				else{
					[SVProgressHUD showErrorWithStatus:model.msg];
				}
			});
			
		} failure:^(id msg) {
			dispatch_async(dispatch_get_main_queue(), ^{
				[SVProgressHUD showErrorWithStatus:msg];
			});
			
		}];
		completionHandle();

	}];
	//	activityGoldenEggWinWithParams
}

// 刷新日志
- (void)refrehRecord {
	NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
							 @"activityId":self.item.DZPid};
	WeakSelf
	[CMNetwork activityGoldenEggLogWithParams:params completion:^(CMResult<id> *model, NSError *err) {
		[CMResult processWithResult:model success:^{
			dispatch_async(dispatch_get_main_queue(), ^{
				NSArray * dataArray = (NSArray *)model.data;
				if (!dataArray.count) { return; }
				weakSelf.recordArray = [[GoldEggLogModel mj_objectArrayWithKeyValuesArray:dataArray] copy];
				[weakSelf.recordTableView reloadData];
			});
		} failure:^(id msg) {
			[SVProgressHUD showErrorWithStatus:msg];
		}];
	}];
}

- (IBAction)frenzyConfirmButtonAction:(id)sender {
	[self.frenzyAnimationView setHidden:true];
}


- (void)setItem:(DZPModel *)item {
	item.param.prizeArr = [[DZPprizeModel mj_objectArrayWithKeyValuesArray:item.param.prizeArr] copy];
	_item = item;
	
}
#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return self.item.param.prizeArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	EggGrenzyAwardCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EggGrenzyAwardCollectionCell" forIndexPath:indexPath];
	[cell bind:self.item.param.prizeArr[indexPath.item]];
	return cell;
}

#pragma mark ---- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	return CGSizeMake(collectionView.bounds.size.width/3.0, collectionView.bounds.size.height);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
	return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
	return 5;
}

#pragma mark -  UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.recordArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	EggGrenzyRecordTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"EggGrenzyRecordTableCell" forIndexPath:indexPath];
	[cell bind:self.recordArray[indexPath.row]];
	return cell;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
