//
//  MailBoxTableViewController.m
//  UGBWApp
//
//  Created by ug on 2020/6/19.
//  Copyright © 2020 ug. All rights reserved.
//

#import "UGMailBoxTableViewController.h"
#import "UGMessageTableViewCell.h"
#import "QDAlertView.h"
#import "UGMessageModel.h"
#import "MJRefresh.h"
#import "MessageUnderMenuView.h"
#import "UGMessagePopView.h"
@interface UGMailBoxTableViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *iphoneXBottomView;/**<iphoneX的t底部*/

@property (nonatomic, strong) NSMutableArray <UGMessageModel *> *dataArray;
@property(nonatomic, assign) int pageSize;
@property(nonatomic, assign) int pageNumber;
@property (nonatomic, weak)IBOutlet UITableView *tableView;   /**<   列表TableView */
@property (nonatomic, strong)MessageUnderMenuView *underMenu; /**<   下边栏 */
@property (nonatomic, strong)UGMessagePopView *popView;       /**<   弹窗 */
@end

//分页初始值
static int page = 1;
static int size = 20;
static NSString *messageCellid = @"UGMessageTableViewCell";
@implementation UGMailBoxTableViewController

- (BOOL)允许游客访问 { return true; }

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.popView = [[UGMessagePopView alloc] initWithFrame:CGRectMake(20, k_Height_NavBar +50, UGScreenW - 40, UGScerrnH - APP.StatusBarHeight - APP.BottomSafeHeight - 200)];
    
    if (!self.title) {
          self.title = @"站内信";
      }
      self.pageSize = size;
      self.pageNumber = page;
      self.view.backgroundColor = Skin1.textColor4;
    
    [self tableViewInit];
    [self.view addSubview:self.tableView];
    [self setupRefreshView];
    [self loadMessageList];
    
    
    
    self.underMenu = [[MessageUnderMenuView alloc] initView];
    [self.view addSubview:self.underMenu];
    
    
    [self.underMenu  mas_remakeConstraints:^(MASConstraintMaker *make) {
         make.left.equalTo(self.view.mas_left).with.offset(0);
         make.right.equalTo(self.view.mas_right).with.offset(0);
         make.top.equalTo(self.iphoneXBottomView.mas_top).offset(-36);
//         make.top.equalTo(self.view.mas_bottom).offset(-36);
         make.height.mas_equalTo(96);
         
     }];

    
      
    WeakSelf
    __block BOOL isok = YES;
    [self.underMenu.showBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
        if (OBJOnceToken(weakSelf)) {
            weakSelf.underMenu.oldFrame = weakSelf.underMenu.frame;
        }
        if (isok) {
            [UIView animateWithDuration:0.35 animations:^{
                weakSelf.underMenu.y = weakSelf.underMenu.oldFrame.origin.y -(96-36);
                weakSelf.underMenu.arrowImg.transform = CGAffineTransformMakeRotation(M_PI*2);//旋转
            } completion:^(BOOL finished) {
                isok = NO;
            }];
        } else {
            [UIView animateWithDuration:0.35 animations:^{
                weakSelf.underMenu.y =  weakSelf.underMenu.oldFrame.origin.y;
                weakSelf.underMenu.arrowImg.transform = CGAffineTransformMakeRotation(M_PI*1);//旋转
            } completion:^(BOOL finished) {
                isok = YES;
            }];
        }
    }];
    self.underMenu.delclickBllock = ^{
        weakSelf.pageNumber = 1;
        [weakSelf loadMessageList];
    };
    self.underMenu.readedclickBllock = ^{
        weakSelf.pageNumber = 1;
        [weakSelf loadMessageList];
    };
    
    
    [self.iphoneXBottomView setBackgroundColor:Skin1.bgColor];
    [self.view bringSubviewToFront:self.iphoneXBottomView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"111");
}


- (UITableView *)tableViewInit {

        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"UGMessageTableViewCell" bundle:nil] forCellReuseIdentifier:messageCellid];
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.rowHeight = 40;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
        _tableView.badgeBgColor = [UIColor clearColor];
        _tableView.separatorColor = Skin1.isBlack ? [UIColor lightTextColor] : APP.LineColor;
     
    return _tableView;
}
//添加上下拉刷新
- (void)setupRefreshView
{
    WeakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pageNumber = 1;
        [weakSelf loadMessageList];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMessageList];
    }];
    self.tableView.mj_footer.hidden = YES;
    
}

- (void)loadMessageList {
    if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
        return;
    }
    NSDictionary *params = @{@"page":@(self.pageNumber),
                             @"rows":@(self.pageSize),
                             @"token":[UGUserModel currentUser].sessid,
                             @"type":@""
    };
    WeakSelf;
    [CMNetwork getMessageListWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
            UGMessageListModel *message = model.data;
            NSArray *array = message.list;
            if (weakSelf.pageNumber == 1 ) {
                
                [weakSelf.dataArray removeAllObjects];
            }
            
            [weakSelf.dataArray addObjectsFromArray:array];
            [weakSelf.tableView reloadData];
            if (array.count < weakSelf.pageSize) {
                [weakSelf.tableView.mj_footer setState:MJRefreshStateNoMoreData];
                [weakSelf.tableView.mj_footer setHidden:YES];
            }else{
                weakSelf.pageNumber ++;
                [weakSelf.tableView.mj_footer setState:MJRefreshStateIdle];
                [weakSelf.tableView.mj_footer setHidden:NO];
            }
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
        
        if ([weakSelf.tableView.mj_header isRefreshing]) {
            [weakSelf.tableView.mj_header endRefreshing];
        }
        
        if ([weakSelf.tableView.mj_footer isRefreshing]) {
            [weakSelf.tableView.mj_footer endRefreshing];
        }
    }];
    
}

- (void)modifyMessageState:(UGMessageModel *)item {
    if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
        return;
    }
    NSDictionary *params = @{@"id":item.messageId,
                             @"token":[UGUserModel currentUser].sessid,
    };
    WeakSelf;
    [CMNetwork modifyMessageStateWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            item.isRead = YES;
            [weakSelf.tableView reloadData];
            SANotificationEventPost(UGNotificationGetUserInfo, nil);
        } failure:^(id msg) {
            [SVProgressHUD dismiss];
        }];
    }];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UGMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:messageCellid forIndexPath:indexPath];
    cell.item = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UGMessageModel *model = self.dataArray[indexPath.row];

    

    UGMessagePopView *popView = [[UGMessagePopView alloc] initWithFrame:CGRectMake(0, 0, 350, 260)];
    popView.closeBlock = ^{
        [LEEAlert closeWithCompletionBlock:nil];
    };
    WeakSelf;
    [LEEAlert alert].config
    .LeeTitle(model.title)
    .LeeAddCustomView(^(LEECustomView *custom) {

        popView.content = model.content;
        custom.view = popView;
        custom.positionType = LEECustomViewPositionTypeCenter;
    })
    .LeeAction(@"确定", ^{
        [weakSelf readMsg:model.messageId];
    })
    .LeeShow();
    
//    __weakSelf_(__self);
//    if (Skin1.isBlack) {
//        [LEEAlert alert].config
//        .LeeAddTitle(^(UILabel *label) {
//            label.text = model.title;
//            label.textColor = [UIColor whiteColor];
//        })
//        .LeeAddContent(^(UILabel *label) {
//
//            NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] initWithData:[model.content dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
//            NSMutableParagraphStyle *ps = [NSMutableParagraphStyle new];
//            ps.lineSpacing = 5;
//            [mas addAttributes:@{NSParagraphStyleAttributeName:ps,} range:NSMakeRange(0, mas.length)];
//
//            // 替换文字颜色
//            NSAttributedString *as = [mas copy];
//            for (int i=0; i<as.length; i++) {
//                NSRange r = NSMakeRange(0, as.length);
//                NSMutableDictionary *dict = [as attributesAtIndex:i effectiveRange:&r].mutableCopy;
//                UIColor *c = dict[NSForegroundColorAttributeName];
//                if (fabs(c.red - c.green) < 0.05 && fabs(c.green - c.blue) < 0.05) {
//                    dict[NSForegroundColorAttributeName] = Skin1.textColor2;
//                    [mas addAttributes:dict range:NSMakeRange(i, 1)];
//                }
//            }
//
//            dispatch_async(dispatch_get_main_queue(), ^{
//                label.attributedText = mas;
//            });
//
//        })
//        .LeeHeaderColor(Skin1.bgColor)
//        .LeeAction(@"确定", ^{//站内信已读
//            [__self readMsg:model.messageId];
//        })
//        .LeeShow(); // 设置完成后 别忘记调用Show来显示
//    }
//    else {
//        [LEEAlert alert].config
//        .LeeTitle(model.title)
//        .LeeAddContent(^(UILabel *label) {
//
//            label.attributedText = [[NSAttributedString alloc] initWithData:[model.content dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
//        })
//        .LeeAction(@"确定", ^{//站内信已读
//
//            [__self readMsg:model.messageId];
//        })
//        .LeeShow(); // 设置完成后 别忘记调用Show来显示
//    }
//
    
    
    if (model.isRead == 0) {
        
        [self modifyMessageState:model];
    }
    
}

-(void)readMsg:(NSString *)messageId{
    
    NSDictionary *params = @{@"id":messageId,
                             @"token":[UGUserModel currentUser].sessid,
    };
    [CMNetwork modifyMessageStateWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
        } failure:^(id msg) {}];
    }];
}

- (NSMutableArray<UGMessageModel *> *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
        
    }
    
    return _dataArray;
}

@end
