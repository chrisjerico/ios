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
#import "LotteryBetAndChatVC.h"

// View
#import "STBarButtonItem.h"
#import "CMTimeCommon.h"

#import "UGLotteryHistoryModel.h"
#import "category.h"

#import "MGSlider.h"
#import "UIButton+touch.h"

#import "UGBetDetailView.h"
#import "YNBetDetailView.h"
#import "YNHLPrizeDetailView.h"
#import "UGLotteryRightMenuView.h"
#import "YBPopupMenu.h"
#import "CMLabelCommon.h"


@interface UIButton (customSetEnable)
-(void)customSetEnable:(BOOL)enabled;

@end

@interface UGCommonLotteryController ()<YBPopupMenuDelegate,UITextFieldDelegate>{
    
}
@end
@interface UGCommonLotteryController (CC)<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic) UITableView *tableView;


@property (nonatomic) IBOutlet UILabel *nextIssueLabel;/**<   下期开奖label */
@property (nonatomic) IBOutlet UILabel *currentIssueLabel;            /**<   当前期数Label */
@property (nonatomic) IBOutlet UILabel *closeTimeLabel;
@property (nonatomic) IBOutlet UILabel *openTimeLabel;/**<   开奖时间Label */

@property (nonatomic) IBOutlet UIStackView *rightStackView;/**<右边内容*/

@property (nonatomic) UIView *iphoneXBottomView;/**<iphoneX的t底部*/
@property (nonatomic) UITableView *headerTabView;
@property (nonatomic) NSMutableArray <UGLotteryHistoryModel *> *dataArray;/**<   历史开奖数据*/
@property (nonatomic) UGNextIssueModel *nextIssueModel;
@property (nonatomic) UIView *headerMidView;/**<头 中*/

@property ( nonatomic) IBOutlet UIButton *historyBtn;
@property (nonatomic) UICollectionView *betCollectionView;      /**<   下注号码CollectionView */

@property (nonatomic, strong) UGLotteryRightMenuView  *yymenuView;

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

- (BOOL)允许游客访问 { return true; }


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
    
    [self.view bringSubviewToFront:self.iphoneXBottomView];
    //修复点击澳门六合彩，进入彩种页面，点击长龙助手后，点击返回按钮，回到彩种页面，底部菜单栏出现导致不能正常投注
    if (self.navigationController.viewControllers.count > 1) {
        self.tabBarController.tabBar.hidden = YES;
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    FastSubViewCode(self.view);
    self.fd_interactivePopDisabled = YES;
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetGengHaoBtn) name:@"resetGengHaoBtn"object:nil];

    [self setupTitleView];
    // 下注view
    [self lotteryViewInit];
    // 拉条view
    [self lotterySliderViewInit];
    
    //分Views
    if (![self.nextIssueModel.gameType isEqualToString:@"ofclvn_hochiminhvip"]
        && ![self.nextIssueModel.gameType isEqualToString:@"ofclvn_haboivip"])
    {
        UIStackView *contentstackView = (UIStackView *)subView(@"内容stackView");
        [contentstackView addArrangedSubview:self.lotterySliderView];
        [self.lotterySliderView setHidden:YES];
        
        [contentstackView addArrangedSubview:self.lotteryView];
        [self.lotteryView setHidden:YES];
    }
   

    
    //views颜色
    [self setViewColors];
    //各种事件
    [self allFunction];
    // 处理期数太长被遮挡问题
    self.currentIssueLabel.numberOfLines = 0;
    if (self.currentIssueLabel.cc_constraints.width) {
        self.currentIssueLabel.cc_constraints.width.constant = 100;
    } else {
        [self.currentIssueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(100);
        }];
    }
    //筹码 TKL封盘
    if ([self.nextIssueModel.gameType isEqualToString:@"ofclvn_hochiminhvip"]
        || [self.nextIssueModel.gameType isEqualToString:@"ofclvn_haboivip"]) {
        [self.lotteryView setHidden:YES];
    } else {
        [self.lotteryView setHidden:NO];
        //筹码
        _bargainingView = _LoadView_from_nib_(@"UGBargainingView");
        [self.view  addSubview:_bargainingView];
        [self.bargainingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.lotteryView.mas_top).mas_offset(10);
            make.left.equalTo(self.lotteryView.mas_left).mas_offset(20);
            make.height.mas_equalTo(45);
            make.width.mas_equalTo(235);
        }];
        
        self.bargainingView.itemSelectBlock = ^(HelpDocModel * _Nonnull item) {
            if (![CMCommon stringIsNull:item.btnTitle]) {
                float n1 = [CMCommon floatForNSString:subTextField(@"TKL下注TxtF").text];
                float n2 = [CMCommon floatForNSString:item.btnTitle];
                float sum = n1 + n2;
                subTextField(@"TKL下注TxtF").text = [NSString stringWithFormat:@"%.2f",sum];
            }
        };
        if (Skin1.isTKL
            && ![self.nextIssueModel.gameType isEqualToString:@"ofclvn_hochiminhvip"]
            && ![self.nextIssueModel.gameType isEqualToString:@"ofclvn_haboivip"])
        {
            //添加封盘
            {
                self.mTKLFPView = [[TKLFPView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
                [self.mTKLFPView setHidden:YES];
                [self.view addSubview:self.mTKLFPView];
                [self.view bringSubviewToFront:self.mTKLFPView];
            }
            
        }
    }
  
}

-(void)lotteryViewInit{
    __weakSelf_(__self);
    self.lotteryView = _LoadView_from_nib_(@"LotteryView");
    FastSubViewCode(self.lotteryView)
    [subButton(@"TKL机选btn") removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
    [subButton(@"TKL机选btn") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
        [__self randomNumber];
    }];
    [subButton(@"TKL追号btn") removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
    [subButton(@"TKL追号btn") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
        if ([CMCommon hasGengHao:__self.nextIssueModel.gameId]) {
            NSDictionary *lastGengHao = [CMCommon LastGengHao];
            NSMutableArray *objArray = [UGGameBetModel mj_objectArrayWithKeyValuesArray:lastGengHao[@"array"]];
            [__self goUGBetDetailViewObjArray:objArray dicArray:lastGengHao[@"array"] issueModel:__self.nextIssueModel gameType:lastGengHao[@"gameId"] selCode:lastGengHao[@"selCode"]];
        }
    }];
    [subButton(@"TKL重置Button") removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
    [subButton(@"TKL重置Button") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
        [__self resetClick :sender];
    }];
    [subButton(@"TKL下注Button") removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
    [subButton(@"TKL下注Button") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
        [__self betClick :sender];
    }];
    [subButton(@"TKL筹码Btn") removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
    [subButton(@"TKL筹码Btn") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
        sender.selected = !sender.selected;
        [__self.bargainingView setHidden:sender.selected];
    }];
    
    [self.lotteryView setGameId:self.nextIssueModel.gameId];
    subTextField(@"TKL下注TxtF").delegate = self;
    [self.lotteryView reloadData:^(BOOL succ) {}];
}

-(void)lotterySliderViewInit{
    __weakSelf_(__self);
    self.lotterySliderView = _LoadView_from_nib_(@"LotterySliderView");
    self.lotterySliderView.reloadlock = ^(void) {
        [__self.betCollectionView reloadData];
    };
 
}

-(void)setViewColors{
    FastSubViewCode(self.view)
    // 背景色
    self.view.backgroundColor = Skin1.textColor4;
    
    if (!APP.betBgIsWhite) {
        [self.view insertSubview:({
            UIView *bgView = [[UIView alloc] initWithFrame:APP.Bounds];
            bgView.backgroundColor = ({
                UIColor *bgColor = [@"六合资料" containsString:Skin1.skitType] ? Skin1.navBarBgColor : Skin1.bgColor;
                if (APP.isLight)
                    bgColor = [bgColor colorWithAlphaComponent:0.8];
                bgColor;
            });
            bgView;
        }) atIndex:0];
    }
    
    
    float borderWidth = APP.borderWidthTimes * 0.5;
    UIColor* borderColor;
    if (Skin1.isBlack||Skin1.is23||Skin1.isGPK) {
        borderColor = Skin1.textColor3;
    } else {
        
        if (APP.betBgIsWhite && !Skin1.isGPK && !Skin1.isBlack && !Skin1.is23) {
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
    [subLabel(@"期数label") setTextColor:APP.betBgIsWhite ? Skin1.textColor1 : [UIColor whiteColor]];
    [subLabel(@"聊天室label") setTextColor:APP.betBgIsWhite ? Skin1.textColor1 : [UIColor whiteColor]];
    
    self.nextIssueLabel.textColor = APP.betBgIsWhite ? Skin1.textColor1 : [UIColor whiteColor];
    self.closeTimeLabel.textColor = APP.betBgIsWhite ? Skin1.textColor1 : [UIColor whiteColor];
    self.openTimeLabel.textColor = APP.betBgIsWhite ? Skin1.textColor1 : [UIColor whiteColor];
    // iphoneX的t底部背景色
    [self.iphoneXBottomView setBackgroundColor:Skin1.bgColor];
    [self.iphoneXBottomView insertSubview:({
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP.Width, 200)];
        bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        bgView;
    }) atIndex:0];

    if (APP.isTextWhite) {
        [subLabel(@"封盘Label") setTextColor:[UIColor whiteColor]];
    }
    [self setSelectLabelLableCololr];
}

-(void)allFunction{
    __weakSelf_(__self);
    FastSubViewCode(self.view);
    [subButton(@"长龙btn") removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
    [subButton(@"长龙btn") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
        [NavController1 pushViewController:[UGChangLongController new] animated:true];
    }];
    [subButton(@"直播btn") removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
    [subButton(@"直播btn") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
        NSString *url = [NSString stringWithFormat:@"%@%@&&gameType=%@",liveUrl,__self.gameId,__self.nextIssueModel.gameType];
        [CMCommon goSLWebUrl:url];
    }];
    [subButton(@"开奖btn") removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
    [subButton(@"开奖btn") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
        NSString *url = [NSString stringWithFormat:@"%@%@",lotteryByIdUrl,__self.gameId];
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
        NSString *url = [NSString stringWithFormat:@"%@%@",lotteryByIdUrl,__self.gameId];
        [CMCommon goSLWebUrl:url];
    }];
    
    [subButton(@"金杯2btn") setHidden:!APP.isShowOtherJinbei];
    [subButton(@"金杯2btn") removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
    [subButton(@"金杯2btn") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
        NSString *url = [NSString stringWithFormat:@"%@%@",lotteryByIdUrl,__self.gameId];
        [CMCommon goSLWebUrl:url];
    }];
    

    
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
        
        if ([__self.nextIssueModel.gameType isEqualToString:@"ofclvn_hochiminhvip"]) {//胡志明
            //去下注详细
            [__self getNextIssueDataForYN];
        }
        else if ([__self.nextIssueModel.gameType isEqualToString:@"ofclvn_haboivip"]) {//河内
            //去下注详细
            [__self getNextIssueDataForYN];
        }
        else {
            if (sender.selected) { // 按下去了就是明文
                __self.headerMidView.hidden = NO;
            } else { // 暗文
                __self.headerMidView.hidden = YES;
            }
            [__self getLotteryHistory];
        }
        
        
    }];
    
    [subImageView(@"开奖喇叭ImgV") setHidden:YES];
    
    
    if (APP.isReplaceIcon) {
        [subButton(@"长龙btn") setBackgroundImage: [UIImage imageNamed:@"kjw_long"] forState:(UIControlStateNormal)];
        [subButton(@"直播btn") setBackgroundImage: [UIImage imageNamed:@"kjw_tv"]  forState:(UIControlStateNormal)];
        [subButton(@"开奖btn") setBackgroundImage: [UIImage imageNamed:@"kjw_01"]  forState:(UIControlStateNormal)];
    }
    
    if (Skin1.isTKL) {
        subLabel(@"截止投注label").cc_constraints.width.constant  = self.nextIssueLabel.cc_constraints.width.constant;
        subLabel(@"截止投注label").cc_constraints.left.constant  = 5;
        [subLabel(@"截止投注label") setHidden:NO];
        [self.openTimeLabel setHidden:YES];
    } else {
        subLabel(@"截止投注label").cc_constraints.width.constant  = 0;
        subLabel(@"截止投注label").cc_constraints.left.constant  = 0;
        [subLabel(@"截止投注label") setHidden:YES];
        [self.openTimeLabel setHidden:NO];
    }
}

-(void)setSelectLabelLableCololr{
    FastSubViewCode(self.lotteryView)
    if (Skin1.isBlack||Skin1.is23||Skin1.isGPK) {
        [CMLabelCommon setRichNumberWithLabel:subLabel(@"TKL已选中label") Color:RGBA(83, 162, 207, 1) FontSize:15.0];
    }
    else {
        if (APP.isYellow) {
            [CMLabelCommon setRichNumberWithLabel:subLabel(@"TKL已选中label") Color:RGBA(247, 211, 72, 1)  FontSize:15.0];
        }
        else if(APP.isRed)
        {
            [CMLabelCommon setRichNumberWithLabel:subLabel(@"TKL已选中label") Color:[UIColor redColor] FontSize:15.0];
        }
        else{
            [CMLabelCommon setRichNumberWithLabel:subLabel(@"TKL已选中label") Color:RGBA(247, 211, 72, 1) FontSize:15.0];
        }
        
    }
}

- (void)updateCloseLabel {
    if (APP.isTextWhite) {
        return;
    }
    if (self.closeTimeLabel.text.length) {
        
        NSMutableAttributedString *abStr = [[NSMutableAttributedString alloc] initWithString:self.closeTimeLabel.text];
        
        if (Skin1.isTKL) {
            [abStr addAttribute:NSFontAttributeName
                          value:[UIFont boldSystemFontOfSize:22]
                          range:NSMakeRange(0, self.closeTimeLabel.text.length - 0)];
            [abStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, self.closeTimeLabel.text.length - 0)];
        }
        else{
            [abStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(3, self.closeTimeLabel.text.length - 3)];
        }
        self.closeTimeLabel.attributedText = abStr;
    }
}

- (void)updateCloseLabelText{
    
    NSString *timeStr = [CMCommon getNowTimeWithEndTimeStr:self.nextIssueModel.curCloseTime currentTimeStr:self.nextIssueModel.serverTime];
    FastSubViewCode(self.view)
    if (self.nextIssueModel.isSeal || timeStr == nil) {
        timeStr = @"封盘中";
        
        self.lotteryView.closeView.hidden = NO;
        if (subView(@"ync封盘View")) {
            subView(@"ync封盘View").hidden = NO;
        }
        
        [self resetClick:nil];
        
        if (Skin1.isTKL) {
            
            if (!self.mTKLFPView.isClosed) {
                [self.mTKLFPView setHidden:NO];
                subLabel(@"内容label").text = [NSString stringWithFormat:@"%@已封盘",self.selectTitle];
                [CMLabelCommon messageSomeAction:subLabel(@"内容label") changeString:@"已封盘" andMarkColor:[UIColor redColor] andMarkFondSize:17];
            }
            
        }
    } else {
        self.lotteryView.closeView.hidden = YES;
        if (subView(@"ync封盘View")) {
            subView(@"ync封盘View").hidden = YES;
        }
        if (Skin1.isTKL) {
            [self.mTKLFPView setHidden:YES];
        }
    }
    if (Skin1.isTKL) {
        self.closeTimeLabel.text = timeStr;
    } else {
        self.closeTimeLabel.text = [NSString stringWithFormat:@"封盘:%@",timeStr];
    }
    
    [self updateCloseLabel];
}

-(void)showSliderAction{
    if (SysConf.activeReturnCoinStatus) {//是否開啟拉條模式
       
        [self.lotterySliderView setHidden:NO];
    } else {
        [self.lotterySliderView setHidden:YES];
    }
    
    if ([self.nextIssueModel.gameType isEqualToString:@"ofclvn_hochiminhvip"] || [self.nextIssueModel.gameType isEqualToString:@"ofclvn_haboivip"]) {
        [self.lotterySliderView setHidden:YES];
    }
}

// 获取系统配置
- (void)getSystemConfig {
    WeakSelf;
    //    [SVProgressHUD showWithStatus:nil];
    [CMNetwork getSystemConfigWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
            NSLog(@"model = %@",model);
            FastSubViewCode(weakSelf.view);
            UGSystemConfigModel *config = model.data;
            UGSystemConfigModel.currentConfig = config;
            
            if ([self.nextIssueModel.gameType isEqualToString:@"ofclvn_hochiminhvip"] || [self.nextIssueModel.gameType isEqualToString:@"ofclvn_haboivip"]) {
            } else {
                [self showSliderAction];
            }
            
        } failure:^(id msg) {
            //			[SVProgressHUD showErrorWithStatus:msg];
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
   
    // 设置返回按钮
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [backButton setImage:[UIImage imageNamed:@"c_navi_back"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"c_navi_back"] forState:UIControlStateHighlighted];
    [backButton sizeToFit];
    [backButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {

         [NavController1 popViewControllerAnimated:true];
        
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
    
    
    NSLog(@"self.nextIssueModel.title = %@",self.nextIssueModel.title);
    self.selectTitle = self.nextIssueModel.title;
    
    
}

#pragma mark -- 点击切换
- (void)onTitleClick {
    
    NSLog(@"title = %@",self.nextIssueModel.title);
    NSLog(@"selectTitle = %@",self.selectTitle);
    NSLog(@"nextIssueModel = %@",self.nextIssueModel);
    
    if (APP.isNewLotteryView) {
        
        self.yymenuView = [[UGLotteryRightMenuView alloc] initWithFrame:CGRectMake(UGScreenW /2 , 0, UGScreenW * 2/ 3, UGScerrnH)];
        
        self.yymenuView.selectTitle = self.selectTitle;
        self.yymenuView.gameType = self.nextIssueModel.gameType;
        self.yymenuView.didSelectedItemBlock = ^(UGNextIssueModel *nextModel) {
            [NavController1 pushViewControllerWithNextIssueModel:nextModel isChatRoom:NO];
        };
        [self.yymenuView show];
    }
    else{
        UGLotterySelectController * vc = [UGLotterySelectController new];
        vc.didSelectedItemBlock = ^(UGNextIssueModel *nextModel) {
            [NavController1 pushViewControllerWithNextIssueModel:nextModel isChatRoom:NO];
        };
        UGNavigationController * nav = [[UGNavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:true completion:nil];
    }
    
    
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
    
    WeakSelf;
    [CMNetwork ticketgetLotteryFirstOrderWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        
        
        [CMResult processWithResult:model success:^{
            
            weakSelf.zuiHaoIssueModel = (UGNextIssueModel *)model.data;
            
            
            
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }];
    
    
}

- (void)updateSelectLabelWithCount:(NSInteger)count {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // UI更新代码
        FastSubViewCode(self.lotteryView)
        subLabel(@"TKL已选中label").text = [NSString stringWithFormat:@"已选中%ld注",count];
        [self setSelectLabelLableCololr];
    });
    
    
}

//去开奖详情
- (void)getNextIssueDataForYN {
    NSDictionary *params = @{@"id":self.gameId};
    WeakSelf;
    [SVProgressHUD showWithStatus:nil];
    [CMNetwork getNextIssueWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
            if ([CMCommon stringIsNull:model.data]) {
                [SVProgressHUD showSuccessWithStatus:model.msg];
            } else {
                [SVProgressHUD dismiss];
                UGNextIssueModel *nextIssueModel = model.data;
                if ([weakSelf.nextIssueModel.gameType isEqualToString:@"ofclvn_hochiminhvip"]) {//胡志明
                    YNHLPrizeDetailView*betDetailView = [[YNHLPrizeDetailView alloc] init];
                    betDetailView.nextIssueModel = nextIssueModel;
                    betDetailView.selCode = [Global getInstanse].selCode;
                    betDetailView.isHeNeiView = NO;
                    [betDetailView show];
                }
                else if ([weakSelf.nextIssueModel.gameType isEqualToString:@"ofclvn_haboivip"]) {//河内
                    
                    YNHLPrizeDetailView *betDetailView = [[YNHLPrizeDetailView alloc] init];
                    betDetailView.nextIssueModel = nextIssueModel;
                    betDetailView.selCode = [Global getInstanse].selCode;
                    betDetailView.isHeNeiView = YES;
                    [betDetailView show];
                }
            }
            
        } failure:^(id msg) {
            [SVProgressHUD dismiss];
        }];
    }];
}

//调用下注界面
-(void)goUGBetDetailViewObjArray:(NSArray *)objArray   dicArray:(NSArray *)dicArray issueModel:(UGNextIssueModel *)issueModel gameType:(NSString  *)gameId selCode:(NSString *)selCode{
    
    if ([CMCommon arryIsNull:objArray]) {
        [self.navigationController.view makeToast:@"请选择玩法" duration:1.5 position:CSToastPositionCenter];
        return ;
    }

    self.nextIssueModel.title = self.selectTitle;
    
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


//调用越南彩下注界面
-(void)goYNBetDetailViewObjArray:(NSArray *)objArray   dicArray:(NSArray *)dicArray issueModel:(UGNextIssueModel *)issueModel gameType:(NSString  *)gameId selCode:(NSString *)selCode  isHide:(BOOL )isHide{
    
    if ([CMCommon arryIsNull:objArray]) {
        [self.navigationController.view makeToast:@"请选择玩法" duration:1.5 position:CSToastPositionCenter];
        return ;
    }
    
    
    YNBetDetailView *betDetailView = [[YNBetDetailView alloc] init];
    betDetailView.isHide = isHide;
    betDetailView.dataArray = objArray;
    betDetailView.nextIssueModel = self.nextIssueModel;
    betDetailView.code = selCode;
    
    WeakSelf
    betDetailView.betClickBlock = ^{
        [weakSelf resetClick:nil];
    };
    betDetailView.cancelBlock = ^{
        
        [weakSelf resetClick:nil];
    };
    [betDetailView show];
    
}

-(void)resetGengHaoBtn{
    [self.lotteryView setGameId:self.nextIssueModel.gameId];
}

- (void)button: (UIButton *)button setEnable: (BOOL)enable {
    button.alpha = enable ? 1.0 : 0.3;
    [button setEnabled:enable];
}
//连码玩法数据处理
- (void)handleData{
    
}

// 重置
- (IBAction)resetClick:(id)sender {
    FastSubViewCode(self.lotteryView)
    [subTextField(@"TKL下注TxtF") resignFirstResponder];
    subTextField(@"TKL下注TxtF").text = @"";
    [self updateSelectLabelWithCount:0];
}
// 下注
- (IBAction)betClick:(id)sender {
    FastSubViewCode(self.view)
    [subTextField(@"TKL下注TxtF") resignFirstResponder];
}

//机选
-(void)randomNumber {
    
    [self resetClick:nil];
    NSIndexPath * lastPath;
    NSInteger sectionTotalCount = [self numberOfSectionsInCollectionView:self.betCollectionView];
    NSUInteger sectionCount = [self minSectionsCountForBet];
    NSMutableSet * sectionSet = [NSMutableSet setWithCapacity: sectionCount];
    while (sectionSet.count < sectionCount) {
        NSInteger radomSection = arc4random()%sectionTotalCount;
        [sectionSet addObject:[NSNumber numberWithInteger:radomSection]];
    }
    
    for (NSNumber *sectionNumber in sectionSet) {
        NSUInteger itemsCountInSection =  [self collectionView:self.betCollectionView numberOfItemsInSection:sectionNumber.integerValue];
        NSUInteger minItemsCountInsection = [self minItemsCountForBetIn:sectionNumber.integerValue];
        NSMutableSet * itemSet = [NSMutableSet setWithCapacity: sectionCount];
        while (itemSet.count<minItemsCountInsection) {
            NSInteger radomItemNumberInSection = arc4random()%itemsCountInSection;
            [itemSet addObject:[NSNumber numberWithInteger:radomItemNumberInSection]];
        }
        for (NSNumber *itemNumber in itemSet) {
            NSIndexPath * path = [NSIndexPath indexPathForItem:itemNumber.integerValue inSection:sectionNumber.integerValue];
            [self collectionView:self.betCollectionView didSelectItemAtIndexPath: path];
            lastPath = path;
            
        }
    }
    
    if (self.betCollectionView.contentSize.height > self.betCollectionView.bounds.size.height) {
        [self.betCollectionView layoutIfNeeded];
        [self.betCollectionView scrollToItemAtIndexPath:lastPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:true];
    }
    
    
}

- (NSUInteger)minSectionsCountForBet {
    return 1;
}
- (NSUInteger)minItemsCountForBetIn:(NSUInteger)section {
    return 1;
}

#pragma mark - textField delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        FastSubViewCode(self.view)
        [subTextField(@"TKL下注TxtF") resignFirstResponder];
        return NO;
    }
    return YES;
}
@end


@implementation UIButton(customSetEnable)
- (void)customSetEnable:(BOOL)enable {
    self.alpha = enable ? 1.0 : 0.3;
    [self setEnabled:enable];
}

@end
