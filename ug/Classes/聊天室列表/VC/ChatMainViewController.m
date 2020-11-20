//
//  ChatMainViewController.m
//  UGBWApp
//
//  Created by andrew on 2020/11/17.
//  Copyright © 2020 ug. All rights reserved.
//

#import "ChatMainViewController.h"
#import "XYYSegmentControl.h"
#import "UGRechargeTypeTableViewController.h"
#import "UGFundsViewController.h"
#import "LotteryBetAndChatVC.h"
#import "RoomChatModel.h"
#import "ChatListViewController.h"

@interface ChatMainViewController ()
@property (retain, nonatomic)  ChatListViewController *view1;//群组
@property (retain, nonatomic)  UGChatViewController *view2;//会话
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) NSString*mtitle;
@end

@implementation ChatMainViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)允许未登录访问 { return false; }
- (BOOL)允许游客访问 { return true; }


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
    self.mtitle =   @"聊天室列表";
    [self setVCTitle:self.mtitle];
    [self buildSegment];
}
- (void)buildSegment
{
    FastSubViewCode(self.view);
    WeakSelf;
    //设置tab 背景颜色(可选)
    if ([Skin1.skitString isEqualToString:@"经典 1蓝色"]) {
        subView(@"组背景View").backgroundColor = RGBA(174, 203, 223, 1) ;
        [subButton(@"群组Button") setTitleColor:[UIColor whiteColor] forState:0];
        [subButton(@"会话Button") setTitleColor:[UIColor whiteColor] forState:0];
        [subButton(@"充值Button") setTitleColor:[UIColor blackColor] forState:0];
        [subButton(@"提现Button") setTitleColor:[UIColor blackColor] forState:0];
        [subButton(@"投注区Button") setTitleColor:[UIColor blackColor] forState:0];
        subLabel(@"线1Label").backgroundColor = [UIColor whiteColor];
        subLabel(@"线2Label").backgroundColor = [UIColor whiteColor];
    }
    else{
        subView(@"组背景View").backgroundColor = Skin1.CLBgColor ;
        [subButton(@"群组Button") setTitleColor:Skin1.textColor1 forState:0];
        [subButton(@"会话Button") setTitleColor:Skin1.textColor1 forState:0];
        [subButton(@"充值Button") setTitleColor:[UIColor redColor] forState:0];
        [subButton(@"提现Button") setTitleColor:[UIColor redColor] forState:0];
        [subButton(@"投注区Button") setTitleColor:[UIColor redColor] forState:0];
        subLabel(@"线1Label").backgroundColor = Skin1.textColor2;
        subLabel(@"线2Label").backgroundColor = Skin1.textColor2;
    }
   
    
    _view1 = _LoadVC_from_storyboard_(@"ChatListViewController");
    //列表点击事件
    _view1.chatListelectBlock = ^(RoomChatModel * _Nonnull chat) {
        weakSelf.view2.roomId = chat.roomId;
        weakSelf.view2.url = [APP chatGameUrl:chat.roomId hide:YES];
        [weakSelf.contentView bringSubviewToFront:weakSelf.view2.view];
        [subLabel(@"线1Label") setHidden:YES];
        [subLabel(@"线2Label") setHidden:NO];
         weakSelf.mtitle = chat.roomName;
        [weakSelf setVCTitle:weakSelf.mtitle];
     
    };
    _view2 = [[UGChatViewController alloc] init];
    _view2.hideHead = YES;
    if ([CMCommon hasLastRoom]) {
        NSDictionary *dic = [CMCommon LastRoom];
        _view2.roomId = dic[@"roomId"];
        _view2.url = [APP chatGameUrl:dic[@"roomId"] hide:YES];
        weakSelf.mtitle = dic[@"roomName"];
        [self setVCTitle:weakSelf.mtitle];
    }
    else{
        _view2.roomId = SysChatRoom.defaultChatRoom.roomId;
        _view2.url = [APP chatGameUrl:SysChatRoom.defaultChatRoom.roomId hide:YES];
         weakSelf.mtitle = SysChatRoom.defaultChatRoom.roomName;
        [self setVCTitle:weakSelf.mtitle];
    }
    [self addChildViewController:_view1];
    [self addChildViewController:_view2];
    [_contentView addSubview:_view2.view];
    [_contentView addSubview:_view1.view];
    [_view1.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_contentView);
    }];
    [_view2.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_contentView);
    }];
    //群组放到最前面
    [_contentView bringSubviewToFront:_view1.view];
    [subLabel(@"线1Label") setHidden:NO];
    [subLabel(@"线2Label") setHidden:YES];
    

    [subButton(@"群组Button") removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
    [subButton(@"群组Button") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
        [weakSelf.contentView bringSubviewToFront:weakSelf.view1.view];
        [subLabel(@"线1Label") setHidden:NO];
        [subLabel(@"线2Label") setHidden:YES];
        
    }];
    [subButton(@"会话Button") removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
    [subButton(@"会话Button") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
        [weakSelf.contentView bringSubviewToFront:weakSelf.view2.view];
        [subLabel(@"线1Label") setHidden:YES];
        [subLabel(@"线2Label") setHidden:NO];
        [self setVCTitle:weakSelf.mtitle];
    }];
    [subButton(@"充值Button") removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
    [subButton(@"充值Button") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
        
        UGFundsViewController *fundsVC = _LoadVC_from_storyboard_(@"UGFundsViewController");
        fundsVC.selectIndex = 0;
        [NavController1 pushViewController:fundsVC animated:true];
    }];
    [subButton(@"提现Button") removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
    [subButton(@"提现Button") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
        UGFundsViewController *fundsVC = _LoadVC_from_storyboard_(@"UGFundsViewController");
        fundsVC.selectIndex = 1;
        [NavController1 pushViewController:fundsVC animated:true];
    }];
    [subButton(@"投注区Button") removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
    [subButton(@"投注区Button") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
        LotteryBetAndChatVC * chat = [LotteryBetAndChatVC new];
        chat.selectChat = YES;
        [NavController1 pushViewController:chat animated:YES];
    }];

}


-(void)setVCTitle:(NSString *)str{
    self.navigationItem.title  = str;
}

@end
