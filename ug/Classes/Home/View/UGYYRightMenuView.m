//
//  UGYYRightMenuView.m
//  ug
//
//  Created by ug on 2019/9/27.
//  Copyright © 2019 ug. All rights reserved.
//


#import "UGYYRightMenuView.h"
#import "UGRightMenuTableViewCell.h"
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

@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *imageNameArray;
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
        SANotificationEventSubscribe(UGNotificationGetUserInfoComplete, self, ^(typeof (self) self, id obj) {
            [self.refreshButton.layer removeAllAnimations];
            self.balanceLabel.text = [NSString stringWithFormat:@"¥%@",[UGUserModel currentUser].balance];
            
            NSLog(@"todayWinAmount = %@",[UGUserModel currentUser].todayWinAmount);
            NSLog(@"unsettleAmount = %@",[UGUserModel currentUser].unsettleAmount);

            NSString *str1 = [NSString stringWithFormat:@"即时注单(%@)",[UGUserModel currentUser].unsettleAmount];
            NSString *str2 = [NSString stringWithFormat:@"今日输赢(%@)",[UGUserModel currentUser].todayWinAmount];
            
            if ([self.titleType isEqualToString:@"1"]) {
                 self.titleArray = [[NSMutableArray alloc] initWithObjects:@"返回首页",str1,str2,@"投注记录",@"开奖记录",@"长龙助手",@"利息宝",@"站内信",@"退出登录", nil] ;
                 self.imageNameArray = [[NSMutableArray alloc] initWithObjects:@"home",@"gw",@"qk1",@"tzjl",@"kaijiangjieguo",@"changlong",@"lixibao",@"zhanneixin",@"huanfu",@"tuichudenglu", nil] ;
            }
            else  if([self.titleType isEqualToString:@"2"]){
                 self.titleArray = [[NSMutableArray alloc] initWithObjects:@"返回首页",str1,str2,@"投注记录",@"开奖记录",@"彩种规则",@"长龙助手",@"利息宝",@"站内信",@"退出登录", nil] ;
                 self.imageNameArray = [[NSMutableArray alloc] initWithObjects:@"home",@"gw",@"qk1",@"tzjl",@"kaijiangjieguo",@"gantanhao",@"changlong",@"lixibao",@"huanfu",@"zhanneixin",@"tuichudenglu", nil] ;
            }
            else{
                self.titleArray = [[NSMutableArray alloc] initWithObjects:@"返回首页",str1,str2,@"投注记录",@"开奖记录",@"长龙助手",@"利息宝",@"站内信",@"退出登录", nil] ;
                self.imageNameArray = [[NSMutableArray alloc] initWithObjects:@"home",@"gw",@"qk1",@"tzjl",@"kaijiangjieguo",@"changlong",@"lixibao",@"zhanneixin",@"huanfu",@"tuichudenglu", nil] ;
            }
            
            [self.tableView reloadData];
            
        });
        
        
        SANotificationEventSubscribe(UGNotificationloginTimeout, self, ^(typeof (self) self, id obj) {
            [self hiddenSelf];
        });
        NSString *str1 = [NSString stringWithFormat:@"即时注单(%@)",[UGUserModel currentUser].unsettleAmount];
        NSString *str2 = [NSString stringWithFormat:@"今日输赢(%@)",[UGUserModel currentUser].todayWinAmount];
        
        if ([self.titleType isEqualToString:@"1"]) {
            self.titleArray = [[NSMutableArray alloc] initWithObjects:@"返回首页",str1,str2,@"投注记录",@"开奖记录",@"长龙助手",@"利息宝",@"站内信",@"退出登录", nil] ;
            self.imageNameArray = [[NSMutableArray alloc] initWithObjects:@"home",@"gw",@"qk1",@"tzjl",@"kaijiangjieguo",@"changlong",@"lixibao",@"zhanneixin",@"tuichudenglu", nil] ;
        }
        else if([self.titleType isEqualToString:@"2"]){
            self.titleArray = [[NSMutableArray alloc] initWithObjects:@"返回首页",str1,str2,@"投注记录",@"开奖记录",@"彩种规则",@"长龙助手",@"利息宝",@"站内信",@"退出登录", nil] ;
            self.imageNameArray = [[NSMutableArray alloc] initWithObjects:@"home",@"gw",@"qk1",@"tzjl",@"kaijiangjieguo",@"gantanhao",@"changlong",@"lixibao",@"zhanneixin",@"tuichudenglu", nil] ;
        }
        else{
            self.titleArray = [[NSMutableArray alloc] initWithObjects:@"返回首页",str1,str2,@"投注记录",@"开奖记录",@"长龙助手",@"利息宝",@"站内信",@"退出登录", nil] ;
            self.imageNameArray = [[NSMutableArray alloc] initWithObjects:@"home",@"gw",@"qk1",@"tzjl",@"kaijiangjieguo",@"changlong",@"lixibao",@"zhanneixin",@"tuichudenglu", nil] ;
        }
        
    }
    return self;
    
}

-(void)setTitleType:(NSString *)titleType{
    _titleType = titleType;
    
    self.balanceLabel.text = [NSString stringWithFormat:@"¥%@",[UGUserModel currentUser].balance];
    
    NSString *str1 = [NSString stringWithFormat:@"即时注单(%@)",[UGUserModel currentUser].unsettleAmount];
    NSString *str2 = [NSString stringWithFormat:@"今日输赢(%@)",[UGUserModel currentUser].todayWinAmount];
    if ([self.titleType isEqualToString:@"1"]) {
        self.titleArray = [[NSMutableArray alloc] initWithObjects:@"返回首页",str1,str2,@"投注记录",@"开奖记录",@"长龙助手",@"利息宝",@"站内信",@"退出登录", nil] ;
        self.imageNameArray = [[NSMutableArray alloc] initWithObjects:@"home",@"gw",@"qk1",@"tzjl",@"kaijiangjieguo",@"changlong",@"lixibao",@"zhanneixin",@"tuichudenglu", nil] ;
    }
    else  if([self.titleType isEqualToString:@"2"]){
        self.titleArray = [[NSMutableArray alloc] initWithObjects:@"返回首页",str1,str2,@"投注记录",@"开奖记录",@"彩种规则",@"长龙助手",@"利息宝",@"站内信",@"退出登录", nil] ;
        self.imageNameArray = [[NSMutableArray alloc] initWithObjects:@"home",@"gw",@"qk1",@"tzjl",@"kaijiangjieguo",@"gantanhao",@"changlong",@"lixibao",@"zhanneixin",@"tuichudenglu", nil] ;
    }
    else{
        self.titleArray = [[NSMutableArray alloc] initWithObjects:@"返回首页",str1,str2,@"投注记录",@"开奖记录",@"长龙助手",@"利息宝",@"站内信",@"退出登录", nil] ;
        self.imageNameArray = [[NSMutableArray alloc] initWithObjects:@"home",@"gw",@"qk1",@"tzjl",@"kaijiangjieguo",@"changlong",@"lixibao",@"zhanneixin",@"tuichudenglu", nil] ;
    }
    
    
    
    [self.tableView reloadData];
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (CGRectContainsPoint(self.bounds, point)) {
        
    }else {
        [self hiddenSelf];
    }
    
    return view;
}

- (IBAction)refreshBalance:(id)sender {
    
    [self startAnimation];
    SANotificationEventPost(UGNotificationGetUserInfo, nil);
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
-(void)startAnimation
{
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
//
//    }
    
    [self hiddenSelf];
    [self didSelectCellWithTitle:[self.titleArray objectAtIndex:indexPath.row]];
    
   
}
- (void)show {
    
    [self.rechargeView setBackgroundColor:UGNavColor];
    [self.withdrawlView setBackgroundColor:UGNavColor];
    
    [self.bgView setBackgroundColor:[[UGSkinManagers shareInstance] setMenuHeadViewColor]];
    
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
 
    UIViewController *viewController = nil;
    if ([title isEqualToString:@"返回首页"]) {
        
        if (self.gotoSeeBlock) {
            self.gotoSeeBlock();
           
        }
//        [[UINavigationController currentNC] popViewControllerAnimated:YES];
      
        return;
    }
    else if ([title isEqualToString:@"彩种规则"]) {
        UGLotteryRulesView *rulesView = [[UGLotteryRulesView alloc] initWithFrame:CGRectMake(30, 120, UGScreenW - 60, UGScerrnH - 230)];
        rulesView.gameId = self.gameId;
        rulesView.gameName = self.gameName;
        [rulesView show];
        
        return;

        
    }
    else if ([title containsString:@"即时注单"]) {
        if ([UGUserModel currentUser].isTest) {
            [QDAlertView showWithTitle:@"温馨提示" message:@"请先登录您的正式账号" cancelButtonTitle:@"取消" otherButtonTitle:@"马上登录" completionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    SANotificationEventPost(UGNotificationShowLoginView, nil);
                }
            }];
        }else {
            
            UGBetRecordViewController *betRecordVC = [[UGBetRecordViewController alloc] init];
            viewController = betRecordVC;
            
        }
        
    }
    else if ([title containsString:@"今日输赢" ]) {
        if ([UGUserModel currentUser].isTest) {
            [QDAlertView showWithTitle:@"温馨提示" message:@"请先登录您的正式账号" cancelButtonTitle:@"取消" otherButtonTitle:@"马上登录" completionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    SANotificationEventPost(UGNotificationShowLoginView, nil);
                }
            }];
        }else {
            
            UGBetRecordViewController *betRecordVC = [[UGBetRecordViewController alloc] init];
            [betRecordVC buildSegment];
            [betRecordVC setSelectIndex:2];
             viewController = betRecordVC;
        }
        
    }
    else if ([title isEqualToString:@"投注记录" ]) {
        if ([UGUserModel currentUser].isTest) {
            [QDAlertView showWithTitle:@"温馨提示" message:@"请先登录您的正式账号" cancelButtonTitle:@"取消" otherButtonTitle:@"马上登录" completionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    SANotificationEventPost(UGNotificationShowLoginView, nil);
                }
            }];
        }else {
            
            UGBetRecordViewController *betRecordVC = [[UGBetRecordViewController alloc] init];

            viewController = betRecordVC;
        }
        
    }
    else if ([title isEqualToString:@"开奖记录" ]) {
        UIStoryboard *storyboad = [UIStoryboard storyboardWithName:@"UGLotteryRecordController" bundle:nil];
        UGLotteryRecordController *recordVC = [storyboad instantiateInitialViewController];
        recordVC.gameId = self.gameId;
        recordVC.lotteryGamesArray = self.lotteryGamesArray;
        viewController = recordVC;
    }
    else if ([title isEqualToString:@"长龙助手"]) {
        
        UGChangLongController *changlongVC = [[UGChangLongController alloc] init];
        changlongVC.lotteryGamesArray = self.lotteryGamesArray;
        viewController = changlongVC;
        
    }
    else if ([title isEqualToString:@"站内信"]) {
        UGMailBoxTableViewController *mailBoxVC = [[UGMailBoxTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        viewController = mailBoxVC;
        
    }
    else if ([title isEqualToString:@"利息宝"]) {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGYubaoViewController" bundle:nil];
        UGYubaoViewController *lixibaoVC = [storyboard instantiateInitialViewController];
         viewController = lixibaoVC;
        
    }
   else if ([title isEqualToString:@"充值"]) {
        if ([UGUserModel currentUser].isTest) {
            [QDAlertView showWithTitle:@"温馨提示" message:@"请先登录您的正式账号" cancelButtonTitle:@"取消" otherButtonTitle:@"马上登录" completionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    SANotificationEventPost(UGNotificationShowLoginView, nil);
                }
            }];
        }else {
            
            UGFundsViewController *fundsVC = [[UGFundsViewController alloc] init];
            fundsVC.selectIndex = 0;
            viewController = fundsVC;
        }
    }
   else if ([title isEqualToString:@"提现"]) {
       if ([UGUserModel currentUser].isTest) {
           [QDAlertView showWithTitle:@"温馨提示" message:@"请先登录您的正式账号" cancelButtonTitle:@"取消" otherButtonTitle:@"马上登录" completionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
               if (buttonIndex == 1) {
                   SANotificationEventPost(UGNotificationShowLoginView, nil);
               }
           }];
       }else {
           
           UGFundsViewController *fundsVC = [[UGFundsViewController alloc] init];
           fundsVC.selectIndex = 1;
           viewController = fundsVC;
       }
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
       if ([UGUserModel currentUser].isTest) {
           [QDAlertView showWithTitle:@"温馨提示" message:@"请先登录您的正式账号" cancelButtonTitle:@"取消" otherButtonTitle:@"马上登录" completionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
               if (buttonIndex == 1) {
                   SANotificationEventPost(UGNotificationShowLoginView, nil);
               }
           }];
       }else {
           
           UGSkinViewController *fundsVC = [[UGSkinViewController alloc] init];
           viewController = fundsVC;
       }
   }
  
    
    
    viewController.title = title;
    [[UINavigationController currentNC] pushViewController:viewController animated:YES];
}



@end

