//
//  UGLotteryAssistantController.m
//  ug
//
//  Created by ug on 2019/5/11.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGLotteryAssistantController.h"
#import "UGLotteryAssistantTableViewCell.h"
#import "UGChanglongaideModel.h"
#import "CountDown.h"

@interface UGLotteryAssistantController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewConstraintHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewBottom;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UITextField *amountLabel;
@property (weak, nonatomic) IBOutlet UIButton *betButton;
@property (weak, nonatomic) IBOutlet UIView *betDetailView;
@property (weak, nonatomic) IBOutlet UILabel *betDetailLabel;

@property (nonatomic, strong) CountDown *countDown;
@property (nonatomic, strong) CountDown *dataCountDown;

@property (nonatomic, strong) UGChanglongaideModel *selAideModel;
@property (nonatomic, strong) UGBetItemModel *selBetItem;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

static NSString *lotteryAssistantCellid = @"UGLotteryAssistantTableViewCell";
@implementation UGLotteryAssistantController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UGBackgroundColor;
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
    if ([CMCommon isPhoneX]) {
        self.bottomViewConstraintHeight.constant = 80;
        self.bottomViewBottom.constant = 86;
    }else {
        self.bottomViewConstraintHeight.constant = 50;
        self.bottomViewBottom.constant = 64;
    
    }
    [self updateSelectLabelWithCount:0];
    self.countDown = [[CountDown alloc] init];
    self.dataCountDown = [[CountDown alloc] init];
    WeakSelf
    [self.countDown countDownWithPER_SECBlock:^{
        [weakSelf updateTimeInVisibleCells];

    }];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:20
                                                  target:self
                                                selector:@selector(getChanglong)
                                                userInfo:nil
                                                 repeats:true];
    
    [self getChanglong];
   
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getChanglong];
    }];
    SANotificationEventSubscribe(UGNotificationGetChanglongBetRecrod, self, ^(typeof (self) self, id obj) {
        [self.amountLabel resignFirstResponder];
    });
    
    //添加通知，来控制键盘和输入框的位置
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
     [self.timer fire];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.timer invalidate];
}

- (void)getChanglong {
    
//    [CMNetwork getChanglongWithParams:@{@"id":@"60"} completion:^(CMResult<id> *model, NSError *err) {
//        [self.tableView.mj_header endRefreshing];
//        [CMResult processWithResult:model success:^{
//            if (model.data) {
//                
//                self.dataArray = model.data;
//                [self.tableView reloadData];
//            }
//        } failure:^(id msg) {
//            
//        }];
//    }];
    
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

    NSString *amount = self.amountLabel.text;
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
    
    [SVProgressHUD showWithStatus:nil];
    [CMNetwork userBetWithParams:mutDict completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            [SVProgressHUD showSuccessWithStatus:model.msg];
            SANotificationEventPost(UGNotificationGetUserInfo, nil);
            betItem.select = NO;
            self.selBetItem = nil;
            [self.tableView reloadData];
            [self clearClick:nil];
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
            
        }else {
            weakSelf.betDetailView.hidden = YES;
            weakSelf.selAideModel = nil;
            [weakSelf updateSelectLabelWithCount:0];
        }
        
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
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
    if (amount.length) {
        self.betDetailView.hidden = NO;
        float total = amount.floatValue * self.selBetItem.odds.floatValue;
        self.betDetailLabel.text = [NSString stringWithFormat:@"%@，%@，%@ 奖金:%.4f",self.selAideModel.title,self.selAideModel.playCateName,self.selBetItem.playName,total];
        [self updateBetDetailLabelTextColor];
    }else {
        
        self.betDetailView.hidden = YES;
    }
    return YES;
}

#pragma mark ----- 键盘显示的时候的处理
//- (void)keyboardWasShown:(NSNotification*)aNotification
//{
//    
//    //获得键盘的大小
//    NSDictionary* info = [aNotification userInfo];
//    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
//    
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.25];
//    [UIView setAnimationCurve:7];
//    self.view.y -= kbSize.height;
//    //    self.bottomViewBottomConstraint.constant = kbSize.height;
//    self.tableView.contentInset = UIEdgeInsetsMake(kbSize.height, 0, 60, 0);
//    [UIView commitAnimations];
//}
//
//#pragma mark -----    键盘消失的时候的处理
//- (void)keyboardWillBeHidden:(NSNotification*)aNotification
//{
//    
//    //获得键盘的大小
//    NSDictionary* info = [aNotification userInfo];
//    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.25];
//    [UIView setAnimationCurve:7];
//    self.view.y += kbSize.height;
//    //    self.bottomViewBottomConstraint.constant = 0;
//    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);
//    [UIView commitAnimations];
//}

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];

    }
    return _dataArray;
}

@end
