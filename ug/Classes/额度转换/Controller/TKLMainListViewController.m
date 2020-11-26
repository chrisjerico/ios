//
//  TKLMainListViewController.m
//  UGBWApp
//
//  Created by fish on 2020/10/23.
//  Copyright © 2020 ug. All rights reserved.
//

#import "TKLMainListViewController.h"
#import "CMCommon.h"
#import "UGPlatformBalanceTableViewCell.h"
#import "YBPopupMenu.h"
#import "UGPlatformGameModel.h"

@interface TKLMainListViewController ()<UITableViewDelegate,UITableViewDataSource,YBPopupMenuDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;            /**<   内容列表 */
@property (weak, nonatomic) IBOutlet UIButton *moneyBtn1;               /**<   转出按钮 */
@property (weak, nonatomic) IBOutlet UIButton *moneyBtn2;               /**<   转入按钮 */
@property (weak, nonatomic) IBOutlet UITextField *moneyTxt;             /**<   转入金额 */

@property (nonatomic, strong) YBPopupMenu *transferOutPopView;
@property (nonatomic, strong) YBPopupMenu *transferInPopView;

@property (nonatomic, strong) NSMutableArray <NSString *> *transferArray;
@property (nonatomic, assign) NSInteger outIndex;
@property (nonatomic, assign) NSInteger inIndex;
@end
static NSString *balanceCellid = @"UGPlatformBalanceTableViewCell";
@implementation TKLMainListViewController
-(void)dataReLoad{
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"额度转换";
    [self.view setBackgroundColor: Skin1.bgColor];
    _moneyTxt.delegate = self;
    [self tableStyle];
    _transferArray = [NSMutableArray array];
    for (UGPlatformGameModel *game in self.dataArray) {
        [self.transferArray addObject:game.title];
    }
    self.outIndex = -1;
    self.inIndex = -1;
}

-(void)tableStyle{
    [self.tableView registerNib:[UINib nibWithNibName:@"UGPlatformBalanceTableViewCell" bundle:nil] forCellReuseIdentifier:balanceCellid];
    self.tableView.rowHeight = 50;
    self.tableView.layer.cornerRadius = 10;
    self.tableView.layer.masksToBounds = true;
    [self.tableView setBackgroundColor:Skin1.textColor4];
}

#pragma mark - tableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UGPlatformBalanceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:balanceCellid forIndexPath:indexPath];
    UGPlatformGameModel *model = self.dataArray[indexPath.row];
    cell.item = model;
    [cell.nameLabel setTextColor:Skin1.textColor1];
    [cell.contentView setBackgroundColor:Skin1.textColor4];
    WeakSelf
    cell.refreshBlock = ^{
        model.refreshing = YES;
        [weakSelf checkRealBalance:model];
        [weakSelf.tableView reloadData];
    };
    return cell;
}

- (void)checkRealBalance:(UGPlatformGameModel *)game {
    NSDictionary *parmas = @{@"id":game.gameId,
                             @"token":[UGUserModel currentUser].sessid
    };
    __weakSelf_(__self);
    [CMNetwork checkRealBalanceWithParams:parmas completion:^(CMResult<id> *model, NSError *err) {

        [CMResult processWithResult:model success:^{
            NSDictionary *dict = (NSDictionary *)model.data;
            game.balance = dict[@"balance"];

        } failure:^(id msg) {
            [SVProgressHUD dismiss];
        }];
        game.refreshing = NO;
        [__self.tableView reloadData];
    }];
    
}

#pragma mark YBPopupMenuDelegate

- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu {
    if (index >= 0) {
        if (ybPopupMenu == self.transferOutPopView) {
            [self.moneyBtn1 setTitle:self.transferArray[index] forState:0];
            self.outIndex = index;
        } else {
            [self.moneyBtn2 setTitle:self.transferArray[index] forState:0];
            self.inIndex = index;
        }
    }
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [self.moneyTxt resignFirstResponder];
        return NO;
    }
    if (textField.text.length + string.length - range.length > 8) {
        return NO;
    }
    return YES;
}

#pragma mark - 点击事件

// 选择转出钱包
- (IBAction)transferOutClick:(id)sender {

    self.transferOutPopView = [[YBPopupMenu alloc] initWithTitles:self.transferArray icons:nil menuWidth:CGSizeMake(self.moneyBtn1.width+30, 250) delegate:self];
    self.transferOutPopView.fontSize = 14;
    self.transferOutPopView.type = YBPopupMenuTypeDefault;
    [self.transferOutPopView showRelyOnView:self.moneyBtn1];
}

// 选择转入钱包
- (IBAction)transferInClick:(id)sender {

    self.transferInPopView = [[YBPopupMenu alloc] initWithTitles:self.transferArray icons:nil menuWidth:CGSizeMake(self.moneyBtn2.width+30, 250) delegate:self];
    self.transferInPopView.fontSize = 14;
    self.transferInPopView.type = YBPopupMenuTypeDefault;
    [self.transferInPopView showRelyOnView:self.moneyBtn2];
}

// 开始转换
- (IBAction)startTransfer:(id)sender {
    
    if (self.outIndex == -1) {
        [SVProgressHUD showInfoWithStatus:@"请选择转出钱包"];
        return;
    }
    if (self.inIndex == -1) {
        [SVProgressHUD showInfoWithStatus:@"请选择转入钱包"];
        return;
    }
    ck_parameters(^{
        ck_parameter_non_empty(self.moneyBtn1.titleLabel.text, @"");
        ck_parameter_non_empty(self.moneyBtn2.titleLabel.text, @"");
        ck_parameter_non_equal(self.moneyBtn1.titleLabel.text, self.moneyBtn2.titleLabel.text, @"转出钱包和转入钱包不能一致");
        ck_parameter_non_empty(self.moneyTxt.text, @"请输入转换金额");
    
    }, ^(id err) {
        [SVProgressHUD showInfoWithStatus:err];
    }, ^{
        
        

        NSLog(@"self.outIndex = %ld",(long)self.outIndex);
        NSLog(@"self.inIndex = %ld",(long)self.inIndex);
        [self.moneyTxt resignFirstResponder];
        UGPlatformGameModel *outModel;
        UGPlatformGameModel *intModel;
       
        outModel = self.dataArray[self.outIndex];
        if ([CMCommon stringIsNull:outModel.gameId] ) {
            outModel.gameId = @"0";
        }
        
        intModel = self.dataArray[self.inIndex];
        if ([CMCommon stringIsNull:intModel.gameId] ) {
            intModel.gameId = @"0";
        }
       
        [SVProgressHUD showWithStatus:nil];
        
        NSString *amount = self.moneyTxt.text;
        if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
            return;
        }
        NSDictionary *params = @{@"fromId": outModel.gameId ,
                                 @"toId": intModel.gameId ,
                                 @"money":amount,
                                 @"token":[UGUserModel currentUser].sessid,
        };
        WeakSelf;
        [CMNetwork manualTransferWithParams:params completion:^(CMResult<id> *model, NSError *err) {
            [CMResult processWithResult:model success:^{
                [SVProgressHUD showSuccessWithStatus:model.msg];
                SANotificationEventPost(UGNotificationGetUserInfo, nil);
                [weakSelf.moneyBtn1 setTitle:@"" forState:0];
                [weakSelf.moneyBtn2 setTitle:@"" forState:0];
                weakSelf.moneyTxt.text = nil;
                
                if (!outModel || !intModel)
                    SANotificationEventPost(UGNotificationGetUserInfo, nil);
                
                // 刷新ui
                intModel.balance = [AppDefine stringWithFloat:(intModel.balance.doubleValue + amount.doubleValue) decimal:4];
                outModel.balance = [AppDefine stringWithFloat:(outModel.balance.doubleValue - amount.doubleValue) decimal:4];
                [weakSelf.tableView reloadData];
            } failure:^(id msg) {
                [SVProgressHUD showErrorWithStatus:msg];
            }];
        }];
    });
}

//一键领取
- (IBAction)onExtractAllBtnClick:(UIButton *)sender {

    if (!_dataArray.count) {
        return;
    }

    __weakSelf_(__self);
    
    [SVProgressHUD show];
    
    [CMNetwork oneKeyTransferOutWithParams:@{@"token":UserI.sessid} completion:^(CMResult<id> *model, NSError *err) {
       
        [CMResult processWithResult:model success:^{
            [SVProgressHUD showSuccessWithStatus:model.msg];
            
            if (model.code != 0) return;
            if (model.code == 0) {
                __block NSInteger __cnt = 0;
                NSArray <UGPlatformGameModel *>*arry = [UGPlatformGameModel arrayOfModelsFromDictionaries:[model.data objectForKey:@"games"] error:nil];
                
                for (UGPlatformGameModel *pgm in arry) {
                    NSLog(@"pgm =%@",pgm.gameId);
                    
                    if (![pgm.gameId isEqualToString:@"0"]) {
                        // 快速转出游戏余额
                        [CMNetwork quickTransferOutWithParams:@{@"token":UserI.sessid, @"id":pgm.gameId} completion:^(CMResult<id> *model, NSError *err) {
                            __cnt++;
                            if (__cnt == arry.count) {
                                [SVProgressHUD showSuccessWithStatus:@"一键提取完成"];
                                // 刷新余额并刷新UI
                                SANotificationEventPost(UGNotificationGetUserInfo, nil);
                                for (UGPlatformGameModel *pgm in __self.dataArray) {
                                    pgm.balance = @"0.00";
                                }
                                [__self.moneyBtn1 setTitle:@"" forState:0];
                                [__self.moneyBtn2 setTitle:@"" forState:0];
                                __self.moneyTxt.text = nil;
                                [__self.tableView reloadData];
                            }
                        }];
                    }
                   
                }
            }

        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }];
}
@end
