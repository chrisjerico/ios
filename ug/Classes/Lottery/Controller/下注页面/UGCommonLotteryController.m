//
//  UGCommonLotteryController.m
//  ug
//
//  Created by xionghx on 2019/10/1.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGCommonLotteryController.h"
#import "UGLotterySelectController.h"
#import "UGChangLongController.h"
// View
#import "STBarButtonItem.h"
#import "CMTimeCommon.h"

#import "UGLotteryHistoryModel.h"
#import "category.h"
@interface UGCommonLotteryController (CC)
@property (nonatomic) UITableView *tableView;
@property (nonatomic) UIView *bottomView;
@property (nonatomic) IBOutlet UILabel *nextIssueLabel;
@property (nonatomic) IBOutlet UILabel *closeTimeLabel;
@property (nonatomic) IBOutlet UILabel *openTimeLabel;

@property (nonatomic) UIView *iphoneXBottomView;/**<iphoneX的t底部*/
@property (nonatomic) UITableView *headerTabView;
@property (nonatomic) NSMutableArray <UGLotteryHistoryModel *> *dataArray;/**<   历史开奖数据*/
@property (nonatomic) UGNextIssueModel *nextIssueModel;
@property (nonatomic) UIView *headerMidView;/**<头 中*/

@property ( nonatomic) IBOutlet UIButton *historyBtn;
@end


@implementation UGCommonLotteryController

- (void)dealloc {
    [_nextIssueCountDown destoryTimer];
    if (_timer) {
        if ([_timer isValid]) {
            [_timer invalidate];
            _timer = nil;
        }
    }
    if (_path) {
        _path = nil;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    
    if (self.shoulHideHeader) {
        [self hideHeader];
        [self.historyBtn setEnabled:NO];
    }
    else{
         [self.historyBtn setEnabled:YES];
    }
    [self getSystemConfig];     // APP配置信息
    
    
}
- (BOOL)允许游客访问 { return true; }

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTitleView];
    
    
    
    FastSubViewCode(self.view);
    {
        // 背景色
        //        if ([Skin1.skitString isEqualToString:@"黑色模板香槟金"]) {
        //             self.view.backgroundColor = Skin1.bgColor;
        //        } else {
        self.view.backgroundColor = Skin1.textColor4;
        //        }
        
        if (!APP.betBgIsWhite) {
            [self.view insertSubview:({
                UIView *bgView = [[UIView alloc] initWithFrame:APP.Bounds];
                if (APP.isLight) {
                    bgView.backgroundColor = [Skin1.skitString containsString:@"六合"] ? [Skin1.navBarBgColor colorWithAlphaComponent:0.8] :[Skin1.bgColor colorWithAlphaComponent:0.8];
                }
                else{
                    bgView.backgroundColor = [Skin1.skitString containsString:@"六合"] ? Skin1.navBarBgColor : Skin1.bgColor;
                }
                
                bgView;
            }) atIndex:0];
        }
        
        // 左侧玩法栏背景色
        
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.separatorColor = [UIColor clearColor];
        
        if (APP.isGrey) {
            self.tableView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
            self.tableView.separatorColor = [UIColor whiteColor];
        }
        
        if (APP.isRedWhite) {
            self.tableView.backgroundColor = RGBA(242, 242, 242, 1.0);
            self.tableView.separatorColor = RGBA(231, 213, 231, 1.0);
        }
        
        // 顶部栏背景色
        [subView(@"上背景View") setBackgroundColor:[UIColor clearColor]];
        [subView(@"中间View") setBackgroundColor:[UIColor clearColor]];
        subLabel(@"线label").hidden = true;
        self.nextIssueLabel.textColor = APP.betBgIsWhite ? Skin1.textColor1 : [UIColor whiteColor];
        self.closeTimeLabel.textColor = APP.betBgIsWhite ? Skin1.textColor1 : [UIColor whiteColor];
        self.openTimeLabel.textColor = APP.betBgIsWhite ? Skin1.textColor1 : [UIColor whiteColor];
        
        // 底部栏背景色
        [self.bottomView setBackgroundColor:Skin1.bgColor];
        [self.bottomView insertSubview:({
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP.Width, 200)];
            bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
            bgView;
        }) atIndex:0];
        // iphoneX的t底部背景色
        [self.iphoneXBottomView setBackgroundColor:Skin1.bgColor];
        [self.iphoneXBottomView insertSubview:({
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP.Width, 200)];
            bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
            bgView;
        }) atIndex:0];
        
        [subLabel(@"期数label") setTextColor:APP.betBgIsWhite ? Skin1.textColor1 : [UIColor whiteColor]];
        [subLabel(@"聊天室label") setTextColor:APP.betBgIsWhite ? Skin1.textColor1 : [UIColor whiteColor]];
        
        [subButton(@"长龙btn") removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
        [subButton(@"长龙btn") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
            [NavController1 pushViewController:[UGChangLongController new] animated:true];
        }];
        [subButton(@"直播btn") removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
        [subButton(@"直播btn") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
            NSString *url = [NSString stringWithFormat:@"%@%@&&gameType=%@",liveUrl,self.gameId,self.nextIssueModel.gameType];
            [CMCommon goSLWebUrl:url];
        }];
        [subButton(@"开奖btn") removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
        [subButton(@"开奖btn") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
            NSString *url = [NSString stringWithFormat:@"%@%@",lotteryByIdUrl,self.gameId];
            [CMCommon goSLWebUrl:url];
        }];
        
        [subButton(@"长龙btn") setHidden:!APP.addIcons];
        [subButton(@"直播btn") setHidden:!APP.addIcons];
        [subButton(@"开奖btn") setHidden:!APP.addIcons];
        [subButton(@"长龙btn") setBackgroundImage: [[UIImage imageNamed:@"xz_icon_cl"] qmui_imageWithTintColor:[UIColor whiteColor]] forState:(UIControlStateNormal)];
        [subButton(@"直播btn") setBackgroundImage: [[UIImage imageNamed:@"xz_icon_zb"] qmui_imageWithTintColor:[UIColor whiteColor]] forState:(UIControlStateNormal)];
        [subButton(@"开奖btn") setBackgroundImage: [[UIImage imageNamed:@"xz_icon_kj"] qmui_imageWithTintColor:[UIColor whiteColor]] forState:(UIControlStateNormal)];
        
        [subButton(@"聊天Btn") removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
        [subButton(@"聊天Btn") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NSSelectChatRoom" object:nil userInfo:nil];
        }];
        
        
        [subButton(@"金杯btn") setHidden:!APP.isShowJinbei];
        [subButton(@"金杯btn") removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
        [subButton(@"金杯btn") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
            NSString *url = [NSString stringWithFormat:@"%@%@",lotteryByIdUrl,self.gameId];
            [CMCommon goSLWebUrl:url];
        }];
        
        [subButton(@"金杯2btn") setHidden:!APP.isShowOtherJinbei];
        [subButton(@"金杯2btn") removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
        [subButton(@"金杯2btn") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
            NSString *url = [NSString stringWithFormat:@"%@%@",lotteryByIdUrl,self.gameId];
            [CMCommon goSLWebUrl:url];
        }];
        
        if (APP.isTextWhite) {
            [subLabel(@"封盘Label") setTextColor:[UIColor whiteColor]];
        }
        
        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"lotteryHormIsOpen"]) {
            [subImageView(@"开奖喇叭ImgV") setImage:[UIImage imageNamed:@"icon_sound01"]];
        } else {
            [subImageView(@"开奖喇叭ImgV")setImage:[UIImage imageNamed:@"icon_sound02"]];
        }
        
        [subButton(@"声音按钮") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
            sender.selected = !sender.selected;
            
            if (sender.selected) { // 按下去了就不开启
                [subImageView(@"开奖喇叭ImgV")setImage:[UIImage imageNamed:@"icon_sound02"]];
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"lotteryHormIsOpen"];//下注界面喇叭
            } else { // 默认开启
                [subImageView(@"开奖喇叭ImgV") setImage:[UIImage imageNamed:@"icon_sound01"]];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"lotteryHormIsOpen"];//下注界面喇叭
            }
        }];
        
        [subButton(@"历史记录按钮") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
            // 切换按钮的状态
            sender.selected = !sender.selected;
            if (sender.selected) { // 按下去了就是明文
                self.headerMidView.hidden = NO;
            } else { // 暗文
                self.headerMidView.hidden = YES;
            }
            [self getLotteryHistory];
            
        }];
        
        [subImageView(@"开奖喇叭ImgV") setHidden:YES];

        
        if (APP.isReplaceIcon) {
            [subButton(@"长龙btn") setBackgroundImage: [UIImage imageNamed:@"kjw_long"] forState:(UIControlStateNormal)];
            [subButton(@"直播btn") setBackgroundImage: [UIImage imageNamed:@"kjw_tv"]  forState:(UIControlStateNormal)];
            [subButton(@"开奖btn") setBackgroundImage: [UIImage imageNamed:@"kjw_01"]  forState:(UIControlStateNormal)];
        }
        
    }
    
    
}

// 获取系统配置
- (void)getSystemConfig {
    [CMNetwork getSystemConfigWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
            NSLog(@"model = %@",model);
            FastSubViewCode(self.view);
            UGSystemConfigModel *config = model.data;
            UGSystemConfigModel.currentConfig = config;
            if (SysConf.betAmountIsDecimal  == 1) {//betAmountIsDecimal  1=允许小数点，0=不允许，以前默认是允许投注金额带小数点的，默认为1
                [subTextView(@"下注TxtF") set仅数字:false];
                [subTextView(@"下注TxtF") set仅数字含小数:true];
            } else {
                [subTextView(@"下注TxtF") set仅数字:true];
            }
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }];
}




- (void)hideHeader {
    UIImageView * mmcHeader = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mmcbg" ]];
    [self.view addSubview:mmcHeader];
    [mmcHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.equalTo(@114);
    }];
}

- (void)getGameDatas {}

- (void)setupTitleView {
    self.title = @"聊天";
    // 设置返回按钮
    {
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [backButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [backButton setImage:[UIImage imageNamed:@"c_navi_back"] forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"c_navi_back"] forState:UIControlStateHighlighted];
        [backButton sizeToFit];
        [backButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
            UIViewController *vc=  [NavController1 popViewControllerAnimated:true];
            
        }];
        UIView *containView = [[UIView alloc] initWithFrame:backButton.bounds];
        [containView addSubview:backButton];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:containView];
        
        if (self.navigationController.viewControllers.count > 1) {
            self.navigationItem.leftBarButtonItem = item;
        }
        else {
            self.navigationItem.leftBarButtonItem = nil;
        }
    }
    
    // 设置标题
    STBarButtonItem *item0 = [STBarButtonItem barButtonItemWithTitle:_NSString(@"%@ ▼", self.nextIssueModel.title ? : @"") target:self action:@selector(onTitleClick)];
    self.navigationItem.leftBarButtonItems = @[self.navigationItem.leftBarButtonItems.firstObject, item0];
    self.navigationItem.titleView = [UIView new];   // 隐藏标题
#pragma mark - 去掉这里就不会标题变动。
    //    if (OBJOnceToken(self)) {
    //        [self.navigationItem cc_hookSelector:@selector(setTitle:) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> ai) {
    //            NSString *title = ai.arguments.lastObject;
    //            NSLog(@"title = %@",title);
    //            [(UIButton *)item0.customView setTitle:_NSString(@"%@ ▼===", title) forState:UIControlStateNormal];
    //            [(UIButton *)item0.customView sizeToFit];
    //        } error:nil];
    //    }
}

- (void)onTitleClick {
    UGLotterySelectController * vc = [UGLotterySelectController new];
    vc.didSelectedItemBlock = ^(UGNextIssueModel *nextModel) {
        [NavController1 pushViewControllerWithNextIssueModel:nextModel];
    };
    UGNavigationController * nav = [[UGNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:true completion:nil];
}


-(void)playerLotterySound{
    if ([@"c126" containsString:APP.SiteId]) {
        //          [self startWinPlayerFileName:@"lottery" Type:@"wav"];
    } else {
        //        [self startWinPlayerFileName:@"otherLotter" Type:@"wav"];
        
    }
}

/**
 *   播放系统wav格式的音乐
 *  入参：fName ：文件名   tName 文件类型s
 * ：win.wav  https://www.jianshu.com/p/5332823c4674
 */
-(void)startWinPlayerFileName:(NSString *)fName Type:tNmae{
    static SystemSoundID soundIDTest = 0;//当soundIDTest == kSystemSoundID_Vibrate的时候为震动
    self.path = [[NSBundle mainBundle] pathForResource:fName ofType:tNmae];
    if (self.path) {
        AudioServicesCreateSystemSoundID( (__bridge CFURLRef)[NSURL fileURLWithPath:self.path], &soundIDTest );
    }
    AudioServicesPlaySystemSound( soundIDTest );
}


- (void)getLotteryHistory {

    NSString *dataStr = nil;
    if (![self.nextIssueModel.lowFreq isEqualToString:@"1"]) {
        dataStr =  [CMTimeCommon currentDateStringWithFormat:@"yyyy-MM-dd"];
    }
    else{
        dataStr = nil;
    }
    
    NSDictionary *params = @{@"id":self.nextIssueModel.gameId,
                             @"date":dataStr ,
                             };
    [CMNetwork getLotteryHistoryWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [self.tableView.mj_header endRefreshing];
        [CMResult processWithResult:model success:^{
            self.dataArray = [((UGLotteryHistoryListModel *)model.data).list mutableCopy];
            [self.headerTabView reloadData];
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }];
    
}
@end
