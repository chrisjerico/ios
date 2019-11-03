//
//  UGBalanceConversionController.m
//  ug
//
//  Created by ug on 2019/5/7.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGBalanceConversionController.h"
#import "STBarButtonItem.h"
#import "CMCommon.h"
#import "UGPlatformBalanceTableViewCell.h"
#import "YBPopupMenu.h"
#import "UGBalanceConversionRecordController.h"
#import "UGPlatformGameModel.h"


@interface UGBalanceConversionController () <UITableViewDelegate, UITableViewDataSource, YBPopupMenuDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *conversionButton;    /**<   开始转换Button */
@property (weak, nonatomic) IBOutlet UIView *balanceView;           /**<   余额View */
@property (weak, nonatomic) IBOutlet UIImageView *transferOutArrow; /**<   转出箭头ImageView */
@property (weak, nonatomic) IBOutlet UIImageView *tarnsferInArrow;  /**<   转入箭头ImageView */
@property (weak, nonatomic) IBOutlet UILabel *transferOutLabel;     /**<   转出钱包Label */
@property (weak, nonatomic) IBOutlet UILabel *transferInLabel;      /**<   转入钱包Label */
@property (weak, nonatomic) IBOutlet UITextField *amountTextF;      /**<   转换金额TextField */
@property (weak, nonatomic) IBOutlet UIButton *tarnsferOutButton;   /**<   选择转出钱包Button */
@property (weak, nonatomic) IBOutlet UIButton *transferInButton;    /**<   选择转入钱包Button */
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;       /**<   刷新余额Button */
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;         /**<   余额Label */

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) YBPopupMenu *transferOutPopView;
@property (nonatomic, strong) YBPopupMenu *transferInPopView;
@property (nonatomic, strong) NSMutableArray <NSString *> *transferArray;
@property (nonatomic, strong) NSMutableArray <UGPlatformGameModel *> *dataArray;
@property (nonatomic, assign) NSInteger outIndex;
@property (nonatomic, assign) NSInteger inIndex;

@end

static NSString *balanceCellid = @"UGPlatformBalanceTableViewCell";
@implementation UGBalanceConversionController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)skin {
    [self.conversionButton setBackgroundColor:Skin1.navBarBgColor];
    [self.view setBackgroundColor:Skin1.bgColor];
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"额度转换";
    [self.conversionButton setBackgroundColor:Skin1.navBarBgColor];
    SANotificationEventSubscribe(UGNotificationWithSkinSuccess, self, ^(typeof (self) self, id obj) {
        
        [self skin];
    });
    SANotificationEventSubscribe(UGNotificationGetUserInfoComplete, self, ^(typeof (self) self, id obj) {
        [self.refreshButton.layer removeAllAnimations];
        UGUserModel *model = [UGUserModel currentUser];
        self.balanceLabel.text = [NSString stringWithFormat:@"¥%@",[model.balance removeFloatAllZero]];
    });
    self.navigationItem.rightBarButtonItem = [STBarButtonItem barButtonItemWithTitle:@"转换记录" target:self action:@selector(rightBarButtonItemClick)];
    self.amountTextF.delegate = self;
    UGUserModel *user = [UGUserModel currentUser];
    self.balanceLabel.text = [NSString stringWithFormat:@"¥%@",[user.balance removeFloatAllZero]];
  
    [self getRealGames];
}


- (void)viewDidLayoutSubviews {
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"UGPlatformBalanceTableViewCell" bundle:nil] forCellReuseIdentifier:balanceCellid];
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    
}

// 刷新余额
- (IBAction)refreshBalance:(id)sender {
    SANotificationEventPost(UGNotificationGetUserInfo, nil);
    [self startAnimation];
}

// 刷新余额动画
- (void)startAnimation {
    CABasicAnimation *ReFreshAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    ReFreshAnimation.toValue = [NSNumber numberWithFloat:M_PI*2.0];
    ReFreshAnimation.duration = 1;
    ReFreshAnimation.repeatCount = HUGE_VALF;
    [self.refreshButton.layer addAnimation:ReFreshAnimation forKey:@"rotationAnimation"];
}

// 开始转换
- (IBAction)startTransfer:(id)sender {
    ck_parameters(^{
        ck_parameter_non_empty(self.transferOutLabel.text, @"请选择转出钱包");
        ck_parameter_non_empty(self.transferInLabel.text, @"请选择转入钱包");
        ck_parameter_non_equal(self.transferOutLabel.text, self.transferInLabel.text, @"转出钱包和转入钱包不能一致");
        ck_parameter_non_empty(self.amountTextF.text, @"请输入转换金额");
    }, ^(id err) {
        [SVProgressHUD showInfoWithStatus:err];
    }, ^{
        
        [self.amountTextF resignFirstResponder];
        UGPlatformGameModel *outModel;
        UGPlatformGameModel *intModel;
        if (self.outIndex) {
            outModel = self.dataArray[self.outIndex - 1];
        }
        if (self.inIndex) {
            intModel = self.dataArray[self.inIndex - 1];
        }
        [SVProgressHUD showWithStatus:nil];
        
        NSString *amount = self.amountTextF.text;
        if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
            return;
        }
        NSDictionary *params = @{@"fromId":outModel ? outModel.gameId : @"0",
                                 @"toId":intModel ? intModel.gameId : @"0",
                                 @"money":amount,
                                 @"token":[UGUserModel currentUser].sessid,
                                 };
        
        [CMNetwork manualTransferWithParams:params completion:^(CMResult<id> *model, NSError *err) {
            [CMResult processWithResult:model success:^{
                [SVProgressHUD showSuccessWithStatus:model.msg];
                SANotificationEventPost(UGNotificationGetUserInfo, nil);
                self.transferOutLabel.text = nil;
                self.transferInLabel.text = nil;
                self.amountTextF.text = nil;
                
                if (!outModel || !intModel)
                    SANotificationEventPost(UGNotificationGetUserInfo, nil);
                
                // 刷新ui
                intModel.balance = [AppDefine stringWithFloat:(intModel.balance.doubleValue + amount.doubleValue) decimal:4];
                outModel.balance = [AppDefine stringWithFloat:(outModel.balance.doubleValue - amount.doubleValue) decimal:4];
                [self.tableView reloadData];
            } failure:^(id msg) {
                [SVProgressHUD showErrorWithStatus:msg];
            }];
        }];
    });
}

- (void)getRealGames {
    [SVProgressHUD showWithStatus:nil];
    [CMNetwork getRealGamesWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            [SVProgressHUD dismiss];
            self.dataArray = model.data;
            [self.transferArray addObject:@"我的钱包"];
            for (UGPlatformGameModel *game in self.dataArray) {
                [self.transferArray addObject:game.title];
                [self checkRealBalance:game];
            }
            [self.tableView reloadData];
           
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }];
}

- (void)checkRealBalance:(UGPlatformGameModel *)game {
    NSDictionary *parmas = @{@"id":game.gameId,
                             @"token":[UGUserModel currentUser].sessid
                             };
    [CMNetwork checkRealBalanceWithParams:parmas completion:^(CMResult<id> *model, NSError *err) {
        
        [CMResult processWithResult:model success:^{
            NSDictionary *dict = (NSDictionary *)model.data;
            game.balance = dict[@"balance"];
          
        } failure:^(id msg) {
            [SVProgressHUD dismiss];
        }];
        game.refreshing = NO;
        [self.tableView reloadData];
    }];
    
}

- (void)rightBarButtonItemClick {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    UGBalanceConversionRecordController *recordVC = [storyboard instantiateViewControllerWithIdentifier:@"UGBalanceConversionRecordController"];
    [self.navigationController pushViewController:recordVC animated:YES];
}

// 选择转出钱包
- (IBAction)transferOutClick:(id)sender {
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI);
    self.transferOutArrow.transform = transform;
    self.transferOutPopView = [[YBPopupMenu alloc] initWithTitles:self.transferArray icons:nil menuWidth:CGSizeMake(self.tarnsferOutButton.width, 250) delegate:self];
    self.transferOutPopView.fontSize = 14;
    self.transferOutPopView.type = YBPopupMenuTypeDefault;
    [self.transferOutPopView showRelyOnView:self.tarnsferOutButton];
}

// 选择转入钱包
- (IBAction)transferInClick:(id)sender {
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI);
    self.tarnsferInArrow.transform = transform;
    self.transferInPopView = [[YBPopupMenu alloc] initWithTitles:self.transferArray icons:nil menuWidth:CGSizeMake(self.transferInButton.width, 250) delegate:self];
    self.transferInPopView.fontSize = 14;
    self.transferInPopView.type = YBPopupMenuTypeDefault;
    [self.transferInPopView showRelyOnView:self.transferInButton];
}

#pragma mark YBPopupMenuDelegate

- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu {
    if (index >= 0) {
        if (ybPopupMenu == self.transferOutPopView) {
            self.transferOutLabel.text = self.transferArray[index];
            self.outIndex = index;
        } else {
            self.transferInLabel.text = self.transferArray[index];
            self.inIndex = index;
        }
    }
    
    if (ybPopupMenu == self.transferOutPopView) {
        CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI * 2);
        self.transferOutArrow.transform = transform;
    }else {
        CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI * 2);
        self.tarnsferInArrow.transform = transform;
        
    }
}


#pragma mark - tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UGPlatformBalanceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:balanceCellid forIndexPath:indexPath];
    UGPlatformGameModel *model = self.dataArray[indexPath.row];
    cell.item = model;
    [cell.nameLabel setTextColor:Skin1.navBarBgColor];
    WeakSelf
    cell.refreshBlock = ^{
        model.refreshing = YES;
        [weakSelf checkRealBalance:model];
        [weakSelf.tableView reloadData];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [self.amountTextF resignFirstResponder];
        return NO;
    }
    if (textField.text.length + string.length - range.length > 8) {
        return NO;
    }
    return YES;
}

#pragma mark - Getter

- (UITableView *)tableView {
    float height;

    if ([TabBarController1.viewControllers containsObject:self]) {
        if ([CMCommon isPhoneX]) {
            height = UGScerrnH - CGRectGetMaxY(self.balanceView.frame) - k_Height_TabBar -IPHONE_SAFEBOTTOMAREA_HEIGHT-44;
        } else {
            height = UGScerrnH - CGRectGetMaxY(self.balanceView.frame) - k_Height_TabBar -IPHONE_SAFEBOTTOMAREA_HEIGHT-44;
        }
    }
    else {
        if ([CMCommon isPhoneX]) {
            height = UGScerrnH - CGRectGetMaxY(self.balanceView.frame) - k_Height_TabBar -IPHONE_SAFEBOTTOMAREA_HEIGHT;
        } else {
            height = UGScerrnH - CGRectGetMaxY(self.balanceView.frame) - k_Height_TabBar -IPHONE_SAFEBOTTOMAREA_HEIGHT;
        }
    }
    
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.balanceView.frame) + 10, UGScreenW - 20, height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.layer.cornerRadius = 10;
        _tableView.layer.masksToBounds = YES;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);
    }
    return _tableView;
}

- (NSMutableArray<UGPlatformGameModel *> *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray<NSString *> *)transferArray {
    if (_transferArray == nil) {
        _transferArray = [NSMutableArray array];
    }
    return _transferArray;
}

@end
