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

@property (nonatomic, strong) NSMutableArray *chatAry ;         /**<   聊天室数据*/
@end


@implementation LotteryBetAndChatVC

- (BOOL)允许游客访问 { return true; }

-(void)showLeeView{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
            [NavController1 popViewControllerAnimated:true];
        }];
        UIView *containView = [[UIView alloc] initWithFrame:backButton.bounds];
        [containView addSubview:backButton];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:containView];
        // 设置返回按钮
        self.navigationItem.leftBarButtonItem = item;
    }
    
    
    
    
    // 彩票下注页VC
    UGNextIssueModel *model = _nim;
    UGCommonLotteryController *vc1 = ({
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
        UGNextIssueModel *nextIssueModel = [UGNextIssueModel new];
        [nextIssueModel setValuesWithObject:model];
        vc.nextIssueModel = nextIssueModel;
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
        vc;
    });
    
    // 聊天室VC
    UGChatViewController *vc2 = ({
        UGChatViewController *vc = [[UGChatViewController alloc] init];
        vc.hideHead = YES;
//        NSLog(@"model.gameId = %@",model.gameId);
//        NSLog(@"包含 = %d",[SysConf.typeIdAry containsObject:model.gameId]);
        if (model.gameId && SysConf.typeIdAry.count && [SysConf.typeIdAry containsObject:model.gameId]) {
            vc.gameId = model.gameId;
            UGChatRoomModel *obj = [SysConf.chatRoomAry objectWithValue:vc.gameId keyPath:@"typeId"];
            
            if (![CMCommon stringIsNull:obj.roomId]) {
                vc.roomId = obj.roomId;
                vc.url = [APP chatGameUrl:obj.roomId hide:YES];
//                NSLog(@"vc.url = %@",vc.url);
            }
        } else {
            vc.gameId = @"主聊天室";
            vc.roomId = @"0";
            vc.url = [APP chatGameUrl:vc.roomId hide:YES];
//            NSLog(@"vc.url = %@",vc.url);
        }
        
        // 隐藏H5的导航条
//        [vc cc_hookSelector:@selector(setUrl:) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo>  _Nonnull ai) {
//            NSString *url = ai.arguments.firstObject;
//            url = _NSString(@"%@&hideHead=true", url);
//            [ai.originalInvocation setArgument:&url atIndex:2];
//        } error:nil];
        // 隐藏退出按钮
        [vc cc_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo>  _Nonnull ai) {
            ((UGChatViewController *)ai.instance).closeBtn.hidden = true;
        } error:nil];
        vc;
    });
    
    
    
    // SlideSegmentView1 分页布局View
    {
        
        [self addChildViewController:vc1];
        [self addChildViewController:vc2];
        
        NSArray *titles = @[@"投注区", @"聊天室"];
        SlideSegmentView1 *ssv1 = _ssv1 = _LoadView_from_nib_(@"SlideSegmentView1");
        ssv1.frame = CGRectMake(0, 0, APP.Width, APP.Height);
        ssv1.viewControllers = @[vc1, vc2];
        for (UIView *v in ssv1.contentViews) {
            [v mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(ssv1.width);
                make.height.mas_equalTo(APP.Height - NavController1.navigationBar.by - 40);
            }];
        }
        __weakSelf_(__self);
        ssv1.titleBar.updateCellForItemAtIndex = ^(UICollectionViewCell *cell, UILabel *label, NSUInteger idx) {
            label.text = titles[idx];
            if (idx) {
                label.text = [NSString stringWithFormat:@"%@▼",titles[idx]];
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
                    
                    if (ssv1.selectedIndex == 0) {
                        ssv1.selectedIndex = 1;
                    }
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
                            __self.chatAry = [data objectForKey:@"chatAry"];
                            for (int i = 0; i< __self.chatAry.count; i++) {
                                NSDictionary *dic =  [__self.chatAry objectAtIndex:i];
                                [chatIdAry addObject:[dic objectForKey:@"roomId"]];
                                [chatTitleAry addObject:[dic objectForKey:@"roomName"]];
                                [typeIdAry addObject:[dic objectForKey:@"typeId"]];
                                [chatRoomAry addObject: [UGChatRoomModel mj_objectWithKeyValues:dic]];
                            }
                            //                             NSLog(@"chatIdAry = %@",chatIdAry);
                            SysConf.typeIdAry = typeIdAry;
                            SysConf.chatRoomAry = chatRoomAry;
                            
                            
                            UIAlertController *ac = [AlertHelper showAlertView:nil msg:@"请选择要切换的聊天室" btnTitles:[chatTitleAry arrayByAddingObject:@"取消"]];
                            for (NSString *key in chatTitleAry) {
                                [ac setActionAtTitle:key handler:^(UIAlertAction *aa) {
                                    
                                    NSDictionary *dic = [__self.chatAry objectWithValue:key keyPath:@"roomName"];
                                    NSString *pass =  [dic objectForKey:@"password"];
                                    NSString *chatId = [dic objectForKey:@"roomId"];
                                    if ([CMCommon stringIsNull:chatId]) {
                                        NSLog(@"房间id 为空：%@",chatId);
                                        return ;
                                    }
                                    if ([CMCommon stringIsNull:pass]||[pass isEqualToString:@"%@NSCONTEXT"]) {
                                        //                                         if (![vc2.roomId isEqualToString:chatId]) {
                                        vc2.roomId = chatId;
                                        UGChatRoomModel *obj = [SysConf.chatRoomAry objectWithValue:vc2.roomId keyPath:@"roomId"];
                                        
                                        if (!obj) {
                                            NSLog(@"房间 为空：%@",obj);
                                            return ;
                                        }
                                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                            //需要在主线程执行的代码
                                            // 模型转字符串
                                            NSString* string = [obj toJSONString];
//                                            NSLog(@"string = %@",string);
                                            NSString *js = [NSString stringWithFormat:@"changeRoom(%@)",string];
//                                            NSLog(@"js = %@",js);
                                            [vc2 setChangeRoomJson:js];
                                            label.text = [NSString stringWithFormat:@"%@▼",key];
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
                                                vc2.roomId = chatId;
                                                UGChatRoomModel *obj = [SysConf.chatRoomAry objectWithValue:vc2.roomId keyPath:@"roomId"];
                                                
                                                if (!obj) {
                                                    NSLog(@"房间 为空：%@",obj);
                                                    return ;
                                                }
                                                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                    //需要在主线程执行的代码
                                                    // 模型转字符串
                                                    NSString* string = [obj toJSONString];
//                                                    NSLog(@"string = %@",string);
                                                    NSString *js = [NSString stringWithFormat:@"changeRoom(%@)",string];
//                                                    NSLog(@"js = %@",js);
                                                    [vc2 setChangeRoomJson:js];
                                                    label.text = [NSString stringWithFormat:@"%@▼",key];
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
                }];
            }
            
        };
        
        __weak_Obj_(ssv1, __ssv1);
        ssv1.titleBar.didSelectItemAtIndexPath = ^(UICollectionViewCell *cell, UILabel *label, NSUInteger idx, BOOL selected) {
            label.textColor = selected ? Skin1.textColor1 : Skin1.textColor2;
            
            if (!idx && !selected) {
                label.textColor = [UIColor whiteColor];
            }
            label.font = selected ? [UIFont boldSystemFontOfSize:16] : [UIFont systemFontOfSize:14];
            cell.backgroundColor = selected ? [[UIColor grayColor] colorWithAlphaComponent:0.1] : [UIColor clearColor];
            __ssv1.titleBar.backgroundColor = Skin1.isBlack || idx || !APP.betBgIsWhite ? Skin1.navBarBgColor : [UIColor whiteColor];
        };
        ssv1.didSelectedIndex = ^(NSUInteger idx) {
            if (idx) {
                [__self.downBtn setHidden:NO];
                __weakSelf_(__self);
                //得到线上配置的聊天室
                [NetworkManager1 chat_getToken].completionBlock = ^(CCSessionModel *sm) {
                    if (!sm.error) {
                        NSLog(@"model.data = %@",sm.responseObject[@"data"]);
                        NSDictionary *data = (NSDictionary *)sm.responseObject[@"data"];
                        NSMutableArray *chatIdAry = [NSMutableArray new];
                        NSMutableArray *typeIdAry = [NSMutableArray new];
                        NSMutableArray<UGChatRoomModel *> *chatRoomAry = [NSMutableArray new];
                        NSArray * chatAry = [data objectForKey:@"chatAry"];
                        for (int i = 0; i< chatAry.count; i++) {
                            NSDictionary *dic =  [chatAry objectAtIndex:i];
                            [chatIdAry addObject:[dic objectForKey:@"roomId"]];
                            [typeIdAry addObject:[dic objectForKey:@"typeId"]];
                            [chatRoomAry addObject: [UGChatRoomModel mj_objectWithKeyValues:dic]];
                            
                        }
                        //                        NSLog(@"chatIdAry = %@",chatIdAry);
                        //                        NSLog(@"chatRoomAry = %@",chatRoomAry);
                        SysConf.typeIdAry = typeIdAry;
                        SysConf.chatRoomAry = chatRoomAry;
//                        NSLog(@"vc2.isLoading = %d",vc2.tgWebView.isLoading);
//                        NSLog(@"vc2.loading = %d",vc2.tgWebView.loading);
//                        NSLog(@"vc2.URL = %@",vc2.tgWebView.URL);
                        
                        if (__self.nim.gameId && SysConf.typeIdAry.count && [SysConf.typeIdAry containsObject:__self.nim.gameId]) {
                            //                            if (![vc2.gameId isEqualToString:__self.nim.gameId]) {
                            vc2.gameId = __self.nim.gameId;
                            UGChatRoomModel *obj = [SysConf.chatRoomAry objectWithValue:vc2.gameId keyPath:@"typeId"];
                            
                            if (![vc2.roomId isEqualToString:obj.roomId]) {
                                vc2.roomId = obj.roomId;
                                vc2.url = [APP chatGameUrl:obj.roomId hide:YES];
//                                NSLog(@"vc2.url = %@",vc2.url);
                            }
                            
                            //                            }
                            
                        } else {
                            if(![vc2.roomId isEqualToString:@"0"]){
                                vc2.gameId = @"主聊天室";
                                vc2.roomId = @"0";
                                vc2.url = [APP chatGameUrl:vc2.roomId hide:YES];
//                                NSLog(@"vc2.url = %@",vc2.url);
                            }
                            
                        }
                    }
                };
                
                
            }
            else{
                [__self.downBtn setHidden:YES];
            }
        };
        ssv1.titleBar.underlineView.hidden = true;
        [self.view insertSubview:ssv1 atIndex:0];
        [ssv1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_topMargin);
            make.left.right.bottom.equalTo(self.view);
        }];
        [self.view layoutIfNeeded];
        ssv1.selectedIndex = 0;
    };
    
}

@end

