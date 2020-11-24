//
//  TKLMoneyViewController.m
//  UGBWApp
//
//  Created by fish on 2020/10/26.
//  Copyright © 2020 ug. All rights reserved.
//

#import "TKLMoneyViewController.h"
#import "TkLMoneyCollectionViewCell.h"
#import "UGFundsViewController.h"
#import "RedEnvelopeVCViewController.h"
#import "UGYYRightMenuView.h"
#import "CMLabelCommon.h"
#import "STBarButtonItem.h"
#import "UGAvaterSelectView.h"
#import "UGRechargeTypeTableViewController.h"
#import "UGWithdrawalViewController.h"
#import "UGRechargeRecordTableViewController.h"
#import "UGFundDetailsTableViewController.h"
#import "UGBalanceConversionRecordController.h"
#import "UGSignInHistoryModel.h"
#import "UGSalaryListView.h"
#import "TKLRechargeMainViewController.h"
#import "TKLRechargeListViewController.h"
#import "UGWithdrawalVC.h"
@interface TKLMoneyViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) NSMutableArray <NSString *> *titleArray;          /**<  cell 标题*/
@property (nonatomic, strong) NSMutableArray <NSString *> *imageNameArray;      /**<   cell头像*/
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;        /**<   内容 */

//=========================================================================
@property (weak, nonatomic) IBOutlet UIView *userInfoView;                      /**<   用户View */
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;                /**<   用户头像 */
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;                    /**<   用户昵称 */
@property (weak, nonatomic) IBOutlet UILabel *userMoneyLabel;                   /**<   用户余额 */
@property (weak, nonatomic) IBOutlet UILabel *uidLabel;                         /**<   用户id */
@property (weak, nonatomic) IBOutlet UIButton *refreshFirstButton;              /**<   刷新按钮 */
//=========================================================================
@property (strong, nonatomic)UGYYRightMenuView *yymenuView;   /**<   侧边栏 */
//=========================================================================
@property (weak, nonatomic) IBOutlet UIButton *salaryBtn;  /**<   领取俸禄 */
@property (nonatomic, strong) NSMutableArray <UGSignInHistoryModel *> *historyDataArray;
@end

@implementation TKLMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"资金管理";
    _historyDataArray = [NSMutableArray new];
    [self.salaryBtn.superview setHidden:SysConf.mBonsSwitch];
    self.navigationItem.rightBarButtonItem = [STBarButtonItem barButtonItemWithImageName:@"gengduo" target:self action:@selector(rightBarBtnClick)];
    self.titleArray = [[NSMutableArray alloc] initWithObjects:@"充值记录",@"提现记录",@"红包记录",@"转换记录",@"资金明细", nil] ;
    self.imageNameArray = [[NSMutableArray alloc] initWithObjects:@"tkl_czjl",@"tkl_txjl",@"tkl_hbjl",@"tkl_zzjl",@"tkl_zjmx", nil] ;
    
    self.myCollectionView.backgroundColor =    Skin1.is23 ? RGBA(135, 135, 135, 1) : Skin1.bgColor;
    self.myCollectionView.dataSource = self;
    self.myCollectionView.delegate = self;
    [self.myCollectionView registerNib:[UINib nibWithNibName:@"TkLMoneyCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"TkLMoneyCollectionViewCell"];
    self.myCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 84, 0);
    //=========================================================================
    [self.userInfoView setBackgroundColor: Skin1.navBarBgColor];
    self.headImageView.layer.cornerRadius = self.headImageView.height / 2 ;
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.userInteractionEnabled = YES;
    SANotificationEventSubscribe(UGNotificationUserAvatarChanged, self, ^(typeof (self) self, id obj) {
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[UGUserModel currentUser].avatar] placeholderImage:[UIImage imageNamed:@"touxiang-1"]];
    });
    SANotificationEventSubscribe(UGNotificationGetUserInfoComplete, self, ^(typeof (self) self, id obj) {
        [self refreshBalance:nil];
    });
    [self getUserInfo];
    
}

//刷新余额动画
- (void)startAnimation {
    CABasicAnimation *ReFreshAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    ReFreshAnimation.toValue = [NSNumber numberWithFloat:M_PI*2.0];
    ReFreshAnimation.duration = 1;
    ReFreshAnimation.repeatCount = HUGE_VALF;
    [self.refreshFirstButton.layer addAnimation:ReFreshAnimation forKey:@"rotationAnimation"];
}

//刷新余额动画
- (void)stopAnimation {
    [self.refreshFirstButton.layer removeAllAnimations];
}

- (void)getUserInfo {
    [self startAnimation];
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid};
    WeakSelf;
    [CMNetwork getUserInfoWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            UGUserModel *user = model.data;
            UGUserModel *oldUser = [UGUserModel currentUser];
            user.sessid = oldUser.sessid;
            user.token = oldUser.token;
            UGUserModel.currentUser = user;
            [self setupUserInfo];
            [weakSelf stopAnimation];
        } failure:^(id msg) {
            [weakSelf stopAnimation];
        }];
    }];
}

- (void)setupUserInfo{
    UGUserModel *user = [UGUserModel currentUser];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"touxiang-1"]];
    if (![CMCommon stringIsNull:user.username]) {
        self.userNameLabel.text = [NSString stringWithFormat:@"您好,%@",user.username];
    }
    if (![CMCommon stringIsNull:user.balance]) {
        self.userMoneyLabel.text = [NSString stringWithFormat:@"余额:%@ 元",user.balance];
        [CMLabelCommon setRichNumberWithLabel:self.userMoneyLabel Color:RGBA(255, 211, 0, 1) FontSize:17.0];
    }
    if (![CMCommon stringIsNull:user.uid]) {
        self.uidLabel.text = [NSString stringWithFormat:@"用户ID:%@",user.uid];
    }
}

// 刷新余额
- (IBAction)refreshBalance:(id)sender {
    [self getUserInfo];
    
    if (sender) {
        __weakSelf_(__self);
        [CMNetwork needToTransferOutWithParams:@{@"token":UserI.token} completion:^(CMResult<id> *model, NSError *err) {
            BOOL needToTransferOut = [model.data[@"needToTransferOut"] boolValue];
            if (needToTransferOut) {
                UIAlertController *ac = [AlertHelper showAlertView:@"温馨提示" msg:@"真人游戏正在进行或有余额未成功转出，请确认是否需要转出游戏余额" btnTitles:@[@"取消", @"确认"]];
                [ac setActionAtTitle:@"确认" handler:^(UIAlertAction *aa) {
                    [CMNetwork autoTransferOutWithParams:@{@"token":[UGUserModel currentUser].sessid} completion:^(CMResult<id> *model, NSError *err) {
                        if (!err) {
                            [SVProgressHUD showSuccessWithStatus:@"转出成功"];
                            [__self getUserInfo];
                        }
                    }];
                }];
            }
        }];
    }
}
- (IBAction)rechargeButtonTaped:(id)sender {
    //存款
    TKLRechargeMainViewController*rechargeVC = _LoadVC_from_storyboard_(@"TKLRechargeMainViewController");
    [self.navigationController pushViewController:rechargeVC animated:YES];
    
//    TKLRechargeListViewController *view1 = _LoadVC_from_storyboard_(@"TKLRechargeListViewController");
//    view1.type = RT_转账;
//    [self.navigationController pushViewController:view1 animated:YES];
}
- (IBAction)withdrawButtonTaped:(id)sender {
    //提现
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGWithdrawalViewController" bundle:nil];
//    UGWithdrawalViewController *withdrawalVC = [storyboard instantiateInitialViewController];
//    [self.navigationController pushViewController:withdrawalVC animated:YES];
    UGWithdrawalVC *withdrawalVC = _LoadVC_from_storyboard_(@"UGWithdrawalVC");

    withdrawalVC.withdrawSuccessBlock = ^{
    };
    [NavController1 pushViewController:withdrawalVC animated:true];
}
//换头像
- (IBAction)showAvaterSelectView {
    if (UserI.isTest) {
        return;
    }
    UGAvaterSelectView *avaterView = [[UGAvaterSelectView alloc] initWithFrame:CGRectMake(0, UGScerrnH, UGScreenW, UGScreenW)];
    [avaterView show];
}
//退出登录
- (IBAction)outApp:(id)sender {
    [QDAlertView showWithTitle:@"温馨提示" message:@"确定退出账号" cancelButtonTitle:@"取消" otherButtonTitle:@"确定" completionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [CMNetwork userLogoutWithParams:@{@"token":[UGUserModel currentUser].sessid} completion:nil];
                UGUserModel.currentUser = nil;
                SANotificationEventPost(UGNotificationUserLogout, nil);
            });
        }
    }];
}
//领取俸禄
- (IBAction)lqflAction:(id)sender {
    [self getMissionBonusList];
}

//侧边栏
- (void)rightBarBtnClick {
    self.yymenuView = [[UGYYRightMenuView alloc] initWithFrame:CGRectMake(UGScreenW /2 , 0, UGScreenW / 2, UGScerrnH)];
    self.yymenuView.titleType = @"1";
    [self.yymenuView show];
}


#pragma mark - UICollectionViewDelegate
#pragma mark UICollectionView datasource
//collectionView有几个section
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    int sections = 1;
    return sections;
}

//每个section有几个item
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSInteger rows = self.titleArray.count;
   
    return rows;
}

//每个cell的具体内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    TkLMoneyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TkLMoneyCollectionViewCell" forIndexPath:indexPath];
    cell.menuName = self.titleArray[indexPath.row];
    [cell.imageView setImage:[UIImage imageNamed:self.imageNameArray[indexPath.row]]];
    return cell;
    
}

//cell size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = {APP.Width, 50};
    return size;
    
}

//item偏移
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
}

//行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [self didSelectCellWithTitle:[self.titleArray objectAtIndex:indexPath.row]];
}

- (void)didSelectCellWithTitle:(NSString *)title {

    if ([title hasPrefix:@"充值记录"]) {
        UGRechargeRecordTableViewController *rechargeRecordVC = _LoadVC_from_storyboard_(@"UGRechargeRecordTableViewController");
        rechargeRecordVC.recordType = RecordTypeRecharge;
        [NavController1 pushViewController:rechargeRecordVC animated:true];
    }
    else if ([title isEqualToString:@"提现记录"]) {
        UGRechargeRecordTableViewController *rechargeRecordVC =  _LoadVC_from_storyboard_(@"UGRechargeRecordTableViewController");
        rechargeRecordVC.recordType = RecordTypeWithdraw;
        [NavController1 pushViewController:rechargeRecordVC animated:true];
    }
    else if ([title isEqualToString:@"红包记录"]) {
        RedEnvelopeVCViewController *recordVC = _LoadVC_from_storyboard_(@"RedEnvelopeVCViewController");
        recordVC.type = 1;
        [NavController1 pushViewController:recordVC animated:true];
    }
    else if ([title isEqualToString:@"转换记录"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
        UGBalanceConversionRecordController *recordVC = [storyboard instantiateViewControllerWithIdentifier:@"UGBalanceConversionRecordController"];
        [self.navigationController pushViewController:recordVC animated:YES];
    }
    else if ([title isEqualToString:@"资金明细"]) {
        UGFundDetailsTableViewController *detailsVC = _LoadVC_from_storyboard_(@"UGFundDetailsTableViewController");
        [NavController1 pushViewController:detailsVC animated:true];
    }
    
    
}

#pragma mark -- 其他方法

//获取俸禄列表数据
- (void)getMissionBonusList {
    
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid};

    [SVProgressHUD showWithStatus:nil];
    WeakSelf;
    [CMNetwork getMissionBonusListUrlWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            [SVProgressHUD dismiss];
            NSLog(@"model.data = %@",model.data);
            weakSelf.historyDataArray = model.data;
            NSLog(@"_historyDataArray = %@",self.historyDataArray);
            if (![CMCommon arryIsNull:weakSelf.historyDataArray]) {
                [weakSelf showUGSignInHistoryView];
            }


        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }];

}
- (void)showUGSignInHistoryView {

    UGSalaryListView *notiveView = [[UGSalaryListView alloc] initWithFrame:CGRectMake(20, 120, UGScreenW - 40, UGScerrnH - 260)];
    notiveView.dataArray = self.historyDataArray;
    [notiveView.bgView setBackgroundColor: Skin1.navBarBgColor];

    [notiveView show];
    
}
@end
