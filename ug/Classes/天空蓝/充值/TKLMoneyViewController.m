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
@end

@implementation TKLMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"充值";
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
    UGFundsViewController *fundsVC = _LoadVC_from_storyboard_(@"UGFundsViewController");
    fundsVC.selectIndex = 0;
    [self.navigationController pushViewController:fundsVC animated:YES];
}
- (IBAction)withdrawButtonTaped:(id)sender {
    //提现
    UGFundsViewController *fundsVC = _LoadVC_from_storyboard_(@"UGFundsViewController");
    fundsVC.selectIndex = 1;
    [self.navigationController pushViewController:fundsVC animated:YES];
}
//换头像
- (IBAction)showAvaterSelectView {
    if (UserI.isTest) {
        return;
    }
    UGAvaterSelectView *avaterView = [[UGAvaterSelectView alloc] initWithFrame:CGRectMake(0, UGScerrnH, UGScreenW, UGScreenW)];
    [avaterView show];
}

//侧边栏
- (void)rightBarBtnClick {
    self.yymenuView = [[UGYYRightMenuView alloc] initWithFrame:CGRectMake(UGScreenW /2 , 0, UGScreenW / 2, UGScerrnH)];
    self.yymenuView.titleType = @"1";
    //此处为重点
    WeakSelf;
    self.yymenuView.backToHomeBlock = ^{
        weakSelf.navigationController.tabBarController.selectedIndex = 0;
    };
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
        UGFundsViewController *fundsVC = _LoadVC_from_storyboard_(@"UGFundsViewController");
        fundsVC.selectIndex = 2;
        [NavController1 pushViewController:fundsVC animated:true];
    }
    else if ([title isEqualToString:@"提现记录"]) {
        UGFundsViewController *fundsVC = _LoadVC_from_storyboard_(@"UGFundsViewController");
        fundsVC.selectIndex = 3;
        [NavController1 pushViewController:fundsVC animated:true];
    }
    else if ([title isEqualToString:@"红包记录"]) {
        RedEnvelopeVCViewController *recordVC = _LoadVC_from_storyboard_(@"RedEnvelopeVCViewController");
        recordVC.type = 1;
        [NavController1 pushViewController:recordVC animated:true];
    }
    else if ([title isEqualToString:@"转换记录"]) {
       
    }
    else if ([title isEqualToString:@"资金明细"]) {
        UGFundsViewController *fundsVC = _LoadVC_from_storyboard_(@"UGFundsViewController");
        fundsVC.selectIndex = 4;
        [NavController1 pushViewController:fundsVC animated:true];
    }
    
    
}
@end
