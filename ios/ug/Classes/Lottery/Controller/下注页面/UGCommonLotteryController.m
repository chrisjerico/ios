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
@interface UGCommonLotteryController (CC)
@property (nonatomic) UITableView *tableView;
@property (nonatomic) UIView *bottomView;
@property (nonatomic) IBOutlet UILabel *nextIssueLabel;
@property (nonatomic) IBOutlet UILabel *closeTimeLabel;
@property (nonatomic) IBOutlet UILabel *openTimeLabel;
@end


@implementation UGCommonLotteryController

- (BOOL)允许游客访问 { return true; }

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTitleView];
    
    FastSubViewCode(self.view);
    {
        // 背景色
        self.view.backgroundColor = Skin1.textColor4;
        if (!APP.betBgIsWhite) {
            [self.view insertSubview:({
                UIView *bgView = [[UIView alloc] initWithFrame:APP.Bounds];
                bgView.backgroundColor = [Skin1.skitString containsString:@"六合"] ? Skin1.navBarBgColor : Skin1.bgColor;
                bgView;
            }) atIndex:0];
        }
        
        // 左侧玩法栏背景色
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.separatorColor = [UIColor clearColor];
        
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
            [CMCommon goSLWebUrl:lotteryUrl];
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
    }
    

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.shoulHideHeader) {
        [self hideHeader];
    }
    
//    if (self.navigationController.viewControllers.count > 1){
//        [CMCommon hideTabBar];
//    }
//    else{
//        [CMCommon showTabBar];
//    }
    

}

- (void)viewDidAppear:(BOOL)animated:(BOOL)animated {
    [super viewDidAppear:animated];
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

        if (self.navigationController.viewControllers.count > 1){
            self.navigationItem.leftBarButtonItem = item;
        }
        else{
            self.navigationItem.leftBarButtonItem = nil;
        }
        

    }
    
    // 设置标题
    STBarButtonItem *item0 = [STBarButtonItem barButtonItemWithTitle:_NSString(@"%@ ▼", self.nextIssueModel.title ? : @"") target:self action:@selector(onTitleClick)];
    self.navigationItem.leftBarButtonItems = @[self.navigationItem.leftBarButtonItems.firstObject, item0];
    self.navigationItem.titleView = [UIView new];   // 隐藏标题
    
    if (OBJOnceToken(self)) {
        [self.navigationItem cc_hookSelector:@selector(setTitle:) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> ai) {
            NSString *title = ai.arguments.lastObject;
            [(UIButton *)item0.customView setTitle:_NSString(@"%@ ▼", title) forState:UIControlStateNormal];
            [(UIButton *)item0.customView sizeToFit];
        } error:nil];
    }
}

- (void)onTitleClick {
    UGLotterySelectController * vc = [UGLotterySelectController new];
    vc.didSelectedItemBlock = ^(UGNextIssueModel *nextModel) {
        [NavController1 pushViewControllerWithNextIssueModel:nextModel];
    };
    UGNavigationController * nav = [[UGNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:true completion:nil];
}

@end
