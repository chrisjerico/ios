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


@property (weak, nonatomic) IBOutlet UIButton *myButton;            /**<   GPK版去会员中心*/

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;    /**<   头像*/


@property (nonatomic, strong) NSMutableArray <NSString *> *titleArray;
@property (nonatomic, strong) NSMutableArray <NSString *> *imageNameArray;

@property (nonatomic, strong) NSMutableArray <GameModel *> *tableArray;
@end

static NSString *menuCellid = @"UGYYRightMenuTableViewCell";

@implementation UGYYRightMenuView

-(void)initTitleAndImgs{
    
    if (Skin1.isGPK) {
        [self titleArrayAndimageNameArrayInit];
        
        NSArray *arrayTmp = @[@"提现", @"充值"];
        // NSMakeRange(1, 2)：1表示要插入的位置，2表示插入数组的个数
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, 2)];
        [_titleArray insertObjects:arrayTmp atIndexes:indexSet];
        
        NSArray *arrayImg = @[@"BMchongzhi", @"BMtixian"];
        [_imageNameArray insertObjects:arrayImg atIndexes:indexSet];
        
    } else {
        [self titleArrayAndimageNameArrayInit];
    }
    
    if ([@"c008,c049" containsString:APP.SiteId]) {
        NSArray *arrayTmp = @[@"在线客服"];
        // NSMakeRange(1, 2)：1表示要插入的位置，2表示插入数组的个数
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(4, 1)];
        [_titleArray insertObjects:arrayTmp atIndexes:indexSet];
        
        NSArray *arrayImg = @[@"jd_message"];
        [_imageNameArray insertObjects:arrayImg atIndexes:indexSet];
    }
    
    if ([@"c126" containsString:APP.SiteId]) {
        NSArray *arrayTmp = @[@"开奖网"];
        // NSMakeRange(1, 2)：1表示要插入的位置，2表示插入数组的个数
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(5, 1)];
        [_titleArray insertObjects:arrayTmp atIndexes:indexSet];
        
        NSArray *arrayImg = @[@"cb_kaijiang"];
        [_imageNameArray insertObjects:arrayImg atIndexes:indexSet];
    }
    if ([@"c217" containsString:APP.SiteId]) {
        NSArray *arrayTmp = @[@"红包记录",@"扫雷记录",@"任务中心"];
        // NSMakeRange(1, 2)：1表示要插入的位置，2表示插入数组的个数
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(7, 3)];
        [_titleArray insertObjects:arrayTmp atIndexes:indexSet];
        
        NSArray *arrayImg = @[@"cbl_hongbao",@"cbl_saolei",@"lixibao"];
        [_imageNameArray insertObjects:arrayImg atIndexes:indexSet];
    }


}


-(void)titleArrayAndimageNameArrayInit{
    
    NSString *str1;NSString *str2;
    if (UGLoginIsAuthorized()) {//已经登录
        str1 = [NSString stringWithFormat:@"即时注单(%@)",[UGUserModel currentUser].unsettleAmount];
        str2 = [NSString stringWithFormat:@"今日输赢(%@)",[UGUserModel currentUser].todayWinAmount];
    }
    else{
        str1 = @"即时注单";
        str2 = @"今日输赢";
    }
    UGUserModel *user = [UGUserModel currentUser];
    NSString *app_Version = [NSString stringWithFormat:@"当前版本号(%@)", APP.Version] ;
    if ([self.titleType isEqualToString:@"1"]) {
        if ([@"h005" containsString:APP.SiteId]) {
            if (UGLoginIsAuthorized()) {//已经登录
                self.titleArray = [[NSMutableArray alloc] initWithObjects:@"返回首页",@"站内信",@"优惠活动",@"退出登录",app_Version, nil] ;
                self.imageNameArray = [[NSMutableArray alloc] initWithObjects:@"home",@"zhanneixin",@"礼品-(1)",@"tuichudenglu",@"appVicon", nil] ;
            }
            else{
                self.titleArray = [[NSMutableArray alloc] initWithObjects:@"返回首页",@"站内信",@"优惠活动",app_Version, nil] ;
                self.imageNameArray = [[NSMutableArray alloc] initWithObjects:@"home",@"zhanneixin",@"礼品-(1)",@"appVicon", nil] ;
            }
        }
        else if (user.yuebaoSwitch) {
            if (UGLoginIsAuthorized()) {//已经登录
                self.titleArray = [[NSMutableArray alloc] initWithObjects:@"返回首页",str1,str2,@"投注记录",@"开奖记录",@"长龙助手",@"利息宝",@"站内信",@"退出登录",app_Version, nil] ;
                self.imageNameArray = [[NSMutableArray alloc] initWithObjects:@"home",@"gw",@"qk1",@"tzjl",@"kaijiangjieguo",@"changlong",@"lixibao",@"zhanneixin",@"tuichudenglu",@"appVicon", nil] ;
            }
            else{
                self.titleArray = [[NSMutableArray alloc] initWithObjects:@"返回首页",str1,str2,@"投注记录",@"开奖记录",@"长龙助手",@"利息宝",@"站内信",app_Version, nil] ;
                self.imageNameArray = [[NSMutableArray alloc] initWithObjects:@"home",@"gw",@"qk1",@"tzjl",@"kaijiangjieguo",@"changlong",@"lixibao",@"zhanneixin",@"appVicon", nil] ;
            }
            
        } else {
            if (UGLoginIsAuthorized()) {//已经登录
                self.titleArray = [[NSMutableArray alloc] initWithObjects:@"返回首页",str1,str2,@"投注记录",@"开奖记录",@"长龙助手",@"站内信",@"退出登录",app_Version, nil] ;
                self.imageNameArray = [[NSMutableArray alloc] initWithObjects:@"home",@"gw",@"qk1",@"tzjl",@"kaijiangjieguo",@"changlong",@"zhanneixin",@"tuichudenglu",@"appVicon", nil] ;
            }
            else{
                self.titleArray = [[NSMutableArray alloc] initWithObjects:@"返回首页",str1,str2,@"投注记录",@"开奖记录",@"长龙助手",@"站内信",app_Version, nil] ;
                self.imageNameArray = [[NSMutableArray alloc] initWithObjects:@"home",@"gw",@"qk1",@"tzjl",@"kaijiangjieguo",@"changlong",@"zhanneixin",@"appVicon", nil] ;
            }
        }
        
    }
    else  if([self.titleType isEqualToString:@"2"]){
        
        if (user.yuebaoSwitch) {
            if (UGLoginIsAuthorized()) {//已经登录
                self.titleArray = [[NSMutableArray alloc] initWithObjects:@"返回首页",str1,str2,@"投注记录",@"开奖记录",@"彩种规则",@"长龙助手",@"红包记录",@"扫雷记录",@"利息宝",@"站内信",@"退出登录", app_Version,nil] ;
                self.imageNameArray = [[NSMutableArray alloc] initWithObjects:@"home",@"gw",@"qk1",@"tzjl",@"kaijiangjieguo",@"gantanhao",@"changlong",@"cbl_hongbao",@"cbl_saolei",@"lixibao",@"zhanneixin",@"tuichudenglu",@"appVicon", nil] ;
            }
            else{
                self.titleArray = [[NSMutableArray alloc] initWithObjects:@"返回首页",str1,str2,@"投注记录",@"开奖记录",@"彩种规则",@"长龙助手",@"红包记录",@"扫雷记录",@"利息宝",@"站内信", app_Version,nil] ;
                self.imageNameArray = [[NSMutableArray alloc] initWithObjects:@"home",@"gw",@"qk1",@"tzjl",@"kaijiangjieguo",@"gantanhao",@"changlong",@"cbl_hongbao",@"cbl_saolei",@"lixibao",@"zhanneixin",@"appVicon", nil] ;
            }
            
        }
        else{
            if (UGLoginIsAuthorized()) {//已经登录
                self.titleArray = [[NSMutableArray alloc] initWithObjects:@"返回首页",str1,str2,@"投注记录",@"开奖记录",@"彩种规则",@"长龙助手",@"红包记录",@"扫雷记录",@"站内信",@"退出登录", app_Version,nil] ;
                self.imageNameArray = [[NSMutableArray alloc] initWithObjects:@"home",@"gw",@"qk1",@"tzjl",@"kaijiangjieguo",@"gantanhao",@"changlong",@"cbl_hongbao",@"cbl_saolei",@"zhanneixin",@"tuichudenglu",@"appVicon", nil] ;
            }
            else{
                self.titleArray = [[NSMutableArray alloc] initWithObjects:@"返回首页",str1,str2,@"投注记录",@"开奖记录",@"彩种规则",@"长龙助手",@"红包记录",@"扫雷记录",@"站内信", app_Version,nil] ;
                self.imageNameArray = [[NSMutableArray alloc] initWithObjects:@"home",@"gw",@"qk1",@"tzjl",@"kaijiangjieguo",@"gantanhao",@"changlong",@"cbl_hongbao",@"cbl_saolei",@"zhanneixin",@"appVicon", nil] ;
            }
            
        }
        
    }
    else{
        if (user.yuebaoSwitch) {
            if (UGLoginIsAuthorized()) {//已经登录
                self.titleArray = [[NSMutableArray alloc] initWithObjects:@"返回首页",str1,str2,@"投注记录",@"开奖记录",@"长龙助手",@"红包记录",@"扫雷记录",@"利息宝",@"站内信",@"退出登录",app_Version, nil] ;
                self.imageNameArray = [[NSMutableArray alloc] initWithObjects:@"home",@"gw",@"qk1",@"tzjl",@"kaijiangjieguo",@"changlong",@"cbl_hongbao",@"cbl_saolei",@"lixibao",@"zhanneixin",@"tuichudenglu",@"appVicon", nil] ;
            }
            else{
                self.titleArray = [[NSMutableArray alloc] initWithObjects:@"返回首页",str1,str2,@"投注记录",@"开奖记录",@"长龙助手",@"红包记录",@"扫雷记录",@"利息宝",@"站内信",app_Version, nil] ;
                self.imageNameArray = [[NSMutableArray alloc] initWithObjects:@"home",@"gw",@"qk1",@"tzjl",@"kaijiangjieguo",@"changlong",@"cbl_hongbao",@"cbl_saolei",@"lixibao",@"zhanneixin",@"appVicon", nil] ;
            }
            
        } else {
            if (UGLoginIsAuthorized()) {//已经登录
                self.titleArray = [[NSMutableArray alloc] initWithObjects:@"返回首页",str1,str2,@"投注记录",@"开奖记录",@"长龙助手",@"红包记录",@"扫雷记录",@"站内信",@"退出登录",app_Version, nil] ;
                self.imageNameArray = [[NSMutableArray alloc] initWithObjects:@"home",@"gw",@"qk1",@"tzjl",@"kaijiangjieguo",@"changlong",@"cbl_hongbao",@"cbl_saolei",@"zhanneixin",@"tuichudenglu",@"appVicon", nil] ;
            }
            else{
                self.titleArray = [[NSMutableArray alloc] initWithObjects:@"返回首页",str1,str2,@"投注记录",@"开奖记录",@"长龙助手",@"红包记录",@"扫雷记录",@"站内信",app_Version, nil] ;
                self.imageNameArray = [[NSMutableArray alloc] initWithObjects:@"home",@"gw",@"qk1",@"tzjl",@"kaijiangjieguo",@"changlong",@"cbl_hongbao",@"cbl_saolei",@"zhanneixin",@"appVicon", nil] ;
            }
            
        }
    }
}

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
       
        [self setBalanceLabel];
        self.headImageView.layer.cornerRadius = self.headImageView.height / 2 ;
        self.headImageView.layer.masksToBounds = YES;
        
        self.tableArray = [NSMutableArray new];
        
        WeakSelf;
        SANotificationEventSubscribe(UGNotificationGetUserInfoComplete, self, ^(typeof (self) self, id obj) {
            [weakSelf.refreshButton.layer removeAllAnimations];
            [weakSelf setBalanceLabel];

            
            [self getTableData];

        });
        
        SANotificationEventSubscribe(UGNotificationUserAvatarChanged, self, ^(typeof (self) self, id obj) {
            [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[UGUserModel currentUser].avatar] placeholderImage:[UIImage imageNamed:@"BMprofile"]];
        });
        
        SANotificationEventSubscribe(UGNotificationloginTimeout, self, ^(typeof (self) self, id obj) {
            [self hiddenSelf];
        });
        
        [self getTableData];
        
    }
    return self;
    
}

-(void)getTableData{
    if (APP.isWebRightMenu) {
        [self tableDataAction ];
    } else {
        [self initTitleAndImgs ];
        [self.tableView reloadData];
    }
    
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
    WeakSelf;
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
            [weakSelf.refreshButton.layer removeAllAnimations];
            [weakSelf setBalanceLabel];
            [weakSelf tableDataAction ];
        } failure:^(id msg) {
            [self.refreshButton.layer removeAllAnimations];
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }];
}

-(IBAction)showMMemberCenterView{
    NSLog(@"tap");
    if (Skin1.isGPK) {
        [self hiddenSelf];
        [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGBMMemberCenterViewController") animated:YES];
    }
}

- (void)setTitleType:(NSString *)titleType {
    _titleType = titleType;
    [self setBalanceLabel];
    
    [self getTableData];
}

-(void)setBalanceLabel{
//    CGFloat floatValues = [[UGUserModel currentUser].balance floatValue];
//
//    NSString *str = [NSString stringWithFormat:@"%.2f",floatValues];

     self.balanceLabel.text  = [NSString stringWithFormat:@"¥%@",[UGUserModel currentUser].balance];
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
        SANotificationEventPost(UGNotificationGetUserInfo, nil);
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
    [self didSelectCellWithTitle:@"充值"];
}

- (IBAction)withdraw:(id)sender {
    [self hiddenSelf];
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
    if (APP.isWebRightMenu) {
        return self.tableArray.count;
    } else {
        return self.titleArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (APP.isWebRightMenu) {
        GameModel *model = [self.tableArray objectAtIndex:indexPath.row];
           UGYYRightMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:menuCellid forIndexPath:indexPath];
          
           cell.imageName = model.icon;
           
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
    } else {
        UGYYRightMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:menuCellid forIndexPath:indexPath];
        cell.title = self.titleArray[indexPath.row];
        cell.imageName = self.imageNameArray[indexPath.row];
        
        NSString *title = [self.titleArray objectAtIndex:indexPath.row];
        if ([title isEqualToString:@"长龙助手"]) {
            [cell letArrowHidden];
        }
        else if([title isEqualToString:@"利息宝"]) {
            [cell letArrowHidden];
        }
        else{
            [cell letIconHidden];
        }
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self hiddenSelf];
    if (APP.isWebRightMenu) {
          GameModel *model = [self.tableArray objectAtIndex:indexPath.row];
          model.realGameId = self.gameId;
          [self didSelectCellWitModel:model];
    } else {
          [self didSelectCellWithTitle:[self.titleArray objectAtIndex:indexPath.row]];
    }
  
}

- (void)show {
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
        if (APP.isWebRightMenu) {
            [_bg2View setHidden:YES];
        } else {
            [_bg2View setHidden:NO];
        }
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
    else if ([title isEqualToString:@"彩种规则"]) {
        UGLotteryRulesView *rulesView = [[UGLotteryRulesView alloc] initWithFrame:CGRectMake(30, 120, UGScreenW - 60, UGScerrnH - 230)];
        rulesView.gameId = self.gameId;
        [rulesView show];
    }
    else if ([title containsString:@"即时注单"]) {
        UGBetRecordViewController *betRecordVC = [[UGBetRecordViewController alloc] init];
        betRecordVC.selectIndex = 2;
        [NavController1 pushViewController:betRecordVC animated:true];
    }
    else if ([title containsString:@"今日输赢" ]) {
        UGBetRecordViewController *betRecordVC = [[UGBetRecordViewController alloc] init];
        [NavController1 pushViewController:betRecordVC animated:true];
    }
    else if ([title isEqualToString:@"投注记录" ]) {
        [NavController1 pushViewController:[UGBetRecordViewController new] animated:true];
    }
    else if ([title isEqualToString:@"开奖记录" ]) {
        UGLotteryRecordController *recordVC = _LoadVC_from_storyboard_(@"UGLotteryRecordController");
        recordVC.gameId = self.gameId;
        [NavController1 pushViewController:recordVC animated:true];
    }
    else if ([title isEqualToString:@"长龙助手"]) {
        [NavController1 pushViewController:[UGChangLongController new] animated:true];
    }
    else if ([title isEqualToString:@"站内信"]) {
        [NavController1 pushViewController:[[UGMailBoxTableViewController alloc] init] animated:true];
    }
    else if ([title isEqualToString:@"利息宝"]) {
        [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGYubaoViewController") animated:true];
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
    else if ([title isEqualToString:@"优惠活动"]) {
        [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGPromotionsController") animated:YES];
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
    else if ([title isEqualToString:@"换肤"]) {
        [NavController1 pushViewController:[UGSkinViewController new] animated:true];
    }
    else if ([title isEqualToString:@"在线客服"]) {
        // 在线客服
        [NavController1 pushVCWithUserCenterItemType:UCI_在线客服];
    }
    else if ([title isEqualToString:@"红包记录"]) {
        RedEnvelopeVCViewController *recordVC = _LoadVC_from_storyboard_(@"RedEnvelopeVCViewController");
        recordVC.type = 1;
        [NavController1 pushViewController:recordVC animated:true];
    }
    else if ([title isEqualToString:@"扫雷记录"]) {
        RedEnvelopeVCViewController *recordVC = _LoadVC_from_storyboard_(@"RedEnvelopeVCViewController");
        recordVC.type = 2;
        [NavController1 pushViewController:recordVC animated:true];
    }
    
    else if ([title isEqualToString:@"开奖网"]) {
        [CMCommon goSLWebUrl:lotteryUrl];
    }
    else if ([title isEqualToString:@"任务中心"]) {
        [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGMissionCenterViewController")  animated:YES];
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

