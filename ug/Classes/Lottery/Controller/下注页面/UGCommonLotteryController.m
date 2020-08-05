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

#import "MGSlider.h"
#import "UIButton+touch.h"

#import "UGBetDetailView.h"

@interface UGCommonLotteryController (CC)
@property (nonatomic) UITableView *tableView;
@property (nonatomic) UIView *bottomView;
@property (nonatomic) IBOutlet UILabel *nextIssueLabel;
@property (nonatomic) IBOutlet UILabel *closeTimeLabel;
@property (nonatomic) IBOutlet UILabel *openTimeLabel;

@property (nonatomic) IBOutlet UILabel *selectLabel;      /**<   注数Label */
@property (nonatomic) IBOutlet UIView *bottomCloseView;/**<底部  封盘  */
@property (nonatomic) IBOutlet UIStackView *rightStackView;/**<右边内容*/

@property (nonatomic) UIView *iphoneXBottomView;/**<iphoneX的t底部*/
@property (nonatomic) UITableView *headerTabView;
@property (nonatomic) NSMutableArray <UGLotteryHistoryModel *> *dataArray;/**<   历史开奖数据*/
@property (nonatomic) UGNextIssueModel *nextIssueModel;
@property (nonatomic) UIView *headerMidView;/**<头 中*/

@property ( nonatomic) IBOutlet UIButton *historyBtn;
@property (nonatomic) UICollectionView *betCollectionView;      /**<   下注号码CollectionView */
//拖动条=======================================================
@property (strong, nonatomic)  MGSlider *slider;/**<拖动条*/
@property (strong, nonatomic)  UILabel *sliderLB;/**<拖动条 刻度显示*/
@property (strong, nonatomic)  UIButton *reductionBtn;/**<拖动条 -按钮*/
@property (strong, nonatomic)  UIButton *addBtn;/**<拖动条 +按钮*/
@property ( nonatomic) float proportion;/**<拖动条 显示的最大值    来自网络数据*/
@property ( nonatomic) float lattice;/**<拖动条 一格的值  */


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
    
   [[NSNotificationCenter defaultCenter] removeObserver:self name:@"resetGengHaoBtn" object:self];
        [self.nextIssueCountDown destoryTimer];
    NSLog(@"%s dealloc", object_getClassName(self));
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
    
    [self resetGengHaoBtn];
    
}
- (BOOL)允许游客访问 { return true; }

- (void)viewDidLoad {
    [super viewDidLoad];

     self.fd_interactivePopDisabled = YES;
    [self setupTitleView];
    
    //注册通知

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetGengHaoBtn) name:@"resetGengHaoBtn"object:nil];

    __weakSelf_(__self);
    FastSubViewCode(self.view);
    {
        // 背景色
        //        if ([Skin1.skitString isEqualToString:@"GPK版香槟金"]) {
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
        
        
        float borderWidth = APP.borderWidthTimes * 0.5;
        UIColor* borderColor;
        if (Skin1.isBlack||Skin1.is23) {
            borderColor = Skin1.textColor3;
        } else {
            
            if (APP.betBgIsWhite) {
                borderColor =  APP.LineColor;
            } else {
                borderColor =  [[UIColor whiteColor] colorWithAlphaComponent:0.3];
            }
        }

        if (APP.isShowBorder) {
              [CMCommon setBorderWithView:self.rightStackView top:NO left:YES bottom:NO right:YES borderColor:borderColor borderWidth:borderWidth];
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
        subLabel(@"线label").hidden = !APP.isShowBorder;
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
        
        if (Skin1.isBlack||Skin1.is23) {
            [self.selectLabel setTextColor:RGBA(83, 162, 207, 1)];
        } else {
            
            if (APP.isYellow) {
                [self.selectLabel setTextColor:RGBA(247, 211, 72, 1) ];
            }
            else{
                [self.selectLabel setTextColor:RGBA(83, 162, 207, 1)];
            }
            
        }
        
        subButton(@"追号btn").layer.cornerRadius = 5;
        subButton(@"追号btn").layer.masksToBounds = YES;
        
        [subButton(@"追号btn") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
            if ([CMCommon hasGengHao:__self.nextIssueModel.gameId]) {
                NSDictionary *lastGengHao = [CMCommon LastGengHao];
                NSMutableArray *objArray = [UGGameBetModel mj_objectArrayWithKeyValuesArray:lastGengHao[@"array"]];
                [__self goUGBetDetailViewObjArray:objArray dicArray:lastGengHao[@"array"] issueModel:__self.nextIssueModel gameType:lastGengHao[@"gameId"] selCode:lastGengHao[@"selCode"]];
            }
            
        }];

        
    }

  if (OBJOnceToken(self)) {
        [self sliderViewInit ];
  };

    
}
//拖动条
- (void )sliderViewInit {
    
    __weakSelf_(__self);
    self.slider = [[MGSlider alloc] initWithFrame:CGRectMake(150, 5,150 , 50)];
//    self.slider.touchRangeEdgeInsets = UIEdgeInsetsMake(-20, -20, -20, -20);
    self.slider.thumbSize = CGSizeMake(40, 40);//锚点的大小
    self.slider.thumbImage = [UIImage imageNamed:@"icon_activity_ticket_details_rebate"];//锚点的图片
    self.slider.thumbColor = [UIColor clearColor];//锚点的背景色
    self.slider.trackColor = [UIColor colorWithRed:0.29 green:0.42 blue:0.86 alpha:1.00];//进度条的颜色+
    self.slider.untrackColor = [UIColor grayColor];//进度条的颜色-
    self.slider.zoom = NO; // 默认点击放大
    self.slider.progress = 0;// 默认第一次锚点所在的位置，1：100%
    self.slider.margin = 10; // 距离左右内间距
    [[Global getInstanse] setRebate:0.0];//进入界面，初始退水为0
    [self.bottomView addSubview:self.slider];
    [self.slider changeValue:^(CGFloat value) {
        NSLog(@">>>>>>>>>>>>>>>>>>>>>拖动==== %f", value);
        [__self setRebateAndSliderLB:value];
        
    } endValue:^(CGFloat value) {

    }];
    
    
    self.reductionBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.reductionBtn setBackgroundImage:[UIImage imageNamed:@"icon_activity_ticket_details_minus"] forState:(UIControlStateNormal)];
    self.reductionBtn.frame = CGRectMake(20, 200, 50, 50);
    [self.bottomView addSubview:self.reductionBtn];
    [self.reductionBtn addTarget:self  action:@selector(reductionAction:) forControlEvents:(UIControlEventTouchDown)];
    
    
    
    
    self.addBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.addBtn setBackgroundImage:[UIImage imageNamed:@"icon_activity_ticket_details_add"] forState:(UIControlStateNormal)];
    self.addBtn.frame = CGRectMake(350, 200, 50, 50);
    [self.bottomView addSubview:self.addBtn];
    [self.addBtn addTarget:self  action:@selector(addImgVAction:) forControlEvents:(UIControlEventTouchDown)];
    
    
    
    self.sliderLB = [[UILabel alloc] initWithFrame:CGRectMake(150, 250, 200, 50)];
    self.sliderLB.font = [UIFont systemFontOfSize:14.0];
    self.sliderLB.text = @"0.00%";
    self.sliderLB.textColor = [UIColor whiteColor];
    [self.bottomView addSubview:self.sliderLB];
    
    
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) { //数组额你不必须都是view
        
        make.right.equalTo(self.bottomView.mas_right).offset(-10);
        make.height.equalTo([NSNumber numberWithFloat:32]);
        make.width.equalTo([NSNumber numberWithFloat:32]);
        make.top.equalTo([NSNumber numberWithFloat:13]);
    }];

    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) { //数组额你不必须都是view

        make.right.equalTo(self.bottomView.mas_right).offset(-50);
        make.height.equalTo([NSNumber numberWithFloat:50]);
        make.width.equalTo([NSNumber numberWithFloat:120]);
        make.top.equalTo([NSNumber numberWithFloat:5]);
    }];

    [self.reductionBtn mas_makeConstraints:^(MASConstraintMaker *make) { //数组额你不必须都是view
        
        make.right.equalTo(self.bottomView.mas_right).offset(-181);
        make.height.equalTo([NSNumber numberWithFloat:32]);
        make.width.equalTo([NSNumber numberWithFloat:32]);
        make.top.equalTo([NSNumber numberWithFloat:13]);
    }];

    [self.sliderLB mas_makeConstraints:^(MASConstraintMaker *make) { //数组额你不必须都是view
        make.right.equalTo(self.reductionBtn.mas_left).offset(-20);
        make.height.equalTo([NSNumber numberWithFloat:20]);
        make.top.equalTo([NSNumber numberWithFloat:18]);
    }];
    
    [self.bottomView bringSubviewToFront:self.bottomCloseView];
    
    
    [self showSlider:NO];
    [self showSliderAction];
    
}

-(void)setRebateAndSliderLB :(float )value{
    NSString *x =[NSString stringWithFormat:@"%.2f%@",self.lattice * value*100,@"%"];
    [self.sliderLB setText:x];
    
    NSString *rebateStr = [NSString stringWithFormat:@"%.4f",self.lattice * value];
    float rebateF = [rebateStr floatValue];
    [[Global getInstanse] setRebate:rebateF];
    [self.betCollectionView reloadData];
}

-(void)reductionAction:(UIButton *)sender{

    
    if (self.slider.moveProgress> 0) {
        
        self.slider.moveProgress = self.slider.moveProgress - 0.0005;
        self.slider.progress = self.slider.moveProgress;

        [self setRebateAndSliderLB:self.slider.progress];
        
        if (self.slider.progress >0.8) {
            //该控件的bug
            CGRect frame =  self.slider.valveIV.frame;
            if (frame.origin.x >= 90.0) {
                frame.origin.x = 90.0;
                self.slider.valveIV.frame = frame;
            }
            NSLog(@"x= %f",frame.origin.x);
        }
    }

}

-(void)addImgVAction:(UIButton *)sender{

    if (self.slider.moveProgress< 1.0) {
        self.slider.moveProgress = self.slider.moveProgress + 0.0005;
        self.slider.progress = self.slider.moveProgress;
        
        [self setRebateAndSliderLB:self.slider.progress];
        
        if (self.slider.progress >0.8) {
            //该控件的bug
            CGRect frame =  self.slider.valveIV.frame;
            if (frame.origin.x >= 90.0) {
                frame.origin.x = 90.0;
                self.slider.valveIV.frame = frame;
            }
            NSLog(@"x= %f",frame.origin.x);
        }
      
    }

}

// 获取系统配置
- (void)getSystemConfig {
    WeakSelf;
    [CMNetwork getSystemConfigWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
            NSLog(@"model = %@",model);
            FastSubViewCode(weakSelf.view);
            UGSystemConfigModel *config = model.data;
            UGSystemConfigModel.currentConfig = config;
            if (SysConf.betAmountIsDecimal  == 1) {//betAmountIsDecimal  1=允许小数点，0=不允许，以前默认是允许投注金额带小数点的，默认为1
                [subTextView(@"下注TxtF") set仅数字:false];
                [subTextView(@"下注TxtF") set仅数字含小数:true];
            } else {
                [subTextView(@"下注TxtF") set仅数字:true];
            }
            if (SysConf.chaseNumber  == 1) {//追号开关  默认关
                 [subButton(@"追号btn") setHidden:NO];
             } else {
                 [subButton(@"追号btn") setHidden:YES];
             }
            
            
            [weakSelf showSliderAction];
            
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }];
}

-(void)showSliderAction{
    if (SysConf.activeReturnCoinStatus) {//是否開啟拉條模式
        self.proportion = SysConf.activeReturnCoinRatio;
        self.lattice = 0.01 * self.proportion;
        [self showSlider:YES];
    } else {
        [self showSlider:NO];
    }
}
-(void)showSlider:(BOOL)isShow{
    self.slider.hidden = !isShow;
    self.sliderLB.hidden = !isShow;
    self.reductionBtn.hidden = !isShow;
    self.addBtn.hidden = !isShow;
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

    
    // 设置标题
	UIBarButtonItem * item0;
    item0 = [STBarButtonItem barButtonItemWithTitle:_NSString(@"%@ ▼", self.nextIssueModel.title ? : @"") target:self action:@selector(onTitleClick)];
	
	// #101134 【IOS聊天App】投注页面顶部标题空白
	#ifdef isChatAPP
	UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setTitle: [NSString stringWithFormat:@"%@ ▼", self.nextIssueModel.title ? : @""] forState:UIControlStateNormal];
	[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[button addTarget:self action:@selector(onTitleClick)];
	item0 = [[UIBarButtonItem alloc] initWithCustomView:button];
	
	[backButton setImage:[UIImage imageNamed:@"nav_back_black"] forState:UIControlStateNormal];
	[backButton setImage:[UIImage imageNamed:@"nav_back_black"] forState:UIControlStateHighlighted];
	#endif
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
    WeakSelf;
    [CMNetwork getLotteryHistoryWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [weakSelf.tableView.mj_header endRefreshing];
        [CMResult processWithResult:model success:^{
            weakSelf.dataArray = [((UGLotteryHistoryListModel *)model.data).list mutableCopy];
            if (weakSelf.dataArray.count>1) {
                [weakSelf.dataArray removeFirstObject];
                 [weakSelf.headerTabView reloadData];
            }
           
        } failure:^(id msg) {
//            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }];
    
}

- (void)getLotteryFirstOrder {

 
    NSDictionary *params = @{@"id":self.gameId,
                             };
    NSLog(@"self.gameId=%@",self.gameId);
    WeakSelf;
    [CMNetwork ticketgetLotteryFirstOrderWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        
        
        NSLog(@"model= %@",model);
        
        [CMResult processWithResult:model success:^{
           
            weakSelf.zuiHaoIssueModel = (UGNextIssueModel *)model.data;
            
            NSLog(@"zuiHaoIssueModel = %@",weakSelf.zuiHaoIssueModel);
             
           
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }];
    
}

- (void)updateSelectLabelWithCount:(NSInteger)count {
    self.selectLabel.text = [NSString stringWithFormat:@"%ld",count];
   
}

//调用下注界面
-(void)goUGBetDetailViewObjArray:(NSArray *)objArray   dicArray:(NSArray *)dicArray issueModel:(UGNextIssueModel *)issueModel gameType:(NSString  *)gameId selCode:(NSString *)selCode{
    
    if ([CMCommon arryIsNull:objArray]) {
        [self.navigationController.view makeToast:@"请选择玩法" duration:1.5 position:CSToastPositionCenter];
        return ;
    }
    
    
    UGBetDetailView *betDetailView = [[UGBetDetailView alloc] init];
    betDetailView.dataArray = objArray;
    betDetailView.nextIssueModel = self.nextIssueModel;
    betDetailView.code = selCode;
    WeakSelf
    betDetailView.betClickBlock = ^{
        [weakSelf handleData];
        [weakSelf resetClick:nil];
    };
    betDetailView.cancelBlock = ^{
        [weakSelf handleData];
        [weakSelf resetClick:nil];
    };
    [betDetailView show];

}

-(void)resetGengHaoBtn{
    FastSubViewCode(self.view);
    if ([CMCommon hasGengHao:self.nextIssueModel.gameId]) {
        [subButton(@"追号btn") setEnabled:YES];
        [subButton(@"追号btn") setAlpha:1.0];
    } else {
         [subButton(@"追号btn") setEnabled:NO];
         [subButton(@"追号btn") setAlpha:0.3];
    }
}

//连码玩法数据处理
- (void)handleData{
    
}

// 重置
- (IBAction)resetClick:(id)sender {
    
}


@end
