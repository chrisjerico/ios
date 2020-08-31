//
//  ScratchController.m
//  UGBWApp
//
//  Created by xionghx on 2020/8/27.
//  Copyright © 2020 ug. All rights reserved.
//

#import "ScratchController.h"
#import "ScratchActionController.h"
#import "ScratchLogModel.h"
#import "EggGrenzyRecordTableCell.h"
#import "JSONModel.h"
#import "ScratchDataModel.h"
#import "ScratchParamModel.h"
#import "GoldEggLogTableHeaderView.h"

@interface ScratchController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *resultLabels;
@property (weak, nonatomic) IBOutlet UILabel *avaliableTimesLabel;
@property (weak, nonatomic) IBOutlet UIView *replayView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *animationViewCenterY;
@property (weak, nonatomic) IBOutlet UIScrollView *containerScrollView;
@property (weak, nonatomic) IBOutlet UITableView *recordTableView;
@property (weak, nonatomic) IBOutlet UITextView *rulesTextView;
@property (nonatomic, strong) NSArray *recordArray;
@property (nonatomic, strong) NSMutableArray * winList;
@property (nonatomic, strong) GoldEggLogTableHeaderView *headerView;
@property (nonatomic, strong) NSString * logType;
@end

@implementation ScratchController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.rulesTextView.text = nil;
	for (NSString * rule in self.item.scratchList[0].param[@"content_turntable"]) {
		self.rulesTextView.text = [NSString stringWithFormat:@"%@%@", self.rulesTextView.text? [NSString stringWithFormat:@"%@\n", self.rulesTextView.text]: @"" , rule];
	}
	self.winList = [NSMutableArray array];
	[self.winList addObjectsFromArray:self.item.scratchWinList];
	self.avaliableTimesLabel.text = [NSString stringWithFormat:@"%ld", self.winList.count];
	
	[self.recordTableView registerNib:[UINib nibWithNibName:@"EggGrenzyRecordTableCell" bundle:nil] forCellReuseIdentifier:@"EggGrenzyRecordTableCell"];
	self.recordTableView.delegate = self;
	self.recordTableView.dataSource = self;
	self.headerView = (GoldEggLogTableHeaderView*)[[[NSBundle mainBundle] loadNibNamed:@"GoleEggLogTableHeaderView" owner:self options:nil] lastObject];
	self.headerView.autoresizingMask = UIViewAutoresizingNone;
	
	self.recordTableView.tableHeaderView = self.headerView;
	[self refrehRecord];
}
- (void)setLogType:(NSString *)logType {
	_logType = logType;
	if ([logType isEqualToString:@"1"]) {
		self.headerView.fistLabel.text = @"中奖账号";
	} else {
		self.headerView.fistLabel.text = @"奖品编号";
	}
}
// 刷新日志
- (void)refrehRecord {
	NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
							 @"activityId":self.item.scratchList[0].gameID};
	WeakSelf
	[CMNetwork activityScratchLogWithParams:params completion:^(CMResult<id> *model, NSError *err) {
		[CMResult processWithResult:model success:^{
			dispatch_async(dispatch_get_main_queue(), ^{
				NSArray * dataArray = (NSArray *)model.data[@"scratchLog"];
				weakSelf.logType =  model.data[@"prizeShowType"];
				if (!dataArray.count) { return; }
				weakSelf.recordArray = [[ScratchLogModel mj_objectArrayWithKeyValuesArray:dataArray] copy];
				[weakSelf.recordTableView reloadData];
			});
		} failure:^(id msg) {
//			[SVProgressHUD showErrorWithStatus:msg];
		}];
	}];
}
- (IBAction)closeButtonAction:(UIButton *)sender {
	[self dismissViewControllerAnimated:true completion:nil];
}
- (IBAction)itemButtonAction:(UIButton *)sender {
	
	if (self.item.scratchList[0].showType != 2) {
		[SVProgressHUD showErrorWithStatus:@"活动未开始"];
		return;
	}
	
	if (!(self.winList.count > 0)) {
		[SVProgressHUD showErrorWithStatus:@"刮奖次数不够"];
		return;
	}
	

	ScratchActionController *vc = [[ScratchActionController alloc] init];
	vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
	vc.item = self.winList[0];
	WeakSelf
	[vc bindNumber: sender.tag-10000 resultBlock:^(NSString * _Nonnull result) {
		UILabel * label = weakSelf.resultLabels[sender.tag - 10001];
		label.text  = [NSString stringWithFormat:@"彩金%@", vc.item.amount];
		[label setHidden:false];
		[sender setEnabled:false];
		[weakSelf.winList removeObjectAtIndex:0];
		weakSelf.avaliableTimesLabel.text = [NSString stringWithFormat:@"%ld", weakSelf.winList.count];
		[weakSelf refrehRecord];
		
		NSInteger count = 0;
		for (UILabel * label in weakSelf.resultLabels) {
			if (!label.isHidden) { count ++; }
		}
		if (count >= 6) {
			[weakSelf.replayView setHidden:false];
		}
		
	}];
	
	[self presentViewController:vc animated:true completion:nil];
	
	
}
- (IBAction)gameResetAction:(id)sender {
	
	for (UILabel * label in self.resultLabels) {
		[label setHidden:true];
	}
	
	for (NSInteger i = 0; i<9 ; i++) {
		UIButton * button  = (UIButton *)[self.view viewWithTag:i + 10000 + 1];
		[button setEnabled:true];
	}
	
	
}

- (IBAction)itemButtonTaped:(UIButton *)sender {
	
	[NSLayoutConstraint deactivateConstraints:@[self.animationViewCenterY]];
	self.animationViewCenterY = [NSLayoutConstraint constraintWithItem:self.animationViewCenterY.firstItem attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:sender attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
	[NSLayoutConstraint activateConstraints:@[self.animationViewCenterY]];
	CGFloat height = self.containerScrollView.bounds.size.height;
	[self.containerScrollView setContentOffset:CGPointMake(0, (sender.tag-1000)*height) animated:false];
	
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
	[cell bindScratchLog:self.recordArray[indexPath.row] type:self.logType];
	return cell;
}


@end
