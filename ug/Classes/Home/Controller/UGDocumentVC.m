//
//  UGDocumentVC.m
//  ug
//
//  Created by xionghx on 2019/9/25.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGDocumentVC.h"
#import "UGAllNextIssueListModel.h"
#import "UGLotteryResultCollectionViewCell.h"
#import "UGLotterySubResultCollectionViewCell.h"
#import "CMNetwork+Document.h"
#import "UGDocumentDetailVC.h"
#import "UGFastThreeOneCollectionViewCell.h"
#import "UGDocumentView.h"

@interface UGDocumentVC ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong)GameModel * model;


@property(nonatomic, strong) UITableView * tableView;

@property(nonatomic, strong) NSArray<DocumentModel*> * documentListData;

@property(nonatomic, strong) UGNextIssueModel * nextIssue;

@property (nonatomic, strong) dispatch_group_t completionGroup;

@property (nonatomic, strong) IssueView * issueView;

@property (nonatomic, strong) UIButton * titleButton;
@end

@implementation UGDocumentVC

- (instancetype)initWithModel: (GameModel *)model
{
	self = [super init];
	if (self) {
		_model = model;
		
	}
	return self;
}
- (void)setModel:(GameModel *)model {
	_model = model;
	[_titleButton setTitle:[NSString stringWithFormat:@"%@ ▼", model.name] forState:UIControlStateNormal];

}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[self.view addSubview:self.tableView];
	[self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.view);
	}];
	
	[self requestData: @""];
	
	_titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
	_titleButton.frame = CGRectMake(0, 0, 200, 40);
	[_titleButton setTitle:[NSString stringWithFormat:@"%@ ▼", self.model.name] forState:UIControlStateNormal];
	[_titleButton addTarget:self action:@selector(titleButtonTaped:)];
	
	self.navigationItem.titleView = _titleButton;
	
}

- (void)titleButtonTaped: (UIButton *)sender {
	[DocumentTypeList showIn:self.view completionHandle:^(GameModel * _Nonnull model) {
		self.model = model;
		[SVProgressHUD showWithStatus:nil];
//		[sender setTitle:[NSString stringWithFormat:@"%@ ▼", self.model.name] forState:UIControlStateNormal];

		[self requestData:@""];
	}];
	
}

- (void)requestData: (NSString *) title {
	
	NSMutableDictionary *params = @{@"id": self.model.type}.mutableCopy;
	WeakSelf
	
	if ([title isEqualToString:@""]) {
		dispatch_group_enter(self.completionGroup);
		
		[CMNetwork getNextIssueWithParams:params completion:^(CMResult<id> *model, NSError *err) {
			[CMResult processWithResult:model success:^{
				weakSelf.nextIssue = model.data;
				dispatch_group_leave(weakSelf.completionGroup);
				
			} failure:^(id msg) {
				dispatch_group_leave(weakSelf.completionGroup);
				
			}];
		}];
	}
	
	dispatch_group_enter(self.completionGroup);
	params[@"category"] = self.model.gameId;
	params[@"title"] = title;
	[CMNetwork getDocumnetListWithParams:params completion:^(CMResult<id> *model, NSError *err) {
		[CMResult processWithResult:model success:^{
			
			DocumentListModel * data = model.data;
			weakSelf.documentListData = data.list;
			
			if (data.list.count > 0) {
				[self.tableView.mj_footer setHidden:true];
			} else {
				[self.tableView.mj_footer endRefreshingWithNoMoreData];
			}
			dispatch_group_leave(weakSelf.completionGroup);
		} failure:^(id msg) {
			dispatch_group_leave(weakSelf.completionGroup);
			
		}];
	}];
	
	dispatch_group_notify(self.completionGroup, dispatch_get_main_queue(), ^{
		[SVProgressHUD dismiss];
		[weakSelf.tableView.mj_header endRefreshing];
		[weakSelf.tableView reloadData];
		//		weakSelf.navigationItem.title = weakSelf.nextIssue.title;
	});
	
}





- (UITableView *)tableView {
	
	if (!_tableView) {
		
		_tableView = [[UITableView alloc] initWithFrame:CGRectZero style: UITableViewStylePlain];
		_tableView.delegate = self;
		_tableView.dataSource = self;
		_tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
			[self requestData:@""];
		}];
		_tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
			
		}];
		[_tableView registerClass:[DocumentCell class] forCellReuseIdentifier:@"DocumentCell"];
		
		_tableView.tableFooterView = [UIView new];
		[_tableView.mj_footer setState: MJRefreshStateNoMoreData];
		
		
	}
	return _tableView;
}

- (dispatch_group_t)completionGroup {
	if (!_completionGroup) {
		_completionGroup = dispatch_group_create();
	}
	return _completionGroup;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.documentListData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	DocumentCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DocumentCell"];
	cell.textLabel.text = self.documentListData[indexPath.row].title;
	cell.textLabel.font = [UIFont systemFontOfSize:16];
	cell.textLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	UILabel * accessLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
	accessLabel.text = @"详情>>";
	accessLabel.font = [UIFont systemFontOfSize:14];
	accessLabel.textColor = [UIColor blueColor];
	cell.accessoryView = accessLabel;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UGUserModel * user = [UGUserModel currentUser];
	NSString * token = user.sessid;
	
	[SVProgressHUD showWithStatus:nil];
	DocumentModel * document = self.documentListData[indexPath.row];
	[CMNetwork getDocumnetDetailWithParams:@{@"id": document.articleID, @"token": token} completion:^(CMResult<id> *model, NSError *err) {
		[CMResult processWithResult:model success:^{
			[SVProgressHUD dismiss];
			UGDocumentDetailData * documentDetailModel = model.data;
			
			if (documentDetailModel.canRead) {
//				UGDocumentDetailVC *vc = [UGDocumentDetailVC new];
//				vc.model = documentDetailModel;
//				[self presentViewController:vc animated:true completion:nil];
				
				
				[UGDocumentView showWith:documentDetailModel];
				
//				
				
			} else if (user.isTest){
				
				
				UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"该资料需要正式会员才能阅读，请登录后查看" preferredStyle:UIAlertControllerStyleAlert];
				[alert addAction:[UIAlertAction actionWithTitle:@"确认" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
					
				}]];
				[self presentViewController:alert animated:true completion:nil];
				
				
			} else if (!documentDetailModel.hasPay) {
				
				
				UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"注意：您没有浏览权限。\n打赏后本期无限浏览此资料。" preferredStyle:UIAlertControllerStyleAlert];
				[alert addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"打赏%.2f元", documentDetailModel.amount] style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
					
					
					
					UIAlertController * alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"确认打赏%.2f元",documentDetailModel.amount] message:nil preferredStyle:UIAlertControllerStyleAlert];
					
					[alert addAction: [UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleDefault handler:nil]];
					[alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
						[SVProgressHUD showWithStatus:nil];
						
						[CMNetwork getDocumnetPayWithParams:@{@"id": document.articleID, @"token": token} completion:^(CMResult<id> *model, NSError *err) {
							[SVProgressHUD showInfoWithStatus:model.msg];
						}];
					}]];
					
					[self presentViewController:alert animated:true completion:nil];
					
					
					
				}]];
				[alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
				[self presentViewController:alert animated:true completion:nil];
			}
			
		}];
	}];
	[tableView deselectRowAtIndexPath:indexPath animated:false];
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	
	return 200;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	WeakSelf
	IssueView *issueView = [[IssueView alloc] init];
	issueView.nextIssueModel = self.nextIssue;
	issueView.searchBlock = ^(NSString * text) {
		[SVProgressHUD showWithStatus:nil];
		[weakSelf requestData:text];
		
	};
	return issueView;
	//	return self.issueView;
	
}

- (IssueView *)issueView {
	if (!_issueView) {
		_issueView = [[IssueView alloc] init];
		_issueView.nextIssueModel = self.nextIssue;
		WeakSelf
		_issueView.searchBlock = ^(NSString * text) {
			[SVProgressHUD showWithStatus:nil];
			[weakSelf requestData:text];
			
		};
	}
	return _issueView;
}



@end



/// 开奖信息
@interface IssueView ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (strong, nonatomic) UILabel *currentIssueLabel;
@property (strong, nonatomic) UILabel *nextIssueLabel;
@property (strong, nonatomic) UILabel *closeTimeLabel;
@property (strong, nonatomic) UILabel *openTimeLabel;
@property (strong, nonatomic) UIView *nextIssueView;
@property (nonatomic, strong) NSArray *preNumArray;
@property (nonatomic, strong) NSArray *subPreNumArray;
@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation IssueView
static NSString *leftTitleCellid = @"UGTimeLotteryLeftTitleCell";
static NSString *lottryBetCellid = @"UGTimeLotteryBetCollectionViewCell";
static NSString *oneimgCellid = @"UGFastThreeTwoCollectionViewCell";
static NSString *twoImgCellid = @"UGFastThreeThreeCollectionViewCell";
static NSString *threeImgCellid = @"UGFastThreeFourCollectionViewCell";
static NSString *headerViewID = @"UGTimeLotteryBetHeaderView";
static NSString *lotteryResultCellid = @"UGFastThreeOneCollectionViewCell";
static NSString *lotterySubResultCellid = @"UGLotterySubResultCollectionViewCell";
- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		
		
		[self addSubview:self.currentIssueLabel];
		[self.currentIssueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self).offset(15);
			make.left.equalTo(self).offset(10);
		}];
		
		[self addSubview: self.collectionView];
		[self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self.currentIssueLabel.mas_right).offset(10);
			make.top.equalTo(self).offset(10);
			make.right.equalTo(self);
			make.height.equalTo(@80);
		}];
		
		UIView * line = ({
			UIView * view = [UIView new];
			view.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
			view;
		});
		[self addSubview:line];
		[line mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.right.equalTo(self);
			make.height.equalTo(@0.5);
			make.top.equalTo(self.currentIssueLabel.mas_bottom).offset(50);
		}];
		
		[self addSubview:self.nextIssueLabel];
		[self.nextIssueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self.currentIssueLabel);
			make.top.equalTo(line.mas_bottom).offset(15);
		}];
		
		[self addSubview:self.closeTimeLabel];
		[self.closeTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self.collectionView);
			make.top.equalTo(self.nextIssueLabel);
		}];
		[self addSubview:self.openTimeLabel];
		[self.openTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self.nextIssueLabel);
			make.left.equalTo(self.closeTimeLabel.mas_right).offset(10);
		}];
		UIButton * searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[searchButton setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
		[searchButton addTarget:self action:@selector(searchButtonTaped:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:searchButton];
		searchButton.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1.0];
		searchButton.contentMode = UIViewContentModeCenter;
		[searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(20);
			make.top.equalTo(self.nextIssueLabel.mas_bottom).offset(20);
			make.width.equalTo(@60);
			make.height.equalTo(@40);
		}];
		
		
		[self addSubview:self.searchField];
		[self.searchField mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(searchButton.mas_right);
			make.right.equalTo(self).offset(-20);
			make.height.equalTo(searchButton);
			make.top.equalTo(searchButton);
			
		}];
		
		UIView * bottomLine = ({
			UIView * view = [UIView new];
			view.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
			view;
		});
		[self addSubview:bottomLine];
		[bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.right.bottom.equalTo(self);
			make.height.equalTo(@0.5);
		}];
		
		
		dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
		__block int i = 0;
		WeakSelf
		dispatch_source_set_event_handler(self.timer, ^{
			i ++ ;
			[weakSelf updateCloseLabelText];
			[weakSelf updateOpenLabelText];
			
		});
		dispatch_resume(self.timer);
	}
	return self;
}


- (void)dealloc
{
	dispatch_source_cancel(self.timer);
}
- (void) searchButtonTaped: (UIButton *) sender {
	if (self.searchBlock) {
		self.searchBlock(self.searchField.text);
	}
}
- (dispatch_source_t)timer {
	
	if (!_timer) {
		_timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
	}
	return _timer;
}
- (void)setNextIssueModel:(UGNextIssueModel *)nextIssueModel {
	_nextIssueModel = nextIssueModel;
	if (nextIssueModel == nil) {
		return;
	}
	self.preNumArray = [nextIssueModel.preNum componentsSeparatedByString:@","];
	if (nextIssueModel.preNumSx.length) {
		self.subPreNumArray = [nextIssueModel.preNumSx componentsSeparatedByString:@","];
	}
	
	if ([@"pcdd" isEqualToString:nextIssueModel.gameType]) {
		NSInteger total = 0;
		 for (NSString *num in self.preNumArray) {
			 total += num.integerValue;
		 }
		NSMutableArray * tempArray = self.preNumArray.mutableCopy;
		 [tempArray addObject:@"="];
		 [tempArray addObject:[NSString stringWithFormat:@"%ld",total]];
		self.preNumArray = tempArray;
	
	}
	

	
	self.currentIssueLabel.text = [NSString stringWithFormat:@"%@期",self.nextIssueModel.preIssue];
	self.nextIssueLabel.text = [NSString stringWithFormat:@"%@期",self.nextIssueModel.curIssue];
	[self updateCloseLabelText];
	[self updateOpenLabelText];
	
}

- (UILabel*)currentIssueLabel {
	if (!_currentIssueLabel) {
		_currentIssueLabel = [UILabel new];
		_currentIssueLabel.font = [UIFont systemFontOfSize:14];
		
	}
	return _currentIssueLabel;
}

- (UILabel*)nextIssueLabel {
	if (!_nextIssueLabel) {
		_nextIssueLabel = [UILabel new];
		_nextIssueLabel.font = [UIFont systemFontOfSize:14];
		
	}
	return _nextIssueLabel;
}
- (UILabel*)closeTimeLabel {
	if (!_closeTimeLabel) {
		_closeTimeLabel = [UILabel new];
		_closeTimeLabel.font = [UIFont systemFontOfSize:14];
		
	}
	return _closeTimeLabel;
}
- (UILabel*)openTimeLabel {
	if (!_openTimeLabel) {
		_openTimeLabel = [UILabel new];
		_openTimeLabel.font = [UIFont systemFontOfSize:14];
		
	}
	return _openTimeLabel;
}
- (UITextField *)searchField {
	
	if (!_searchField) {
		_searchField = [UITextField new];
		_searchField.placeholder = @"请输入关键字搜索资料";
		_searchField.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
		
	}
	return _searchField;
}

- (void)updateCloseLabelText{
	NSString *timeStr = [CMCommon getNowTimeWithEndTimeStr:self.nextIssueModel.curCloseTime currentTimeStr:self.nextIssueModel.serverTime];
	if (self.nextIssueModel.isSeal || timeStr == nil) {
		timeStr = @"封盘中";
	}
	self.closeTimeLabel.text = [NSString stringWithFormat:@"封盘：%@",timeStr];
	NSMutableAttributedString *abStr = [[NSMutableAttributedString alloc] initWithString:self.closeTimeLabel.text];
	[abStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(3, self.closeTimeLabel.text.length - 3)];
	self.closeTimeLabel.attributedText = abStr;
	
}

- (void)updateOpenLabelText {
	NSString *timeStr = [CMCommon getNowTimeWithEndTimeStr:self.nextIssueModel.curOpenTime currentTimeStr:self.nextIssueModel.serverTime];
	if (timeStr == nil) {
		timeStr = @"获取下一期";
		
	}else {
		
	}
	self.openTimeLabel.text = [NSString stringWithFormat:@"开奖：%@",timeStr];
	NSMutableAttributedString *abStr = [[NSMutableAttributedString alloc] initWithString:self.openTimeLabel.text];
	[abStr addAttribute:NSForegroundColorAttributeName value:UGNavColor range:NSMakeRange(3, self.openTimeLabel.text.length - 3)];
	self.openTimeLabel.attributedText = abStr;
}

- (UICollectionView *)collectionView {
	if (!_collectionView) {
		UICollectionViewFlowLayout *layout = ({
			layout = [[UICollectionViewFlowLayout alloc] init];
			layout.itemSize = CGSizeMake(24, 24);
			layout.minimumInteritemSpacing = 1;
			layout.minimumLineSpacing = 1;
			layout.scrollDirection = UICollectionViewScrollDirectionVertical;
			layout.headerReferenceSize = CGSizeMake(300, 3);
			layout;
			
		});
		
		_collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(120 , 5, UGScreenW - 120 , 100) collectionViewLayout:layout];
		_collectionView.backgroundColor = [UIColor clearColor];
		_collectionView.dataSource = self;
		_collectionView.delegate = self;
		[_collectionView registerNib:[UINib nibWithNibName:@"UGLotteryResultCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"UGLotteryResultCollectionViewCell"];
		[_collectionView registerNib:[UINib nibWithNibName:@"UGLotterySubResultCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"UGLotterySubResultCollectionViewCell"];
		[_collectionView registerNib:[UINib nibWithNibName:@"UGFastThreeOneCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:lotteryResultCellid];

		
	}
	return _collectionView;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	
	if ([@"bjkl8" isEqualToString:self.nextIssueModel.gameType]) {
		return 1;
	}
	return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	
	if ([@"lhc" isEqualToString:self.nextIssueModel.gameType]) {
		return self.preNumArray.count ? (self.preNumArray.count + 1) : 0;
		
	} else if ([@"pcdd" isEqualToString:self.nextIssueModel.gameType]) {
		if (section == 0) {
			   return self.preNumArray.count;
		   }
		   return self.subPreNumArray.count > 3 ? 3 : self.subPreNumArray.count;
	}
	else if (section == 0){
		return self.preNumArray.count;
	} else {
		return self.subPreNumArray.count;
	}
	
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	UGNextIssueModel * model = self.nextIssueModel;
	
	if ([@"lhc" isEqualToString:model.gameType]) {
		
		if (indexPath.section == 0) {
			
			UGLotteryResultCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UGLotteryResultCollectionViewCell" forIndexPath:indexPath];
			cell.showBorder = NO;
			if (indexPath.row == 6) {
				cell.showAdd = YES;
			}else {
				cell.showAdd = NO;
			}
			if (indexPath.row < 6) {
				cell.title = self.preNumArray[indexPath.row];
				cell.color = [CMCommon getHKLotteryNumColorString:self.preNumArray[indexPath.row]];
			}
			if (indexPath.row == 7) {
				cell.title = self.preNumArray[indexPath.row - 1];
				cell.color = [CMCommon getHKLotteryNumColorString:self.preNumArray[indexPath.row - 1]];
			}
			return cell;
		}else {
			UGLotterySubResultCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UGLotterySubResultCollectionViewCell" forIndexPath:indexPath];
			if (indexPath.row == 6) {
				cell.showAdd = YES;
			}else {
				cell.showAdd = NO;
			}
			if (indexPath.row < 6) {
				cell.title = self.subPreNumArray[indexPath.row];
			}
			if (indexPath.row == 7) {
				cell.title = self.subPreNumArray[indexPath.row - 1];
			}
			return cell;
		}
		
	} else if ( [@"jsk3" isEqualToString:self.nextIssueModel.gameType]) {
		if (indexPath.section == 0) {
				 
				 UGFastThreeOneCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:lotteryResultCellid forIndexPath:indexPath];
				 cell.num = self.preNumArray[indexPath.row];
				 return cell;
			 }else {
					 
				 UGLotterySubResultCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:lotterySubResultCellid forIndexPath:indexPath];
				 cell.title = self.subPreNumArray[indexPath.row];
				 return cell;
				
			 }
	} else if ([@"pcdd" isEqualToString:self.nextIssueModel.gameType]) {
		if (indexPath.section == 0) {
				  
				  UGLotteryResultCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UGLotteryResultCollectionViewCell" forIndexPath:indexPath];
				  cell.title = self.preNumArray[indexPath.row];
				  cell.showAdd = NO;
				  cell.showBorder = NO;
				  if (indexPath.row == 3) {
					  cell.showIsequal = YES;
					  cell.showAdd = YES;
				  }
				  return cell;
			  } else {
				  UGLotterySubResultCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UGLotterySubResultCollectionViewCell" forIndexPath:indexPath];
				  cell.title = self.subPreNumArray[indexPath.row];
				  return cell;
			  }
	} else {
		if (indexPath.section == 0) {
			
			UGLotteryResultCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UGLotteryResultCollectionViewCell" forIndexPath:indexPath];
			cell.title = self.preNumArray[indexPath.row];
			cell.showAdd = NO;
			cell.showBorder = NO;
			return cell;
		}else {
			UGLotterySubResultCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UGLotterySubResultCollectionViewCell" forIndexPath:indexPath];
			cell.title = self.subPreNumArray[indexPath.row];
			cell.titleColor = UGGreenColor;
			return cell;
		}
		
	}
	
	
	
}
@end



@implementation DocumentModel
+ (JSONKeyMapper *)keyMapper {
	
	return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"articleID"}];
}

@end

@implementation DocumentListModel

@end
@implementation DocumentCell

@end

@interface DocumentTypeList()<UICollectionViewDelegate, UICollectionViewDataSource>
//@property(nonatomic, strong)UICollectionView * collectionView;
@end

@implementation DocumentTypeList


static DocumentTypeList *_singleInstance = nil;

+ (instancetype)shareInstance
{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		if (_singleInstance == nil) {
			_singleInstance = [[self alloc] initWithFrame:CGRectZero];
		}
	});
	return _singleInstance;
}


+(void)showIn: (UIView *)supperView
completionHandle: (void(^)(GameModel * model)) block

{
	
	DocumentTypeList * list = [DocumentTypeList shareInstance];
	[list removeFromSuperview];
	[supperView addSubview:list];
	[list mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(supperView);
	}];
	list.completionHandle = block;
	
}

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		
		UICollectionViewFlowLayout *layout = ({
			layout = [[UICollectionViewFlowLayout alloc] init];
			layout.scrollDirection = UICollectionViewScrollDirectionVertical;
			layout.itemSize = CGSizeMake(UGScreenW /3, 50);

			layout.minimumLineSpacing = 0;
			layout.minimumInteritemSpacing = 0;
//			layout.estimatedItemSize = CGSizeMake(100, 50);
//			layout.itemSize = UICollectionViewFlowLayoutAutomaticSize;
			layout;
		});
		
		UICollectionView *collectionView = ({
			collectionView = [[UICollectionView alloc] initWithFrame: CGRectZero collectionViewLayout:layout];
			collectionView.backgroundColor = [UIColor whiteColor];
			collectionView.dataSource = self;
			collectionView.delegate = self;
			
			[collectionView registerClass: [DocumentTypeListCell class] forCellWithReuseIdentifier:@"DocumentTypeListCell"];
			
			[collectionView setShowsHorizontalScrollIndicator:NO];
			collectionView;
		});
		
		UIView * shadowView = [UIView new];
		shadowView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.9];
		[self addSubview:shadowView];
		[shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.edges.equalTo(self);
		}];
		
		[self addSubview:collectionView];
		[collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.right.top.equalTo(self);
			make.height.equalTo(@(((_allGames.count - 1)/3 + 1) * 50));
		}];
		
		
		
		[shadowView addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)]];
		
	}
	return self;
}

- (void) hide {
	[self removeFromSuperview];
}
static NSArray<GameModel *> * _allGames;

+ (void)setAllGames:(NSArray<GameModel *> *)allGames {
	_allGames = allGames;
}
+ (NSArray<GameModel *> *)allGames {
	return _allGames;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return _allGames.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	DocumentTypeListCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DocumentTypeListCell" forIndexPath:indexPath];
	cell.titleLabel.text = _allGames[indexPath.item].name;
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	
	if (self.completionHandle) {
		self.completionHandle(_allGames[indexPath.item]);
	}
	
	[self removeFromSuperview];
	
}
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//	return (CGSize){UGScreenW/3 - 10,80};
//}
//
//
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//	return UIEdgeInsetsMake(5, 5, 5, 5);
//}
//
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
//{
//	return 5.f;
//}
//
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//	return 5.f;
//}

@end
@interface DocumentTypeListCell()

@end
@implementation DocumentTypeListCell

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		self.titleLabel = [UILabel new];
		[self addSubview:self.titleLabel];
		[self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//			make.edges.equalTo(self).inset(25);
			make.left.right.equalTo(self).inset(5);
			make.top.bottom.equalTo(self).inset(5);
		}];
		self.titleLabel.layer.borderWidth = 0.5;
		self.titleLabel.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1.0].CGColor;
		self.titleLabel.layer.cornerRadius = 3;
		self.titleLabel.textAlignment = NSTextAlignmentCenter;
		self.titleLabel.font = [UIFont systemFontOfSize:12];
		self.titleLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
		self.backgroundColor = [UIColor whiteColor];
	}
	return self;
}

@end
