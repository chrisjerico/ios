//
//  LotteryBetAndChatVC.m
//  ug
//
//  Created by fish on 2020/1/4.
//  Copyright © 2020 ug. All rights reserved.
//

#import "LotteryBetAndChatVC.h"
#import "UGCommonLotteryController.h"
#import "UGChatViewController.h"
#import "UGLotterySelectController.h"

#import "SlideSegmentView1.h"
#import "STBarButtonItem.h"

#import "CMTimeCommon.h"
#import "CCNetworkRequests1+UG.h"
#import "UGbetModel.h"

#import "RememberPass.h"
#import "RoomChatModel.h"
#import "WHC_ModelSqlite.h"

@interface UGCommonLotteryController ()
@property (nonatomic, strong) UITableView *tableView;                   /**<   玩法列表TableView */
@property (nonatomic, strong) UICollectionView *betCollectionView;      /**<   下注号码CollectionView */
@end
@interface UGChatViewController ()
@property (nonatomic, strong) UIButton *closeBtn;
@end



@interface LotteryBetAndChatVC ()

@property (nonatomic) SlideSegmentView1 *ssv1;                  /**<    分页布局View */
@property (nonatomic, strong) UIButton *downBtn;                /**<   下按钮 */

@property (nonatomic, strong) UGCommonLotteryController *vc1;   /**<   下注界面 */
@property (nonatomic, strong) UGChatViewController *vc2;        /**<   聊天界面 */

@property (nonatomic, strong) UILabel *mLabel;                  /**<    */

@property (nonatomic, strong) NSArray *chatAry ;         /**<   聊天室数据*/

@property (nonatomic, strong) NSMutableDictionary *jsDic ;         /**<   分享数据*/
@end


@implementation LotteryBetAndChatVC

- (BOOL)允许游客访问 { return true; }

-(void)showLeeView{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.title = @"聊天室";
    
    if (!self.title) {
        self.title = @"聊天室";;
    }
    if (!_nim) {
        
        if ([@"c084" containsString:APP.SiteId]) {
            UGNextIssueModel * oc = [UGNextIssueModel new];
            oc.gameId = @"164";
            oc.gameType = @"lhc";
            oc.name = @"jslhc";
            oc.title = @"分分六合彩";
            _nim = oc;
        }
        else if ([@"c208" containsString:APP.SiteId]) {
            UGNextIssueModel * oc = [UGNextIssueModel new];
            oc.gameId = @"78";
            oc.gameType = @"lhc";
            oc.name = @"lhc";
            oc.title = @"一分六合彩";
            _nim = oc;
        }
        else if ([@"c217" containsString:APP.SiteId]) {
            UGNextIssueModel * oc = [UGNextIssueModel new];
            oc.gameId = @"98";
            oc.gameType = @"pk10";
            oc.name = @"pk10";
            oc.title = @"极速赛车";
            _nim = oc;
        }
        else {
            UGNextIssueModel * oc = [UGNextIssueModel new];
            oc.gameId = @"70";
            oc.gameType = @"lhc";
            oc.name = @"lhc";
            oc.title = @"香港六合彩";
            _nim = oc;
        }
        
    }
    
    __weakSelf_(__self);
    [self xw_addNotificationForName:@"NSSelectChatRoom" block:^(NSNotification *notification) {
        __self.ssv1.selectedIndex = 1;
    }];
    [self xw_addNotificationForName:@"NSSelectChatRoom_share" block:^(NSNotification *notification) {
        NSLog(@"收到通知1：%@", notification.userInfo);
        NSDictionary *da = (NSDictionary *)notification.userInfo;
        
        __self.jsDic = [da objectForKey:@"jsDic"];
        SysConf.hasShare = YES;
        //        NSLog(@"js = %@",js);
        //
        [__self selectChatRoom ];
    }];
    // 每次‘彩票下注页’设置导航条按钮时，改为设置LotteryBetAndChatVC页的导航条按钮
    {
        __weak static UIViewController *__vc = nil;
        __vc = self;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [UGCommonLotteryController cc_hookSelector:@selector(navigationItem) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo>  _Nonnull ai) {
                [ai.originalInvocation invoke];
                if (__vc) {
                    UINavigationItem *ni = __vc.navigationItem;
                    [ai.originalInvocation setReturnValue:&ni];
                }
            } error:nil];
        });
    }
    
    // 设置导航条返回按钮
    {
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [backButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [backButton setImage:[UIImage imageNamed:@"c_navi_back"] forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"c_navi_back"] forState:UIControlStateHighlighted];
        [backButton sizeToFit];
        [backButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
            UIViewController *vc =  [NavController1 popViewControllerAnimated:true];
            
        }];
        UIView *containView = [[UIView alloc] initWithFrame:backButton.bounds];
        [containView addSubview:backButton];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:containView];
        // 设置返回按钮
        self.navigationItem.leftBarButtonItem = item;
    }
    
    
    // 彩票下注页VC
    UGNextIssueModel *model = _nim;
    _vc1 = ({
        RnPageModel *rpm = [APP.rnPageInfos objectWithValue:model.gameType keyPath:@"gameType"];
        if (rpm) {
            _vc1 = (id)[ReactNativeVC reactNativeWithRPM:rpm params:@{@"model":model}];
        } else {
            NSDictionary *dict = @{@"cqssc" :@"UGSSCLotteryController",     // 重庆时时彩
                                   @"pk10"  :@"UGBJPK10LotteryController",  // pk10
                                   @"xyft"  :@"UGBJPK10LotteryController",  // 幸运飞艇
                                   @"qxc"   :@"UGQXCLotteryController",     // 七星彩
                                   @"lhc"   :@"UGHKLHCLotteryController",   // 六合彩
                                   @"jsk3"  :@"UGJSK3LotteryController",    // 江苏快3
                                   @"pcdd"  :@"UGPCDDLotteryController",    // pc蛋蛋
                                   @"gd11x5":@"UGGD11X5LotteryController",  // 广东11选5
                                   @"xync"  :@"UGXYNCLotteryController",    // 幸运农场
                                   @"bjkl8" :@"UGBJKL8LotteryController",   // 北京快乐8
                                   @"gdkl10":@"UGGDKL10LotteryController",  // 广东快乐10
                                   @"fc3d"  :@"UGFC3DLotteryController",    // 福彩3D
                                   @"pk10nn":@"UGPK10NNLotteryController",  // pk10牛牛
            };
            NSString *vcName = dict[model.gameType];
            UGCommonLotteryController *vc = _LoadVC_from_storyboard_(vcName);
            if ([@[@"7", @"11", @"9"] containsObject:model.gameId]) {
                vc.shoulHideHeader = true;
            }
            vc.nextIssueModel = model;
            vc.gameId = model.gameId;
            vc.gotoTabBlock = ^{
                TabBarController1.selectedIndex = 0;
            };
            // 底部占位调大到100
            [vc cc_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo>  _Nonnull ai) {
                UGCommonLotteryController *vc = ai.instance;
                vc.tableView.contentInset = UIEdgeInsetsMake(0, 0, 100, 0);
                vc.betCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 100, 0);
            } error:nil];
            _vc1 = vc;
        }
        _vc1;
    });
    
    // 聊天室VC
    _vc2 = ({
        UGChatViewController *vc = [[UGChatViewController alloc] init];
        vc.hideHead = YES;
        
        
        if ([self hasLastRoom]) {
            NSDictionary *dic = [self LastRoom];
            vc.roomId = dic[@"roomId"];
            vc.url = [APP chatGameUrl:dic[@"roomId"] hide:YES];
            self.mLabel.text = [NSString stringWithFormat:@"%@▼",dic[@"roomName"]];
        }
        else{
            NSLog(@"model.gameId = %@",model.gameId);

            if (model.gameId ) {
                UGChatRoomModel *roomModel =  [self getRoomMode:model.gameId];

                vc.roomId = roomModel.roomId;
                vc.url = [APP chatGameUrl:roomModel.roomId hide:YES];
                 self.mLabel.text = [NSString stringWithFormat:@"%@▼",roomModel.roomName];
            }
        }
        // 隐藏退出按钮
        [vc cc_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo>  _Nonnull ai) {
            ((UGChatViewController *)ai.instance).closeBtn.hidden = true;
        } error:nil];
        vc;
    });
    
    [self addChildViewController:_vc1];
    [self addChildViewController:_vc2];
    
    [self getChatRoomData];
}

-(void)getChatRoomData{
      //得到线上配置的聊天室
    [NetworkManager1 chat_getToken].completionBlock = ^(CCSessionModel *sm) {
        if (!sm.error) {
            NSLog(@"model.data = %@",sm.responseObject[@"data"]);
            NSDictionary *data = (NSDictionary *)sm.responseObject[@"data"];
            NSMutableArray *chatIdAry = [NSMutableArray new];
            NSMutableArray<UGChatRoomModel *> *chatRoomAry = [NSMutableArray new];
            
            NSArray * roomAry =[RoomChatModel mj_objectArrayWithKeyValuesArray:[data objectForKey:@"chatAry"]];
            
            NSArray *chatAry = [roomAry sortedArrayUsingComparator:^NSComparisonResult(RoomChatModel *p1, RoomChatModel *p2){
                //对数组进行排序（升序）
                return p1.sortId > p2.sortId;
                //对数组进行排序（降序）
                // return [p2.dateOfBirth compare:p1.dateOfBirth];
            }];
            for (int i = 0; i< chatAry.count; i++) {
                RoomChatModel *dic =  [chatAry objectAtIndex:i];
                [chatIdAry addObject:dic.roomId];

                [chatRoomAry addObject: [UGChatRoomModel mj_objectWithKeyValues:dic]];
                
            }

            SysConf.chatRoomAry = chatRoomAry;
            
            
            if (![CMCommon arryIsNull:chatRoomAry]) {
                UGChatRoomModel *obj  = SysConf.defaultChatRoom = [chatRoomAry objectAtIndex:0];
                NSLog(@"roomId = %@,sorId = %d",obj.roomId,obj.sortId);
            }
            else{
                UGChatRoomModel *obj  = [UGChatRoomModel new];
                obj.roomId = @"0";
                obj.roomName = @"聊天室";
            }
            
            if ([self hasLastRoom]) {
                NSDictionary *dic = [self LastRoom];
                self.vc2.roomId = dic[@"roomId"];
                self.vc2.url = [APP chatGameUrl:dic[@"roomId"] hide:YES];
                self.mLabel.text = [NSString stringWithFormat:@"%@▼",dic[@"roomName"]];
            }
            
            else{
                
                NSLog(@"model.gameId = %@",self.nim.gameId);
                
                if (self.nim.gameId ) {
                    UGChatRoomModel *roomModel =  [self getRoomMode:self.nim.gameId];
                    self.vc2.roomId = roomModel.roomId;
                    self.vc2.url = [APP chatGameUrl:roomModel.roomId hide:YES];
                    self.mLabel.text = [NSString stringWithFormat:@"%@▼",roomModel.roomName];
                }

            }
            
            
        }
    };
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    
    // SlideSegmentView1 分页布局View
    if (OBJOnceToken(self)) {
        __weakSelf_(__self);
        NSArray *titles = [NSArray new];
        
        if ([self hasLastRoom]) {
            NSDictionary *dic = [self LastRoom];
            titles = @[@"投注区", dic[@"roomName"]];
        }
        else{
            titles = @[@"投注区", @"聊天室"];
        }
        SlideSegmentView1 *ssv1 = _ssv1 = _LoadView_from_nib_(@"SlideSegmentView1");
        ssv1.frame = CGRectMake(0, 0, APP.Width, APP.Height);
        ssv1.viewControllers = @[_vc1, _vc2];
        for (UIView *v in ssv1.contentViews) {
            [v mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(ssv1.width);
                if (self.selectChat) {
                    make.height.mas_equalTo(UGScerrnH - 20-k_Height_NavBar - IPHONE_SAFEBOTTOMAREA_HEIGHT -40+22 -50);
                } else {
                    make.height.mas_equalTo(UGScerrnH - 20-k_Height_NavBar - IPHONE_SAFEBOTTOMAREA_HEIGHT -40+22);
                }
                
            }];
        }
        
        ssv1.titleBar.updateCellForItemAtIndex = ^(UICollectionViewCell *cell, UILabel *label, NSUInteger idx) {
            label.text = titles[idx];
            
            if (idx) {
                label.text = [NSString stringWithFormat:@"%@",titles[idx]];
                __self.mLabel = label;
                __self.downBtn = ({
                    UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                    button.frame = CGRectMake(50, 0, 40, 40);
                    //                    [button setBackgroundColor:[UIColor redColor]];
                    // 按钮的正常状态
                    button;
                });
                [cell addSubview:__self.downBtn];
                [__self.downBtn setHidden:YES];
                [__self.downBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cell).offset(cell.width/2-30);
                    make.right.equalTo(cell);
                    make.top.equalTo(cell);
                    make.bottom.equalTo(cell);
                }];
                [__self.downBtn  removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
                [__self.downBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
                    [__self selectChatRoom ];
                }];
            }
            
        };
        
        __weak_Obj_(ssv1, __ssv1);
        ssv1.titleBar.didSelectItemAtIndexPath = ^(UICollectionViewCell *cell, UILabel *label, NSUInteger idx, BOOL selected) {
            if (APP.isChatWhite && !APP.betBgIsWhite) {
                label.textColor = [UIColor whiteColor];
            } else {
                label.textColor = selected ? Skin1.textColor1 : Skin1.textColor2;
                if (!idx && !selected) {
                    label.textColor = [UIColor whiteColor];
                }
            }
            
            label.font = selected ? [UIFont boldSystemFontOfSize:16] : [UIFont systemFontOfSize:14];
            
            if (APP.isRedWhite) {
                cell.backgroundColor = selected ? [UIColor whiteColor] : Skin1.navBarBgColor;
                __ssv1.titleBar.backgroundColor = Skin1.navBarBgColor;
                label.textColor = selected ? [UIColor blackColor] : [UIColor whiteColor];
            } else {
                if (APP.betBgIsWhite) {
                    cell.backgroundColor = selected ? [[UIColor grayColor] colorWithAlphaComponent:0.25] : [UIColor clearColor];
                }
                else{
                    cell.backgroundColor = selected ? [[UIColor whiteColor] colorWithAlphaComponent:0.25] : [UIColor clearColor];
                }
                
                NSLog(@"Skin1.skitString = %@",Skin1.skitString);
                
                NSLog(@"Skin1.is23 = %d",Skin1.is23);
                
                __ssv1.titleBar.backgroundColor = Skin1.isBlack||Skin1.is23 || idx || !APP.betBgIsWhite ? Skin1.navBarBgColor : [UIColor whiteColor];
            }
            
            if ([Skin1.skitString isEqualToString:@"黑色模板香槟金"]) {
                label.textColor = [UIColor whiteColor];
            }
            
            
            
        };
        ssv1.didSelectedIndex = ^(NSUInteger idx) {
            if (idx) {
                
                [__self.downBtn setHidden:NO];
                             //得到线上配置的聊天室
                
                  [self getChatRoomData];

                
                
            }
            else{
                
                [__self.downBtn setHidden:YES];
                if ([__self.mLabel.text containsString:@"▼"]) {
                    NSString *text = __self.mLabel.text;
                    text =  [text stringByReplacingOccurrencesOfString:@"▼"withString:@""];;
                    __self.mLabel.text = text;
                }
            }
        };
        ssv1.titleBar.underlineView.hidden = true;
        [self.view insertSubview:ssv1 atIndex:0];
        [ssv1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_topMargin);
            make.left.right.bottom.equalTo(self.view);
        }];
        [self.view layoutIfNeeded];
        ssv1.selectedIndex = self.selectChat;
        
    }
}



-(void)selectChatRoom {
    if (_ssv1.selectedIndex == 0) {
        _ssv1.selectedIndex = 1;
    }
    __weakSelf_(__self);
    //得到线上配置的聊天室
    [NetworkManager1 chat_getToken].completionBlock = ^(CCSessionModel *sm) {
        if (!sm.error) {
            NSLog(@"model.data = %@",sm.responseObject[@"data"]);
            NSDictionary *data = (NSDictionary *)sm.responseObject[@"data"];
            __self.chatAry = [NSMutableArray new];
            NSMutableArray *chatIdAry = [NSMutableArray new];
            NSMutableArray *chatTitleAry = [NSMutableArray new];
            NSMutableArray *typeIdAry = [NSMutableArray new];
            NSMutableArray<UGChatRoomModel *> *chatRoomAry = [NSMutableArray new];
            //            __self.chatAry = [data objectForKey:@"chatAry"];
            NSArray * roomAry =[RoomChatModel mj_objectArrayWithKeyValuesArray:[data objectForKey:@"chatAry"]];
            
            __self.chatAry = [roomAry sortedArrayUsingComparator:^NSComparisonResult(RoomChatModel *p1, RoomChatModel *p2){
                //对数组进行排序（升序）
                return p1.sortId > p2.sortId;
                //对数组进行排序（降序）
                // return [p2.dateOfBirth compare:p1.dateOfBirth];
            }];
            for (int i = 0; i< __self.chatAry.count; i++) {
                RoomChatModel *dic =  [__self.chatAry objectAtIndex:i];
                [chatIdAry addObject:dic.roomId];
                [chatTitleAry addObject:dic.roomName];
                [chatRoomAry addObject: [UGChatRoomModel mj_objectWithKeyValues:dic]];
            }
            
            NSArray *chat2Ary = [RoomChatModel mj_keyValuesArrayWithObjectArray:__self.chatAry];
            //                             NSLog(@"chatIdAry = %@",chatIdAry);
     
            SysConf.chatRoomAry = chatRoomAry;
            NSLog(@"SysConf.chatRoomAry = %@",SysConf.chatRoomAry);
            //            SysConf.chatRoomAry = __self.chatAry;
            
            if (![CMCommon arryIsNull:chatRoomAry]) {
                UGChatRoomModel *obj  = SysConf.defaultChatRoom = [chatRoomAry objectAtIndex:0];
                NSLog(@"roomId = %@,sorId = %d",obj.roomId,obj.sortId);
            }
            else{
                UGChatRoomModel *obj  = [UGChatRoomModel new];
                obj.roomId = @"0";
                obj.roomName = @"聊天室";
                SysConf.defaultChatRoom  = obj;
            }
            
            UIAlertController *ac = [AlertHelper showAlertView:nil msg:@"请选择要切换的聊天室" btnTitles:[chatTitleAry arrayByAddingObject:@"取消"]];
            for (NSString *key in chatTitleAry) {
                [ac setActionAtTitle:key handler:^(UIAlertAction *aa) {
                    
                    NSDictionary *dic = [chat2Ary objectWithValue:key keyPath:@"roomName"];
                    NSString *pass =  [dic objectForKey:@"password"];
                    NSString *chatId = [dic objectForKey:@"roomId"];
                    if ([CMCommon stringIsNull:chatId]) {
                        NSLog(@"房间id 为空：%@",chatId);
                        return ;
                    }
                    
                    //取数据
                    NSArray * rpArray = [WHCSqlite query:[RememberPass class] where:[NSString stringWithFormat:@"roomId = '%@'",chatId]];
                    RememberPass *rp = (RememberPass *)[rpArray objectAtIndex:0];
                    
                    BOOL isPass = NO;
                    if (![CMCommon stringIsNull:rp.password]) {
                        isPass = YES;
                    } else {
                        isPass =[CMCommon stringIsNull:pass];
                    }
                    
                    if (isPass) {
                        //                                         if (![vc2.roomId isEqualToString:chatId]) {
                        __self.vc2.roomId = chatId;
                        NSLog(@"房间dic：%@",dic);
                        UGChatRoomModel *obj = [UGChatRoomModel mj_objectWithKeyValues:dic];
                        NSLog(@"房间obj：%@",obj);
                        if (!obj) {
                            NSLog(@"房间 为空：%@",obj);
                            return ;
                        }
                        
                        if (__self.jsDic) {
                            UGbetModel *betModel = [__self.jsDic objectForKey:@"betModel"];
                            betModel.roomId = chatId;
                            NSMutableArray *list = [__self.jsDic objectForKey:@"list"];
                            NSString* paramsjsonString = [betModel toJSONString];
                            NSLog(@"paramsjsonString = %@",paramsjsonString);
                            NSString *listjsonString;
                            {
                                NSError *error;
                                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:list options:NSJSONWritingPrettyPrinted error:&error];
                                listjsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                                
                            }
                            NSLog(@"listjsonString = %@",listjsonString);
                            NSString *jsonStr = [NSString stringWithFormat:@"shareBet(%@, %@)",listjsonString,paramsjsonString];
                            NSLog(@"jsonStr = %@",jsonStr);
                            __self.vc2.shareBetJson = jsonStr;
                        }
                        
                        
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //需要在主线程执行的代码
                            // 模型转字符串
                            NSString* string = [obj toJSONString];
                            //                                            NSLog(@"string = %@",string);
                            NSString *js = [NSString stringWithFormat:@"changeRoom(%@)",string];
                            //                                            NSLog(@"js = %@",js);
                            [self saveRoomName:obj.roomName RoomId:obj.roomId];
                            [__self.vc2 setChangeRoomJson:js];
                            NSLog(@"__self.vc2 = %@",__self.vc2);
                            __self.mLabel.text = [NSString stringWithFormat:@"%@▼",key];
                        }];
                        
                        //                                         }
                        
                        
                    } else {
                        // 使用一个变量接收自定义的输入框对象 以便于在其他位置调用
                        __block UITextField *tf = nil;
                        
                        [LEEAlert alert].config
                        .LeeTitle(@"请输入房间密码")
                        .LeeAddTextField(^(UITextField *textField) {
                            textField.placeholder = @"请输入房间密码";
                            textField.textColor = [UIColor darkGrayColor];
                            tf = textField; //赋值
                        })
                        
                        .LeeAction(@"确定", ^{
                            //                                            NSLog(@"tf.text = %@",tf.text);
                            if ([pass isEqualToString:tf.text]) {
                                //                                                 if (![vc2.roomId isEqualToString:chatId]) {
                                __self.vc2.roomId = chatId;
                                NSLog(@"房间dic：%@",dic);
                                UGChatRoomModel *obj = [UGChatRoomModel mj_objectWithKeyValues:dic];
                                NSLog(@"房间obj：%@",obj);
                                if (!obj) {
                                    NSLog(@"房间 为空：%@",obj);
                                    return ;
                                }
                                
                                //保存密码
                                RememberPass *rp = [RememberPass new];
                                rp.roomId = chatId;
                                rp.roomName = obj.roomName;
                                rp.password = pass;
                                [WHCSqlite insert:rp];
                                
                                if (__self.jsDic) {
                                    UGbetModel *betModel = [__self.jsDic objectForKey:@"betModel"];
                                    betModel.roomId = chatId;
                                    NSMutableArray *list = [__self.jsDic objectForKey:@"list"];
                                    NSString* paramsjsonString = [betModel toJSONString];
                                    NSLog(@"paramsjsonString = %@",paramsjsonString);
                                    NSString *listjsonString;
                                    {
                                        NSError *error;
                                        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:list options:NSJSONWritingPrettyPrinted error:&error];
                                        listjsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                                        
                                    }
                                    NSLog(@"listjsonString = %@",listjsonString);
                                    NSString *jsonStr = [NSString stringWithFormat:@"shareBet(%@, %@)",listjsonString,paramsjsonString];
                                    NSLog(@"jsonStr = %@",jsonStr);
                                    __self.vc2.shareBetJson = jsonStr;
                                }
                                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                    //需要在主线程执行的代码
                                    // 模型转字符串
                                    NSString* string = [obj toJSONString];
                                    //                                                    NSLog(@"string = %@",string);
                                    NSString *js = [NSString stringWithFormat:@"changeRoom(%@)",string];
                                    //                                                    NSLog(@"js = %@",js);
                                    
                                    [self saveRoomName:obj.roomName RoomId:obj.roomId];
                                    [__self.vc2 setChangeRoomJson:js];
                                    __self.mLabel.text = [NSString stringWithFormat:@"%@▼",key];
                                }];
                                
                                //                                                 }
                            } else {
                                [CMCommon showToastTitle:@"房间密码错误"];
                            }
                        })
                        .leeShouldActionClickClose(^(NSInteger index){
                            // 是否可以关闭回调, 当即将关闭时会被调用 根据返回值决定是否执行关闭处理
                            // 这里演示了与输入框非空校验结合的例子
                            BOOL result = ![tf.text isEqualToString:@""];
                            result = index == 0 ? result : YES;
                            return result;
                        })
                        .LeeCancelAction(@"取消", nil) // 点击事件的Block如果不需要可以传nil
                        .LeeShow();
                        
                    }
                }];
            }
            
        }
    };
}

-(void)saveRoomName:(NSString *)name RoomId:(NSString *)rid{
    [[NSUserDefaults standardUserDefaults]setObject:name forKey:@"roomName"];
    [[NSUserDefaults standardUserDefaults]setObject:rid forKey:@"roomId"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(NSDictionary *)LastRoom{
    NSString *roomId = [[NSUserDefaults standardUserDefaults]objectForKey:@"roomId"];
    NSString *roomName = [[NSUserDefaults standardUserDefaults]objectForKey:@"roomName"];
    
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:
                          roomId,@"roomId",
                          roomName,@"roomName",
                          nil];
    return dic;
}

-(BOOL )hasLastRoom{
    
    NSDictionary *dic = [self LastRoom];
    if ([CMCommon stringIsNull:dic[@"roomId"]]) {
        return NO;
    } else {
        return YES;
    }
}


-(UGChatRoomModel *)getRoomMode:(NSString *)gameId{
    
    UGChatRoomModel *obj  = [UGChatRoomModel new];
    
    obj.roomName = SysConf.defaultChatRoom.roomName;
    obj.roomId  = SysConf.defaultChatRoom.roomId;
    
    NSLog(@"SysConf.chatRoomAry=%@",SysConf.chatRoomAry);
    
    
    for (UGChatRoomModel *object in SysConf.chatRoomAry) {
        
        NSLog(@"object.typeIds = %@",object.typeIds);
        if ( [object.typeIds containsObject:gameId]) {
            
            obj.roomName = object.roomName;
            obj.roomId  = object.roomId;
            break;
        }
    }
    
    return obj;
}
@end

