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


@interface UGDocumentVC ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong)GameModel * model;


@property(nonatomic, strong) UITableView * tableView;

@property(nonatomic, strong) NSArray<DocumentModel*> * documentListData;

@property(nonatomic, strong) UGNextIssueModel * nextIssue;

@property (nonatomic, strong) dispatch_group_t completionGroup;

@end

@implementation UGDocumentVC

- (instancetype)initWithModel: (GameModel *)model
{
	self = [super init];
	if (self) {
		self.model = model;
	}
	return self;
}


- (void)viewDidLoad {
	[super viewDidLoad];
	
	[self.view addSubview:self.tableView];
	[self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.view);
	}];
	
	[self requestData];
	
}

- (void)requestData {
	
	dispatch_group_enter(self.completionGroup);
	NSMutableDictionary *params = @{@"id": self.model.type}.mutableCopy;
	WeakSelf
	
	
	dispatch_group_enter(self.completionGroup);
	[CMNetwork getNextIssueWithParams:params completion:^(CMResult<id> *model, NSError *err) {
		[CMResult processWithResult:model success:^{
			weakSelf.nextIssue = model.data;
			dispatch_group_leave(weakSelf.completionGroup);
			
		} failure:^(id msg) {
			dispatch_group_leave(weakSelf.completionGroup);
			
		}];
	}];
	params[@"category"] = self.model.gameId;
	[CMNetwork getDocumnetListWithParams:params completion:^(CMResult<id> *model, NSError *err) {
		[CMResult processWithResult:model success:^{
			
			DocumentListModel * data = model.data;
			weakSelf.documentListData = data.list;
			dispatch_group_leave(weakSelf.completionGroup);
		} failure:^(id msg) {
			dispatch_group_leave(weakSelf.completionGroup);
			
		}];
	}];
	
	dispatch_group_notify(self.completionGroup, dispatch_get_main_queue(), ^{
		[weakSelf.tableView.mj_header endRefreshing];
		[weakSelf.tableView reloadData];
		weakSelf.navigationItem.title = weakSelf.nextIssue.title;
	});
	
}





- (UITableView *)tableView {
	
	if (!_tableView) {
		
		_tableView = [[UITableView alloc] initWithFrame:CGRectZero style: UITableViewStylePlain];
		_tableView.delegate = self;
		_tableView.dataSource = self;
		_tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
			[self requestData];
		}];
		[_tableView registerClass:[DocumentCell class] forCellReuseIdentifier:@"DocumentCell"];
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
				UGDocumentDetailVC *vc = [UGDocumentDetailVC new];
				vc.model = documentDetailModel;
				[self presentViewController:vc animated:true completion:nil];
			} else if (user.isTest){
				
				
				UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"该贴需要正式会员才能阅读，请登录后查看" preferredStyle:UIAlertControllerStyleAlert];
				[alert addAction:[UIAlertAction actionWithTitle:@"确认" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
					
				}]];
				[self presentViewController:alert animated:true completion:nil];
				
				
			} else if (!documentDetailModel.hasPay) {
				UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"该贴需要付费阅读，打赏后查看" preferredStyle:UIAlertControllerStyleAlert];
				[SVProgressHUD showWithStatus:nil];
				[alert addAction:[UIAlertAction actionWithTitle:@"确认" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
					
					[CMNetwork getDocumnetPayWithParams:@{@"id": document.articleID, @"token": token} completion:^(CMResult<id> *model, NSError *err) {
						[SVProgressHUD showInfoWithStatus:model.msg];
					}];
					
				}]];
				[alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
				[self presentViewController:alert animated:true completion:nil];
			}
			
		}];
	}];
	
	
	
	
}



@end



/// 六合彩开奖信息
@interface LHCIssueView ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (strong, nonatomic) UILabel *currentIssueLabel;
@property (strong, nonatomic) UILabel *nextIssueLabel;
@property (strong, nonatomic) UILabel *closeTimeLabel;
@property (strong, nonatomic) UILabel *openTimeLabel;
@property (strong, nonatomic) UIView *nextIssueView;
@property (nonatomic, strong) NSArray *preNumArray;
@property (nonatomic, strong) NSArray *subPreNumArray;

@end

@implementation LHCIssueView

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		
		[self addSubview: self.collectionView];
		[self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.edges.equalTo(self);
		}];
		
	}
	return self;
}


- (void)setNextIssueModel:(UGNextIssueModel *)nextIssueModel {
	_nextIssueModel = nextIssueModel;
	self.preNumArray = [nextIssueModel.preNum componentsSeparatedByString:@","];
	if (nextIssueModel.preNumSx.length) {
		self.subPreNumArray = [nextIssueModel.preNumSx componentsSeparatedByString:@","];
	}
	//    self.navigationItem.title = nextIssueModel.title;
}

- (void)updateHeaderViewData {
	self.currentIssueLabel.text = [NSString stringWithFormat:@"%@期",self.nextIssueModel.preIssue];
	self.nextIssueLabel.text = [NSString stringWithFormat:@"%@期",self.nextIssueModel.curIssue];
	[self updateCloseLabelText];
	[self updateOpenLabelText];
	CGSize size = [self.nextIssueModel.preIssue sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
	
	self.collectionView.x = 30 + size.width;
	[self.collectionView reloadData];
}

- (void)updateCloseLabelText{
	NSString *timeStr = [CMCommon getNowTimeWithEndTimeStr:self.nextIssueModel.curCloseTime currentTimeStr:self.nextIssueModel.serverTime];
	if (timeStr == nil) {
		timeStr = @"封盘中";
	}
	self.closeTimeLabel.text = [NSString stringWithFormat:@"封盘：%@",timeStr];
	[self updateCloseLabel];
	
}

- (void)updateOpenLabelText {
	NSString *timeStr = [CMCommon getNowTimeWithEndTimeStr:self.nextIssueModel.curOpenTime currentTimeStr:self.nextIssueModel.serverTime];
	if (timeStr == nil) {
		timeStr = @"获取下一期";
		
	}else {
		
	}
	self.openTimeLabel.text = [NSString stringWithFormat:@"开奖：%@",timeStr];
	[self updateOpenLabel];
	
}

- (void)updateCloseLabel {
	NSMutableAttributedString *abStr = [[NSMutableAttributedString alloc] initWithString:self.closeTimeLabel.text];
	[abStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(3, self.closeTimeLabel.text.length - 3)];
	self.closeTimeLabel.attributedText = abStr;
	
}

- (void)updateOpenLabel {
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
		[_collectionView registerNib:[UINib nibWithNibName:@"UGTimeLotteryBetHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerCollectionViewCe"];
		
	}
	return _collectionView;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	
	return self.preNumArray.count ? (self.preNumArray.count + 1) : 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
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
}
@end

/// 重庆时时彩开奖信息
@interface CQSSCIssueView ()

@end
@implementation CQSSCIssueView



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
