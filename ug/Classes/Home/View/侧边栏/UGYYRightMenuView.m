//
//  UGYYRightMenuView.m
//  ug
//
//  Created by ug on 2019/9/27.
//  Copyright © 2019 ug. All rights reserved.
//


#import "UGYYRightMenuView.h"
#import "UGBetRecordViewController.h"
#import "UGLotteryRecordController.h"
#import "UGAllNextIssueListModel.h"
#import "UGChangLongController.h"
#import "UGMailBoxTableViewController.h"
#import "UGYubaoViewController.h"
#import "UGFundsViewController.h"
#import "UGYYRightMenuTableViewCell.h"
#import "UGLotteryRulesView.h"
#import "UINavigationController+Extension.h"
#import "UGSkinViewController.h"
#import "UGAppVersionManager.h"
#import "SLWebViewController.h"
#import "LotteryTrendVC.h"
#import "RedEnvelopeVCViewController.h"

#import "GameCategoryDataModel.h"

@interface UGYYRightMenuView ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) CGRect oldFrame;

@property (nonatomic, assign) BOOL refreshing;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewHeightConstraint;    /**<   高度约束 */
@property (weak, nonatomic) IBOutlet UILabel *welComeLabel;     /**<   欢迎您！*/

@property (weak, nonatomic) IBOutlet UIView *jybgView;           /**<   简约模板时隐藏充值提现背景*/
@property (weak, nonatomic) IBOutlet UIView *bg2View;           /**<   充值提现背景*/
@property (weak, nonatomic) IBOutlet UIView *rechargeView;      /**<   充值背景*/
@property (weak, nonatomic) IBOutlet UIView *withdrawlView;     /**<   提现背景*/
@property (weak, nonatomic) IBOutlet UIImageView *icon1ImgeView;  /**<   充值图片*/
@property (weak, nonatomic) IBOutlet UIImageView *icon2ImageView; /**<  提现图片*/
@property (weak, nonatomic) IBOutlet UILabel *rechargeLabel;      /**<   充值文字*/
@property (weak, nonatomic) IBOutlet UILabel *withdrawLabel;      /**<   提现文字*/


@property (weak, nonatomic) IBOutlet UIButton *myButton;            /**<   黑色模板去会员中心*/

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;    /**<   头像*/


@property (nonatomic, strong) NSMutableArray <NSString *> *titleArray;
@property (nonatomic, strong) NSMutableArray <NSString *> *imageNameArray;

@property (nonatomic, strong) NSMutableArray <GameModel *> *tableArray;
@end

static NSString *menuCellid = @"UGYYRightMenuTableViewCell";

@implementation UGYYRightMenuView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"UGYYRightMenuView" owner:self options:nil].firstObject;
        self.frame = frame;
        self.oldFrame = frame;
        self.rechargeView.layer.cornerRadius = 5;
        self.rechargeView.layer.masksToBounds = YES;
        self.withdrawlView.layer.cornerRadius = 5;
        self.withdrawlView.layer.masksToBounds = YES;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView registerNib:[UINib nibWithNibName:@"UGYYRightMenuTableViewCell" bundle:nil] forCellReuseIdentifier:menuCellid];
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.userNameLabel.text = [UGUserModel currentUser].username;
        self.balanceLabel.text = [NSString stringWithFormat:@"¥%@",[[UGUserModel currentUser].balance removeFloatAllZero]];
        self.headImageView.layer.cornerRadius = self.headImageView.height / 2 ;
        self.headImageView.layer.masksToBounds = YES;
        
        self.tableArray = [NSMutableArray new];
        
        SANotificationEventSubscribe(UGNotificationGetUserInfoComplete, self, ^(typeof (self) self, id obj) {
            [self.refreshButton.layer removeAllAnimations];
            self.balanceLabel.text = [NSString stringWithFormat:@"¥%@",[UGUserModel currentUser].balance];
            [self tableDataAction ];

        });
        
        SANotificationEventSubscribe(UGNotificationUserAvatarChanged, self, ^(typeof (self) self, id obj) {
            [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[UGUserModel currentUser].avatar] placeholderImage:[UIImage imageNamed:@"BMprofile"]];
        });
        
        SANotificationEventSubscribe(UGNotificationloginTimeout, self, ^(typeof (self) self, id obj) {
            [self hiddenSelf];
        });
        
        [self tableDataAction ];
        

        
    }
    return self;
    
}


-(void)tableDataAction{
    
        NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                                 };
        [CMNetwork systemMobileRightWithParams:params completion:^(CMResult<id> *model, NSError *err) {

            [CMResult processWithResult:model success:^{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"=====");
                    
                    NSMutableArray <GameModel *> *tempArry = model.data;
                    
                    // 排序key, 某个对象的属性名称，是否升序, YES-升序, NO-降序
                    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"sort" ascending:YES];
                    // 排序结果
                    self.tableArray = [NSMutableArray new];
                    self.tableArray = [tempArry sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
                    
                    // 需要在主线程执行的代码
                     self.tableArray = model.data;
                     NSLog(@"tableArray = %@",self.tableArray);
                    [self.tableView reloadData];
                    
                });
                
            } failure:^(id msg) {
                [SVProgressHUD showErrorWithStatus:msg];

            }];
        }];
}


- (void)getUserInfo {
    if (!UGLoginIsAuthorized()) {
        [self.refreshButton.layer removeAllAnimations];
        return;
    }
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid};
    [CMNetwork getUserInfoWithParams:params completion:^(CMResult<id> *model, NSError *err) {
       
        [CMResult processWithResult:model success:^{
            UGUserModel *user = model.data;
            
          ;
     
            UGUserModel *oldUser = [UGUserModel currentUser];
            user.sessid = oldUser.sessid;
            user.token = oldUser.token;
            UGUserModel.currentUser = user;
            
            
            NSLog(@"unsettleAmount=%@",  [UGUserModel currentUser].unsettleAmount);
            [self.refreshButton.layer removeAllAnimations];
             self.balanceLabel.text = [NSString stringWithFormat:@"¥%@",[UGUserModel currentUser].balance];
             [self tableDataAction ];
        } failure:^(id msg) {
            [self.refreshButton.layer removeAllAnimations];
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }];
}
-(IBAction)showMMemberCenterView{
    NSLog(@"tap");
    if (Skin1.isBlack) {
        [self hiddenSelf];
        [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGBMMemberCenterViewController") animated:YES];
    }
}

- (void)setTitleType:(NSString *)titleType {
    _titleType = titleType;
    self.balanceLabel.text = [NSString stringWithFormat:@"¥%@",[UGUserModel currentUser].balance];
    [self tableDataAction ];

}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (CGRectContainsPoint(self.bounds, point)) {
        
    } else {
        [self hiddenSelf];
    }
    return view;
}

- (IBAction)refreshBalance:(id)sender {
    FastSubViewCode(self);
    if (UGLoginIsAuthorized()) {//已经登录
        [self startAnimation];
        [self getUserInfo];
        [_userNameLabel setHidden:NO];
        [_balanceLabel setHidden:NO];
        [_refreshButton setHidden:NO];
        [subButton(@"登入按钮") setHidden:YES];
        [subButton(@"免费开户按钮") setHidden:YES];
        
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[UGUserModel currentUser].avatar] placeholderImage:[UIImage imageNamed:@"BMprofile"]];
    }
    else{
        [_userNameLabel setHidden:YES];
        [_balanceLabel setHidden:YES];
        [_refreshButton setHidden:YES];
        [subButton(@"登入按钮") setHidden:NO];
        [subButton(@"免费开户按钮") setHidden:NO];
        [subButton(@"登入按钮") removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
        [subButton(@"登入按钮") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
            [self hiddenSelf];
            //登录
            [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGBMLoginViewController") animated:true];
        }];
        [subButton(@"免费开户按钮") removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
        [subButton(@"免费开户按钮") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
            [self hiddenSelf];
            //注册
            [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGBMRegisterViewController") animated:true];
        }];
    }
    
}

- (IBAction)rechregeClick:(id)sender {
    [self hiddenSelf];
    //    if (self.menuSelectBlock) {
    //        self.menuSelectBlock(100);
    //    }
    [self didSelectCellWithTitle:@"充值"];
}

- (IBAction)withdraw:(id)sender {
    [self hiddenSelf];
    //    if (self.menuSelectBlock) {
    //        self.menuSelectBlock(101);
    //    }
    [self didSelectCellWithTitle:@"提现"];
}


//刷新余额动画
- (void)startAnimation {
    CABasicAnimation *ReFreshAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    ReFreshAnimation.toValue = [NSNumber numberWithFloat:M_PI*2.0];
    ReFreshAnimation.duration = 1;
    ReFreshAnimation.repeatCount = HUGE_VALF;
    [self.refreshButton.layer addAnimation:ReFreshAnimation forKey:@"rotationAnimation"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GameModel *model = [self.tableArray objectAtIndex:indexPath.row];
    UGYYRightMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:menuCellid forIndexPath:indexPath];
   
    cell.imageName = model.icon;
    
//    if (model.subId == 5 || model.subId == 8) {
//        [cell letArrowHidden];
//    } else {
//        [cell letIconHidden];
//    }
    
    if (UGLoginIsAuthorized()) {//已经登录
        if (model.subId == 24) {
            
            NSLog(@"[UGUserModel currentUser].unsettleAmount =%@",[UGUserModel currentUser].unsettleAmount);
            cell.title = [NSString stringWithFormat:@"即时注单(%@)",[UGUserModel currentUser].unsettleAmount];
        }
        else if (model.subId == 25) {
            cell.title = [NSString stringWithFormat:@"今日输赢(%@)",[UGUserModel currentUser].todayWinAmount];
        }
        else if (model.subId == 27) {
              cell.title = [NSString stringWithFormat:@"当前版本号(%@)", APP.Version] ;
        }
        else{
            if ([CMCommon stringIsNull:model.name]) {
                cell.title = model.title;
            } else {
                cell.title = model.name;
            }
         
        }
    }
    else{
        if (model.subId == 27) {
            cell.title = [NSString stringWithFormat:@"当前版本号(%@)", APP.Version] ;
        }
        else{
            if ([CMCommon stringIsNull:model.name]) {
                cell.title = model.title;
            } else {
                cell.title = model.name;
            }
        }
    }

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
    //    if (self.menuSelectBlock) {
    //        self.menuSelectBlock(indexPath.row);
    //    }
    [self hiddenSelf];
    GameModel *model = [self.tableArray objectAtIndex:indexPath.row];
    model.realGameId = self.gameId;
    [self didSelectCellWitModel:model];
}

- (void)show {
    [self tableDataAction];
    if (Skin1.isBlack||Skin1.is23) {
        [self.rechargeView setBackgroundColor:Skin1.textColor1];
        [self.withdrawlView setBackgroundColor:Skin1.textColor1];
        self.rechargeView.layer.borderColor = Skin1.menuHeadViewColor.CGColor;
        self.withdrawlView.layer.borderColor = Skin1.menuHeadViewColor.CGColor;
        [self.bg2View setBackgroundColor:Skin1.menuHeadViewColor];
        _icon1ImgeView.image = [UIImage imageNamed:@"BMchongzhi"];
        _icon2ImageView.image = [UIImage imageNamed:@"BMtixian"];
        [_rechargeLabel setTextColor:Skin1.navBarBgColor];
        [_withdrawLabel setTextColor:Skin1.navBarBgColor];
        [_headImageView setHidden:NO];
        [_myButton setHidden:NO];
        [_welComeLabel setHidden:YES];
        [_bg2View setHidden:YES];
        self.bgViewHeightConstraint.constant = 244;
    } else {
        [self.rechargeView setBackgroundColor:Skin1.navBarBgColor];
        [self.withdrawlView setBackgroundColor:Skin1.navBarBgColor];
        [self.bg2View setBackgroundColor:[UIColor whiteColor]];
        _icon1ImgeView.image = [UIImage imageNamed:@"chongzhibai"];
        _icon2ImageView.image = [UIImage imageNamed:@"tixianbai"];
        [_rechargeLabel setTextColor:[UIColor whiteColor]];
        [_withdrawLabel setTextColor:[UIColor whiteColor]];
        [_headImageView setHidden:YES];
        [_myButton setHidden:YES];
        [_welComeLabel setHidden:NO];
        [_bg2View setHidden:YES];
        self.bgViewHeightConstraint.constant = 180;
    }
    
    self.backgroundColor = Skin1.textColor4;
    [self.bgView setBackgroundColor:Skin1.menuHeadViewColor];
    
    if (Skin1.isJY) {
        self.bgViewHeightConstraint.constant = k_Height_StatusBar;
        [self.jybgView setBackgroundColor:Skin1.navBarBgColor];
        [self.jybgView setHidden:NO];

    }
    
    UIWindow* window = UIApplication.sharedApplication.keyWindow;
    UIView* maskView = [[UIView alloc] initWithFrame:window.bounds];
    UIView* view = self;
    view.hidden = NO;
    
    maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    maskView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    view.x = UGScreenW;
    [maskView addSubview:view];
    [window addSubview:maskView];
    
    [UIView animateWithDuration:0.35 animations:^{
        view.x = self.oldFrame.origin.x;
    } completion:^(BOOL finished) {
        
    }];
 
    // 刷新余额、即时注单、今日输赢等信息
    [self refreshBalance:nil];
}

- (void)hiddenSelf {
    UIView* view = self;
    self.superview.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.35 animations:^{
        //        view.x = UGScreenW;
        self.superview.x = UGScreenW - self.oldFrame.size.width;
    } completion:^(BOOL finished) {
        [view.superview removeFromSuperview];
        [view removeFromSuperview];
    }];
}

- (void)didSelectCellWithTitle:(NSString *)title {
    if ([title isEqualToString:@"返回首页"]) {
        if (self.backToHomeBlock)
            self.backToHomeBlock();
    }
    else if ([title hasPrefix:@"当前版本号("]) {
        [[UGAppVersionManager shareInstance] updateVersionApi:true];
    }
   
    else if ([title isEqualToString:@"充值"]) {
        UGFundsViewController *fundsVC = [[UGFundsViewController alloc] init];
        fundsVC.selectIndex = 0;
        [NavController1 pushViewController:fundsVC animated:true];
    }
    else if ([title isEqualToString:@"提现"]) {
        UGFundsViewController *fundsVC = [[UGFundsViewController alloc] init];
        fundsVC.selectIndex = 1;
        [NavController1 pushViewController:fundsVC animated:true];
    }
    else if ([title isEqualToString:@"退出登录"]) {
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
  
    
}

- (void)didSelectCellWitModel:(GameModel *)modle {
    
    if (modle.subId == 30 ) {
      if (self.backToHomeBlock)
                 self.backToHomeBlock();
    }
    else{
        if (modle.list) {
            modle.subId = modle.list.subId;
        }
        [NavController1 pushViewControllerWithGameModel:modle];
    }
}

@end

