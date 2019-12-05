//
//  UGLotteryAssistantController.m
//  ug
//
//  Created by ug on 2019/5/11.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGLotteryAssistantController.h"
#import "UGChangLongController.h"

#import "UGLotteryAssistantTableViewCell.h"

#import "UGChanglongaideModel.h"

#import "CountDown.h"

@interface UGLotteryAssistantController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UITextField *amountLabel;
@property (weak, nonatomic) IBOutlet UIButton *betButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *betButtonBottomConstraint;
@property (weak, nonatomic) IBOutlet UIView *betDetailView;
@property (weak, nonatomic) IBOutlet UILabel *betDetailLabel;

@property (nonatomic, strong) CountDown *countDown;
@property (nonatomic, strong) CountDown *dataCountDown;

@property (nonatomic, strong) UGChanglongaideModel *selAideModel;
@property (nonatomic, strong) UGBetItemModel *selBetItem;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSMutableArray<UGChanglongaideModel *> *dataArray;

@property (nonatomic, assign)BOOL isHaveDian;

@end

static NSString *lotteryAssistantCellid = @"UGLotteryAssistantTableViewCell";
@implementation UGLotteryAssistantController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = Skin1.textColor4;
    self.navigationItem.title = @"长龙助手";
    
    self.betDetailView.layer.cornerRadius = 5;
    self.betDetailView.layer.masksToBounds = YES;
    self.betDetailView.hidden = YES;
    self.amountLabel.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.rowHeight = 90;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);
    [self updateSelectLabelWithCount:0];
    self.countDown = [[CountDown alloc] init];
    self.dataCountDown = [[CountDown alloc] init];
    WeakSelf
    [self.countDown countDownWithPER_SECBlock:^{
        [weakSelf updateTimeInVisibleCells];
    }];
    
    
    [self getChanglong];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getChanglong];
    }];
    SANotificationEventSubscribe(UGNotificationGetChanglongBetRecrod, self, ^(typeof (self) self, id obj) {
        [weakSelf.amountLabel resignFirstResponder];
    });
    
    
    
    __weakSelf_(__self);
    // 键盘弹起隐藏事件
    {
        [IQKeyboardManager.sharedManager.disabledDistanceHandlingClasses addObject:[self class]];
        [self xw_addNotificationForName:UIKeyboardWillShowNotification block:^(NSNotification * _Nonnull noti) {
            CGFloat h = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
            if ([NavController1.viewControllers.firstObject isKindOfClass:[UGChangLongController class]]) {
                h -= APP.Height - TabBarController1.tabBar.y;
            }
            __self.bottomView.cc_constraints.bottom.constant = h;
            __self.betButtonBottomConstraint.constant = 0;
            [__self.view layoutIfNeeded];
        }];
        
        [self xw_addNotificationForName:UIKeyboardWillHideNotification block:^(NSNotification * _Nonnull noti) {
            __self.bottomView.cc_constraints.bottom.constant = 0;
            __self.betButtonBottomConstraint.constant = [NavController1.viewControllers.firstObject isKindOfClass:[UGChangLongController class]] ? 0 : APP.BottomSafeHeight;
        }];
    }
    
    // 适配iPhoneX
    _betButtonBottomConstraint.constant = [NavController1.viewControllers.firstObject isKindOfClass:[UGChangLongController class]] ? 0 : APP.BottomSafeHeight;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(getChanglong) userInfo:nil repeats:true];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)getChanglong {
    __weakSelf_(__self);
    [CMNetwork getChanglongWithParams:@{@"id":@"60"} completion:^(CMResult<id> *model, NSError *err) {
        [self.tableView.mj_header endRefreshing];
        [CMResult processWithResult:model success:^{
            if (model.data) {
                __self.dataArray = model.data;
                [__self.tableView reloadData];
            }
        } failure:^(id msg) {
            [SVProgressHUD dismiss];
        }];
    }];
}

- (void)updateTimeInVisibleCells {
    NSArray  *cells = self.tableView.visibleCells; //取出屏幕可见ceLl
    for (UGLotteryAssistantTableViewCell *cell in cells) {
        UGChanglongaideModel *model = self.dataArray[cell.tag];
        cell.item = model;
        
    }
}

- (IBAction)clearClick:(id)sender {
    for (UGChanglongaideModel *aideModel in self.dataArray) {
        for (UGBetItemModel *bet in aideModel.betList) {
            bet.select = NO;
        }
    }
    
    [self.tableView reloadData];
    [self updateSelectLabelWithCount:0];
    self.amountLabel.text = nil;
    self.betDetailView.hidden = YES;
    
}
- (IBAction)betClick:(id)sender {
    NSInteger count = 0;
    for (UGChanglongaideModel *aideModel in self.dataArray) {
        for (UGBetItemModel *bet in aideModel.betList) {
            if (bet.select) {
                count += 1;
                break;
            }
        }
    }
    if (!count) {
        [SVProgressHUD showInfoWithStatus:@"请选择您的注单"];
        return;
    }
    if (!self.amountLabel.text.length) {
        [SVProgressHUD showInfoWithStatus:@"请输入投注金额"];
        return;
    }
    NSString *amount = @"";
    // 判断是否有小数点
    if ([self.amountLabel.text containsString:@"."]) {
        NSArray *amountArray = [self.amountLabel.text componentsSeparatedByString:@"."];
        NSString *a1 = [amountArray objectAtIndex:0];
        NSString *a2 = [amountArray objectAtIndex:1];
        if (a2.length==1) {
            amount = [NSString stringWithFormat:@"%@.%@0",a1,a2];
        } else if(a2.length==2){
            amount = self.amountLabel.text ;
        }
        else {
            [self.navigationController.view makeToast:@"金额格式有误"
                                             duration:1.5
                                             position:CSToastPositionCenter];
            return ;
        }
        
        
    } else {
        amount =[NSString stringWithFormat:@"%@.00",self.amountLabel.text];
    }
    
    
    if ([CMCommon arryIsNull:self.dataArray]) {
        [self.navigationController.view makeToast:@"请输入投注金额"
                                         duration:1.5
                                         position:CSToastPositionCenter];
        return ;
    }
    [self.amountLabel resignFirstResponder];
    UGChanglongaideModel *betModel;
    UGBetItemModel *betItem;
    for (UGChanglongaideModel *aideModel in self.dataArray) {
        for (UGBetItemModel *bet in aideModel.betList) {
            if (bet.select) {
                //                bet.select = NO;
                betItem = bet;
                betModel = aideModel;
            }
        }
    }
    if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
        return;
    }
    
    NSDictionary *dict = @{
        @"token":[UGUserModel currentUser].sessid,
        @"gameId":betModel.gameId,
        @"betIssue":betModel.issue,
        @"totalNum":@"1",
        @"totalMoney":amount,
        @"endTime":[betModel.closeTime timeStrToTimeInterval],
        @"tag":@"1"
    };
    
    NSMutableDictionary *mutDict = [[NSMutableDictionary alloc] initWithDictionary:dict];
    NSString *playId = @"betBean[0][playId]";
    NSString *money = @"betBean[0][money]";
    NSString *odds = @"betBean[0][betInfo]";
    NSString *rebate = @"betBean[0][playIds]";
    
    [mutDict setValue:betItem.playId forKey:playId];
    [mutDict setValue:amount forKey:money];
    [mutDict setObject:@"" forKey:odds];
    [mutDict setObject:@"" forKey:rebate];
    
    __weakSelf_(__self);
    [SVProgressHUD showWithStatus:nil];
    [CMNetwork userBetWithParams:mutDict completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            [SVProgressHUD showSuccessWithStatus:model.msg];
            SANotificationEventPost(UGNotificationGetUserInfo, nil);
            betItem.select = NO;
            __self.selBetItem = nil;
            [__self.tableView reloadData];
            [__self clearClick:nil];
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }];
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UGLotteryAssistantTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lotteryAssistantCellid forIndexPath:indexPath];
    UGChanglongaideModel *model = self.dataArray[indexPath.row];
    cell.item = model;
    cell.tag = indexPath.row;
    WeakSelf
    cell.betItemSelectBlock = ^(NSInteger index) {
        UGBetItemModel *item = model.betList[index];
        item.select = !item.select;
        
        for (UGChanglongaideModel *aideModel in weakSelf.dataArray) {
            for (UGBetItemModel *bet in aideModel.betList) {
                if (bet != item) {
                    bet.select = NO;
                    
                }
            }
        }
        
        [weakSelf.tableView reloadData];
        if (item.select) {
            weakSelf.selAideModel = model;
            weakSelf.selBetItem = item;
            [weakSelf updateSelectLabelWithCount:1];
            if (!weakSelf.amountLabel.text.length) {
                return ;
            }
            weakSelf.betDetailView.hidden = NO;
            float total = weakSelf.amountLabel.text.floatValue * item.odds.floatValue;
            weakSelf.betDetailLabel.text = [NSString stringWithFormat:@"%@，%@，%@ 奖金:%.4f",weakSelf.selAideModel.title,weakSelf.selAideModel.playCateName,weakSelf.selBetItem.playName,total];
            [weakSelf updateBetDetailLabelTextColor];
            
        } else {
            weakSelf.betDetailView.hidden = YES;
            weakSelf.selAideModel = nil;
            [weakSelf updateSelectLabelWithCount:0];
        }
        
    };
    return cell;
}

- (void)updateSelectLabelWithCount:(NSInteger )count {
    self.countLabel.text = [NSString stringWithFormat:@"共 %ld 注",count];
    NSMutableAttributedString *abstr = [[NSMutableAttributedString alloc] initWithString:self.countLabel.text];
    [abstr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(2, self.countLabel.text.length - 4)];
    self.countLabel.attributedText = abstr;
    
}

- (void)updateBetDetailLabelTextColor {
    NSMutableAttributedString *abstr = [[NSMutableAttributedString alloc] initWithString:self.betDetailLabel.text];
    [abstr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(self.selAideModel.title.length + self.selAideModel.playCateName.length + self.selBetItem.playName.length + 3, self.betDetailLabel.text.length - self.selAideModel.title.length - self.selAideModel.playCateName.length - self.selBetItem.playName.length - 3)];
    self.betDetailLabel.attributedText = abstr;
}

#pragma mark - textfield delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [self.amountLabel resignFirstResponder];
        return NO;
    }
    if (!self.selBetItem) {
        return YES;
    }
    NSString *amount = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (_selBetItem && _selAideModel && amount.length) {
        self.betDetailView.hidden = NO;
        float total = amount.floatValue * self.selBetItem.odds.floatValue;
        self.betDetailLabel.text = [NSString stringWithFormat:@"%@，%@，%@ 奖金:%.4f",self.selAideModel.title,self.selAideModel.playCateName,self.selBetItem.playName,total];
        [self updateBetDetailLabelTextColor];
    } else {
        self.betDetailView.hidden = YES;
    }
    return YES;
}

- (NSMutableArray<UGChanglongaideModel *> *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
        
    }
    return _dataArray;
}

@end
