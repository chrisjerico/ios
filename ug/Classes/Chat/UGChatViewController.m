//
//  UGChatViewController.m
//  ug
//
//  Created by ug on 2019/9/21.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGChatViewController.h"

#import "STBarButtonItem.h"
#import "CCNetworkRequests1+UG.h"
#import "RememberPass.h"
#import "WHC_ModelSqlite.h"
#import "RoomChatModel.h"
#import "UGGameplayModel.h"
#import "UGBetDetailView.h"

@interface UGChatViewController ()

@property (nonatomic,retain)NSArray * myroomAry;
@property (nonatomic) UIButton *closeBtn;
@end


@implementation UGChatViewController

- (void)skin {
	
}


- (BOOL)允许未登录访问 { return false; }
- (BOOL)允许游客访问 { return true; }

- (void)viewDidLoad {
	[super viewDidLoad];
	if (self.navigationController.viewControllers.firstObject == self) {
		self.navigationController.navigationBarHidden = true;
	}
    self.fd_prefersNavigationBarHidden = !_showChangeRoomTitle;
    if (_showChangeRoomTitle) {
        [self setupTitleView];
    }
    
    
    [self chatRoomName];
	// 设置URL
	__weakSelf_(__self);
	{
		void (^setupUrl)(void) = ^{
			[__self.tgWebView stopLoading];
			if (__self.shareBetJson.length) {
				__self.url = APP.chatShareUrl;
            } else if (__self.roomId.length) {
                
                __self.url = [APP chatGameUrl:__self.roomId hide:__self.hideHead];
 
			} else {
				__self.url = APP.chatHomeUrl;
			}
			[__self.tgWebView reloadFromOrigin];
		};
		SANotificationEventSubscribe(UGNotificationWithSkinSuccess, self, ^(typeof (self) self, id obj) {
			setupUrl();
		});
		setupUrl();
	}
	
	// 返回按钮
	{
		_closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		_closeBtn.frame = CGRectMake(APP.Width-80, APP.StatusBarHeight, 40, 45);
		[_closeBtn setImage:[UIImage imageNamed:@"c_login_close_fff"] forState:UIControlStateNormal];
		[_closeBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
			[__self.navigationController popViewControllerAnimated:true];
		}];
		
		if (self.navigationController.viewControllers.firstObject != self){
			[self.view addSubview:_closeBtn];
		}
	}
	
	
	[self goShareBetJson];
	
    // 聊天室跟注功能
    self.didReceiveScriptMessage = ^(NSString *name, NSDictionary *body) {
        if (![body isKindOfClass:[NSDictionary class]]) return;
        [__self followBet:body];
    };
}

// 跟注
- (void)followBet:(NSDictionary *)betInfo {
    [SVProgressHUD show];
    NSString *gameId = betInfo[@"gameId"];// 彩种
    __block NSString *paneCode = betInfo[@"paneCode"]; // 玩法
    
    // 第一步：获取玩法赔率
    [CMNetwork getGameDatasWithParams:@{@"id":gameId} completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            UGPlayOddsModel *play = model.data;
            
            // 第二步：遍历找到对应号码数据
            NSMutableArray <UGGameBetModel *>*nums = nil;
            for (UGGameplayModel *gpm in play.playOdds) {
                NSMutableArray <UGGameBetModel *>*gbms = @[].mutableCopy;
                NSMutableArray *temp = [betInfo[@"betBean"] mutableCopy];
                for (UGGameplaySectionModel *gsm in gpm.list) {
                    for (NSDictionary *dict in [temp copy]) {
                        UGGameBetModel *gbm = nil;
                        gbm = gbm ? : [gsm.lhcOddsArray objectWithValue:dict[@"playId"] keyPath:@"playId"];
                        gbm = gbm ? : [gsm.list objectWithValue:dict[@"playId"] keyPath:@"playId"];
                        gbm = gbm ? : [gsm.zxbzlist objectWithValue:dict[@"playId"] keyPath:@"playId"];
                        
                        for (UGGameplaySectionModel *subGsm in gsm.ezdwlist) {
                            gbm = gbm ? : [subGsm.lhcOddsArray objectWithValue:dict[@"playId"] keyPath:@"playId"];
                            gbm = gbm ? : [subGsm.list objectWithValue:dict[@"playId"] keyPath:@"playId"];
                            gbm = gbm ? : [subGsm.zxbzlist objectWithValue:dict[@"playId"] keyPath:@"playId"];
                        }
                        if (gbm) {
                            gbm.money = dict[@"money"];
                            gbm.odds = dict[@"odds"];
                            NSString *subName = gsm.alias.length ? gsm.alias : gsm.name;
                            if ([subName hasPrefix:gpm.name]) {
                                gbm.title = subName;
                            } else {
                                gbm.title = _NSString(@"%@-%@", gpm.name, subName);
                            }
                            
                            [gbms addObject:gbm];
                            [temp removeObject:dict];
                            // 第三步：找到玩法paneCode
                            paneCode = paneCode.length ? paneCode : gsm.code;
                        }
                    }
                }
                if (nums.count < gbms.count) {
                    nums = gbms;
                }
            }
            
            // 第四步：获取当前期数信息
            [CMNetwork getNextIssueWithParams:@{@"id":gameId} completion:^(CMResult<id> *model, NSError *err) {
                [CMResult processWithResult:model success:^{
                    UGNextIssueModel *nextIssueModel = model.data;
                    
                    // 最后一步：弹框让用户跟注
                    UGBetDetailView *bdv = [[UGBetDetailView alloc] init];
                    bdv.dataArray = nums;
                    bdv.nextIssueModel = nextIssueModel;
                    bdv.code = paneCode;
                    [bdv show];
                    
                } failure:nil];
                [SVProgressHUD dismiss];
            }];
            
        } failure:nil];
        [SVProgressHUD dismiss];
    }];
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	//    if ([self.title isEqualToString:@"聊天室"] && !_shareBetJson.length) {
	//        if (OBJOnceToken(UserI)) {
	//            [self.tgWebView stopLoading];
	//            self.url = APP.chatHomeUrl;
	//            [self.tgWebView reloadFromOrigin];
	//            NSLog(@"self.url = %@",self.url);
	//        }
	//    }
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	self.tgWebView.scrollView.backgroundColor = Skin1.bgColor;
}

- (void)setShareBetJson:(NSString *)shareBetJson {
	_shareBetJson = shareBetJson;
	NSLog(@"shareBetJson = %@", shareBetJson);
	if (![CMCommon stringIsNull:shareBetJson]){
		[self.view addSubview:_closeBtn];
	}
}

- (void)setChangeRoomJson:(NSString *)changeRoomJson {
	_changeRoomJson = changeRoomJson;
	NSLog(@"changeRoomJson = %@", changeRoomJson);
	__weakSelf_(__self);
    
	[[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // 需要延迟执行的代码
            [__self goChangeRoomJS];
	}];
}


-(void)goShareBetJson{
	// 每秒判断一下 window.canShare 参数为YES才进行分享
	if (_shareBetJson.length) {
		__weakSelf_(__self);
		__block NSTimer *__timer = nil;
		__timer = [NSTimer scheduledTimerWithInterval:1 repeats:true block:^(NSTimer *timer) {
			[__self.tgWebView evaluateJavaScript:@"window.canShare" completionHandler:^(id obj, NSError *error) {
				NSLog(@"是否可以分享：%d", [obj boolValue]);
				if ([obj isKindOfClass:[NSNumber class]] && [obj boolValue]) {
					[__self.tgWebView evaluateJavaScript:__self.shareBetJson completionHandler:^(id _Nullable result, NSError * _Nullable error) {
						NSLog(@"分享结果：%@----%@", result, error);
						SysConf.hasShare = NO;
//                        [CMCommon showTitle:[NSString stringWithFormat:@"分享结果成功！%@,hasShare =%d",__self.shareBetJson,SysConf.hasShare]];
						NSLog(@"分享结果：%@", __self.shareBetJson);
						
						
					}];
					[__timer invalidate];
					__timer = nil;
				}
				
				if (!__self) {
					[__timer invalidate];
					__timer = nil;
				}
			}];
		}];
	}
}

-(void)goChangeRoomJS{
	// 每秒判断一下 window.canShare 参数为YES才进行切房间
	if (_changeRoomJson.length) {
		__weakSelf_(__self);
		__block NSTimer *__timer = nil;
		__timer = [NSTimer scheduledTimerWithInterval:1 repeats:true block:^(NSTimer *timer) {
			
			NSLog(@"在运行");
			[__self.tgWebView evaluateJavaScript:@"window.canShare" completionHandler:^(id obj, NSError *error) {
				NSLog(@"是否可以切换：%d", [obj boolValue]);
				if ([obj isKindOfClass:[NSNumber class]] && [obj boolValue]) {
					[__self.tgWebView evaluateJavaScript:__self.changeRoomJson completionHandler:^(id _Nullable result, NSError * _Nullable error) {
						NSLog(@"切换结果：%@----%@", result, error);
                      
						
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //需要在主线程执行的代码
//                            [CMCommon showSystemTitle:[NSString stringWithFormat:@"切换成功！%@   hasShare = %d ",__self.changeRoomJson,SysConf.hasShare]];
                            
                            if (__self.shareBetJson && SysConf.hasShare) {
                                    // 需要延迟执行的代码
                                
                                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
                                
                                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                                    // 需要延迟执行的代码
                                       [__self goShareBetJson];
                                });
                                 
                                
                            }
                        }];
						
					}];
					[__timer invalidate];
					__timer = nil;
				}
				
				if (!__self) {
					[__timer invalidate];
					__timer = nil;
				}
			}];
		}];
	}
}


#pragma mark - 切换聊天室

- (void)setupTitleView {
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
    STBarButtonItem *item0 = [STBarButtonItem barButtonItemWithTitle:_NSString(@"%@ ▼", self.title) target:self action:@selector(selectChatRoom)];
//    self.navigationItem.leftBarButtonItems = @[self.navigationItem.leftBarButtonItems.firstObject, item0];
    self.navigationItem.titleView = item0.customView;   // 隐藏标题
    
    if (OBJOnceToken(self)) {
        [self.navigationItem cc_hookSelector:@selector(setTitle:) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> ai) {
            NSString *title = ai.arguments.lastObject;
            [(UIButton *)item0.customView setTitle:_NSString(@"%@ ▼", title) forState:UIControlStateNormal];
            [(UIButton *)item0.customView sizeToFit];
        } error:nil];
    }
    
}

-(void)selectChatRoom {
    __weakSelf_(__self);
    //得到线上配置的聊天室
    [NetworkManager1 chat_getToken].completionBlock = ^(CCSessionModel *sm) {
        if (!sm.error) {
            NSLog(@"model.data = %@",sm.responseObject[@"data"]);
            NSDictionary *data = (NSDictionary *)sm.responseObject[@"data"];
            NSArray *chatAry = [NSArray new];
            NSMutableArray *chatIdAry = [NSMutableArray new];
            NSMutableArray *chatTitleAry = [NSMutableArray new];
            NSMutableArray *typeIdAry = [NSMutableArray new];
            NSMutableArray<UGChatRoomModel *> *chatRoomAry = [NSMutableArray new];
//            chatAry = [data objectForKey:@"chatAry"];
            NSArray * roomAry =[RoomChatModel mj_objectArrayWithKeyValuesArray:[data objectForKey:@"chatAry"]];
            
            chatAry = [roomAry sortedArrayUsingComparator:^NSComparisonResult(RoomChatModel *p1, RoomChatModel *p2){
                //对数组进行排序（升序）
                return p1.sortId > p2.sortId;
                //对数组进行排序（降序）
                // return [p2.dateOfBirth compare:p1.dateOfBirth];
            }];
            for (int i = 0; i< chatAry.count; i++) {
                RoomChatModel *dic =  [chatAry objectAtIndex:i];
                [chatIdAry addObject:dic.roomId];
                [chatTitleAry addObject:dic.roomName];
                [chatRoomAry addObject: [UGChatRoomModel mj_objectWithKeyValues:dic]];
            }
            
            [CMCommon removeLastRoomAction:chatIdAry];
            //                             NSLog(@"chatIdAry = %@",chatIdAry);
            SysConf.chatRoomAry = chatRoomAry;
            NSLog(@"SysConf.chatRoomAry = %@",SysConf.chatRoomAry);
            //            SysConf.chatRoomAry = chatAry;
            
            NSArray *chat2Ary = [RoomChatModel mj_keyValuesArrayWithObjectArray:chatAry];
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
                        __self.roomId = chatId;
                        NSLog(@"房间dic：%@",dic);
                        UGChatRoomModel *obj = [UGChatRoomModel mj_objectWithKeyValues:dic];
                        NSLog(@"房间obj：%@",obj);
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
                            [__self setChangeRoomJson:js];
                            __self.title = key;
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
                                __self.roomId = chatId;
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
                                
                                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                    //需要在主线程执行的代码
                                    // 模型转字符串
                                    NSString* string = [obj toJSONString];
                                    //                                                    NSLog(@"string = %@",string);
                                    NSString *js = [NSString stringWithFormat:@"changeRoom(%@)",string];
                                    //                                                    NSLog(@"js = %@",js);
                                    [__self setChangeRoomJson:js];
                                    __self.title = key;
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


-(void)chatRoomName {
    __weakSelf_(__self);
    //得到线上配置的聊天室
    [NetworkManager1 chat_getToken].completionBlock = ^(CCSessionModel *sm) {
        if (!sm.error) {
            NSLog(@"model.data = %@",sm.responseObject[@"data"]);
            NSDictionary *data = (NSDictionary *)sm.responseObject[@"data"];
            self.myroomAry =[RoomChatModel mj_objectArrayWithKeyValuesArray:[data objectForKey:@"chatAry"]];
            
            if (![CMCommon stringIsNull:self.roomId]) {
                
                for (int i = 0; i<self.myroomAry.count; i++) {
                    RoomChatModel *obj= [self.myroomAry objectAtIndex:i];
                    
                    if ([obj.roomId isEqualToString:self.roomId]) {
                        [self setTitle:obj.roomName];
                        break ;
                    }
                }
            }
            
        }
    };
}

@end
