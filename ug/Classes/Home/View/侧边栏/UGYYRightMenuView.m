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
#import "UINavigationController+UGExtension.h"
#import "UGSkinViewController.h"
#import "UGAppVersionManager.h"

@interface UGYYRightMenuView ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) CGRect oldFrame;

@property (nonatomic, assign) BOOL refreshing;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIView *rechargeView;
@property (weak, nonatomic) IBOutlet UIView *withdrawlView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImgeView;
@property (weak, nonatomic) IBOutlet UIImageView *icon1ImgeView;
@property (weak, nonatomic) IBOutlet UIImageView *icon2ImageView;

@property (nonatomic, strong) NSMutableArray <NSString *> *titleArray;
@property (nonatomic, strong) NSMutableArray <NSString *> *imageNameArray;
@end

static NSString *menuCellid = @"UGYYRightMenuTableViewCell";

@implementation UGYYRightMenuView

-(void)initTitleAndImgs{
    
      NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
      NSString *app_Version = [NSString stringWithFormat:@"当前版本号(%@)", [infoDictionary objectForKey:@"CFBundleShortVersionString"]] ;
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
      if ([self.titleType isEqualToString:@"1"]) {
          
          if (user.yuebaoSwitch) {
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
                   self.titleArray = [[NSMutableArray alloc] initWithObjects:@"返回首页",str1,str2,@"投注记录",@"开奖记录",@"彩种规则",@"长龙助手",@"利息宝",@"站内信",@"退出登录", app_Version,nil] ;
                   self.imageNameArray = [[NSMutableArray alloc] initWithObjects:@"home",@"gw",@"qk1",@"tzjl",@"kaijiangjieguo",@"gantanhao",@"changlong",@"lixibao",@"zhanneixin",@"tuichudenglu",@"appVicon", nil] ;
               }
               else{
                   self.titleArray = [[NSMutableArray alloc] initWithObjects:@"返回首页",str1,str2,@"投注记录",@"开奖记录",@"彩种规则",@"长龙助手",@"利息宝",@"站内信", app_Version,nil] ;
                   self.imageNameArray = [[NSMutableArray alloc] initWithObjects:@"home",@"gw",@"qk1",@"tzjl",@"kaijiangjieguo",@"gantanhao",@"changlong",@"lixibao",@"zhanneixin",@"appVicon", nil] ;
               }
              
          }
          else{
              if (UGLoginIsAuthorized()) {//已经登录
                  self.titleArray = [[NSMutableArray alloc] initWithObjects:@"返回首页",str1,str2,@"投注记录",@"开奖记录",@"彩种规则",@"长龙助手",@"站内信",@"退出登录", app_Version,nil] ;
                  self.imageNameArray = [[NSMutableArray alloc] initWithObjects:@"home",@"gw",@"qk1",@"tzjl",@"kaijiangjieguo",@"gantanhao",@"changlong",@"zhanneixin",@"tuichudenglu",@"appVicon", nil] ;
              }
              else{
                  self.titleArray = [[NSMutableArray alloc] initWithObjects:@"返回首页",str1,str2,@"投注记录",@"开奖记录",@"彩种规则",@"长龙助手",@"站内信", app_Version,nil] ;
                  self.imageNameArray = [[NSMutableArray alloc] initWithObjects:@"home",@"gw",@"qk1",@"tzjl",@"kaijiangjieguo",@"gantanhao",@"changlong",@"zhanneixin",@"appVicon", nil] ;
              }
            
          }
         
      }
      else{
             if (user.yuebaoSwitch) {
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
        self.balanceLabel.text = [NSString stringWithFormat:@"¥%@",[[UGUserModel currentUser].balance removeFloatAllZero]];
		
		

        SANotificationEventSubscribe(UGNotificationGetUserInfoComplete, self, ^(typeof (self) self, id obj) {
            [self.refreshButton.layer removeAllAnimations];
            self.balanceLabel.text = [NSString stringWithFormat:@"¥%@",[UGUserModel currentUser].balance];
            
            NSLog(@"todayWinAmount = %@",[UGUserModel currentUser].todayWinAmount);
            NSLog(@"unsettleAmount = %@",[UGUserModel currentUser].unsettleAmount);
			
            [self initTitleAndImgs ];
            
            [self.tableView reloadData];
        });
        
        
        SANotificationEventSubscribe(UGNotificationloginTimeout, self, ^(typeof (self) self, id obj) {
            [self hiddenSelf];
        });
       
         [self initTitleAndImgs ];
        
    }
    return self;
    
}

- (void)setTitleType:(NSString *)titleType {
    _titleType = titleType;

    self.balanceLabel.text = [NSString stringWithFormat:@"¥%@",[UGUserModel currentUser].balance];
    
    [self initTitleAndImgs ];
    
    [self.tableView reloadData];
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
 
     }
     else{
         [_userNameLabel setHidden:YES];
         [_balanceLabel setHidden:YES];
         [_refreshButton setHidden:YES];
         [subButton(@"登入按钮") setHidden:NO];
         [subButton(@"免费开户按钮") setHidden:NO];
         [subButton(@"登入按钮") removeActionBlocksForControlEvents:UIControlEventTouchUpInside];
         [subButton(@"登入按钮") handleControlEvents:UIControlEventTouchUpInside actionBlock:^(__kindof UIControl *sender) {
            [self hiddenSelf];
            //登录
            [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGBMLoginViewController") animated:true];
         }];
         [subButton(@"免费开户按钮") removeActionBlocksForControlEvents:UIControlEventTouchUpInside];
         [subButton(@"免费开户按钮") handleControlEvents:UIControlEventTouchUpInside actionBlock:^(__kindof UIControl *sender) {
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
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
    [self didSelectCellWithTitle:[self.titleArray objectAtIndex:indexPath.row]];
}

- (void)show {
    [self.rechargeView setBackgroundColor:Skin1.navBarBgColor];
    [self.withdrawlView setBackgroundColor:Skin1.navBarBgColor];
    
    [self.bgView setBackgroundColor:Skin1.menuHeadViewColor];
    
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
    else if ([title isEqualToString:_NSString(@"当前版本号(%@)", [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"])]) {
		[[UGAppVersionManager shareInstance] updateVersionApi:true];
	}
    else if ([title isEqualToString:@"彩种规则"]) {
        UGLotteryRulesView *rulesView = [[UGLotteryRulesView alloc] initWithFrame:CGRectMake(30, 120, UGScreenW - 60, UGScerrnH - 230)];
        rulesView.gameId = self.gameId;
        rulesView.gameName = self.gameName;
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
        [NavController1 pushViewController:[[UGMailBoxTableViewController alloc] initWithStyle:UITableViewStyleGrouped] animated:true];
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
   else if ([title isEqualToString:@"退出登录"]) {
       [QDAlertView showWithTitle:@"温馨提示" message:@"确定退出账号" cancelButtonTitle:@"取消" otherButtonTitle:@"确定" completionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
           if (buttonIndex) {
               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                   SANotificationEventPost(UGNotificationUserLogout, nil);
               });
           }
       }];
   }
   else if ([title isEqualToString:@"换肤"]) {
       [NavController1 pushViewController:[UGSkinViewController new] animated:true];
   }
}

@end

