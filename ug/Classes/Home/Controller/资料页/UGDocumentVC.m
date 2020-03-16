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
#import "IssueView.h"
#import "DocumentTypeList.h"




@implementation DocumentModel
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"articleID"}];
}
@end
@implementation DocumentListModel
@end






@interface UGDocumentVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) IssueView *issueView;
@property (nonatomic, strong) UIButton *titleButton;

@property (nonatomic, strong) GameModel *model;

@property (nonatomic, strong) NSMutableArray<DocumentModel*> *documentListData;

@property (nonatomic, strong) UGNextIssueModel *nextIssue;

@property (nonatomic, strong) dispatch_group_t completionGroup;

@end

@implementation UGDocumentVC

- (instancetype)initWithModel: (GameModel *)model {
	self = [super init];
	if (self) {
		_model = model;
	}
	return self;
}

- (void)setModel:(GameModel *)model {
	_model = model;
    [_titleButton setTitle:self.model.name forState:UIControlStateNormal];
    if (DocumentTypeList.allGames.count) {
        [_titleButton setTitle:[NSString stringWithFormat:@"%@ ▼", self.model.name] forState:UIControlStateNormal];
        [_titleButton addTarget:self action:@selector(titleButtonTaped:)];
    }
}

- (BOOL)允许游客访问 { return true; }

- (void)viewDidLoad {
	[super viewDidLoad];
    _documentListData = @[].mutableCopy;
    
    
	[self.view addSubview:self.tableView];
	[self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-APP.BottomSafeHeight);
	}];
    
    if (Skin1.isBlack) {
        self.view.backgroundColor = Skin1.bgColor;
        [_tableView setBackgroundColor:Skin1.bgColor];

    } else {
        self.view.backgroundColor = [UIColor whiteColor];
        [_tableView setBackgroundColor:[UIColor whiteColor]];

    }
	
	[self requestData:@"" page:1];
	
	_titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
	_titleButton.frame = CGRectMake(0, 0, 200, 40);
	[_titleButton setTitle:self.model.name forState:UIControlStateNormal];
    if (DocumentTypeList.allGames.count) {
        [_titleButton setTitle:[NSString stringWithFormat:@"%@ ▼", self.model.name] forState:UIControlStateNormal];
        [_titleButton addTarget:self action:@selector(titleButtonTaped:)];
    }
	
	self.navigationItem.titleView = _titleButton;
}

- (void)titleButtonTaped: (UIButton *)sender {
    if (DocumentTypeList.allGames.count && ![DocumentTypeList isShow:self.view]) {
        __weakSelf_(__self);
        [DocumentTypeList showIn:self.view completionHandle:^(GameModel * _Nonnull model) {
            __self.model = model;
            [SVProgressHUD showWithStatus:nil];
            //        [sender setTitle:[NSString stringWithFormat:@"%@ ▼", self.model.name] forState:UIControlStateNormal];
            [__self requestData:@"" page:1];
        }];
    } else {
        [DocumentTypeList hide];
    }
}

- (void)requestData:(NSString *)title page:(NSInteger)page {
	NSMutableDictionary *params = @{@"id": self.model.type}.mutableCopy;
    
    __weakSelf_(__self);
	if ([title isEqualToString:@""]) {
		[CMNetwork getNextIssueWithParams:params completion:^(CMResult<id> *model, NSError *err) {
			[CMResult processWithResult:model success:^{
				__self.nextIssue = model.data;
                [SVProgressHUD dismiss];
                [__self.tableView.mj_header endRefreshing];
                [__self.tableView reloadData];
			} failure:nil];
		}];
	}
	
	params[@"category"] = self.model.gameId;
	params[@"title"] = title;
    params[@"rows"] = _NSString(@"%ld", APP.PageCount);
    params[@"page"] = _NSString(@"%ld", page);
	[CMNetwork getDocumnetListWithParams:params completion:^(CMResult<id> *model, NSError *err) {
		[CMResult processWithResult:model success:^{
			
			DocumentListModel *data = model.data;
            if (page == 1) {
                [__self.documentListData removeAllObjects];
            }
			[__self.documentListData addObjectsFromArray:data.list];
			
			if (data.list.count < 20) {
                [__self.tableView.mj_footer endRefreshingWithNoMoreData];
			} else {
				__self.tableView.mj_footer.state = MJRefreshStateIdle;
			}
            [SVProgressHUD dismiss];
            [__self.tableView.mj_header endRefreshing];
            [__self.tableView reloadData];
		} failure:nil];
	}];
}

- (UITableView *)tableView {
	
	if (!_tableView) {
		_tableView = [[UITableView alloc] initWithFrame:CGRectZero style: UITableViewStylePlain];
		_tableView.delegate = self;
		_tableView.dataSource = self;
        __weakSelf_(__self);
		_tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
			[__self requestData:@"" page:1];
		}];
		_tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
			[__self requestData:@"" page:__self.documentListData.count/20 + 1];
		}];
		[_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"DocumentCell"];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP.Width, 10)];
		[_tableView.mj_footer setState:MJRefreshStateNoMoreData];
	}
	return _tableView;
}

- (dispatch_group_t)completionGroup {
	if (!_completionGroup) {
		_completionGroup = dispatch_group_create();
	}
	return _completionGroup;
}


#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.documentListData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DocumentCell"];
	cell.textLabel.text = self.documentListData[indexPath.row].title;
	cell.textLabel.font = [UIFont systemFontOfSize:15];
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	UILabel *accessLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 22, 20)];
	accessLabel.text = @">>";
	accessLabel.font = [UIFont systemFontOfSize:14];
	accessLabel.textColor = [UIColor blueColor];
	cell.accessoryView = accessLabel;
    
    if (Skin1.isBlack) {
        [cell setBackgroundColor:Skin1.bgColor];
        cell.textLabel.textColor = [UIColor whiteColor];
    } else {
        [cell setBackgroundColor:[UIColor whiteColor]];
        cell.textLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    }
    
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
            
            NSLog(@"返回结果：");
			UGDocumentDetailData * documentDetailModel = model.data;
            UIColor *blueColor = [UIColor colorWithRed:90/255.0f green:154/255.0f blue:239/255.0f alpha:1.0f];
			if (documentDetailModel.canRead) {
//				UGDocumentDetailVC *vc = [UGDocumentDetailVC new];
//				vc.model = documentDetailModel;
//				[self presentViewController:vc animated:true completion:nil];
				[UGDocumentView showWith:documentDetailModel];
			} else if (user.isTest){
                if (Skin1.isBlack) {
                   [LEEAlert alert].config
                   .LeeAddTitle(^(UILabel *label) {
                       label.text = @"温馨提示";
                       label.textColor = [UIColor whiteColor];
                   })
                   .LeeAddContent(^(UILabel *label) {
                       label.text = @"该资料需要正式会员才能阅读，请登录后查看";
                       label.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.75f];
                   })
                   .LeeAddAction(^(LEEAction *action) {
                       action.type = LEEActionTypeDefault;
                       action.title = @"确认";
                       action.titleColor = blueColor;
                       action.backgroundColor = Skin1.bgColor;
                       action.clickBlock = ^{
                           // 点击事件Block
                       };
                   })
                   .LeeHeaderColor(Skin1.bgColor)
                   .LeeShow();
                } else {
                    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"该资料需要正式会员才能阅读，请登录后查看" preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"确认" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                    }]];
                    [self presentViewController:alert animated:true completion:nil];
                }
				
			} else if (!documentDetailModel.hasPay) {

                if (Skin1.isBlack) {
                    [LEEAlert alert].config
                    .LeeAddTitle(^(UILabel *label) {
                        label.text = @"温馨提示";
                        label.textColor = [UIColor whiteColor];
                    })
                    .LeeAddContent(^(UILabel *label) {
                        label.text = @"注意：您没有浏览权限。\n打赏后本期无限浏览此资料。";
                        label.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.75f];
                    })
                    .LeeAddAction(^(LEEAction *action) {
                          action.type = LEEActionTypeCancel;
                          action.title = @"取消";
                          action.titleColor = blueColor;
                          action.backgroundColor = Skin1.bgColor;
                          action.clickBlock = ^{
                              // 取消点击事件Block
                          };
                      })
                    .LeeAddAction(^(LEEAction *action) {
                        action.type = LEEActionTypeDefault;
                        action.title = [NSString stringWithFormat:@"打赏%.2f元", documentDetailModel.amount];
                        action.titleColor = blueColor;
                        action.backgroundColor = Skin1.bgColor;
                        action.clickBlock = ^{
                            // 点击事件Block
                            [LEEAlert alert].config
                            .LeeAddTitle(^(UILabel *label) {
                                label.text = [NSString stringWithFormat:@"确认打赏%.2f元",documentDetailModel.amount] ;
                                label.textColor = [UIColor whiteColor];
                            })
                            .LeeAddContent(^(UILabel *label) {
                                label.text = @"";
                                label.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.75f];
                            })
                            .LeeAddAction(^(LEEAction *action) {
                                  action.type = LEEActionTypeCancel;
                                  action.title = @"取消";
                                  action.titleColor = blueColor;
                                  action.backgroundColor = Skin1.bgColor;
                                  action.clickBlock = ^{
                                      // 取消点击事件Block
                                  };
                              })
                            .LeeAddAction(^(LEEAction *action) {
                                action.type = LEEActionTypeDefault;
                                action.title = @"确认";
                                action.titleColor = blueColor;
                                action.backgroundColor = Skin1.bgColor;
                                action.clickBlock = ^{
                                    // 点击事件Block
                                    [SVProgressHUD showWithStatus:nil];
                                    [CMNetwork getDocumnetPayWithParams:@{@"id": document.articleID, @"token": token} completion:^(CMResult<id> *model, NSError *err) {
                                        [SVProgressHUD showInfoWithStatus:model.msg];
                                    }];
                                };
                            })
                            .LeeHeaderColor(Skin1.bgColor)
                            .LeeShow();
                        };
                    })
                    .LeeHeaderColor(Skin1.bgColor)
                    .LeeShow();
                } else {
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
	issueView.searchBlock = ^(NSString *text) {
		[SVProgressHUD showWithStatus:nil];
		[weakSelf requestData:text page:1];
	};
	return issueView;
}

- (IssueView *)issueView {
	if (!_issueView) {
		_issueView = [[IssueView alloc] init];
		_issueView.nextIssueModel = self.nextIssue;
		WeakSelf
		_issueView.searchBlock = ^(NSString * text) {
			[SVProgressHUD showWithStatus:nil];
			[weakSelf requestData:text page:1];
		};
	}
	return _issueView;
}

@end
