//
//  HomeFloatingButtonsView.m
//  UGBWApp
//
//  Created by fish on 2020/10/21.
//  Copyright © 2020 ug. All rights reserved.
//

#import "HomeFloatingButtonsView.h"
#import "UGredEnvelopeView.h"
#import "UGredActivityView.h"
#import "DZPMainView.h"

#import "EggFrenzyViewController.h"
#import "ScratchController.h"
#import "UGTaskNoticeView.h"
#import "CMTimeCommon.h"

@interface HomeFloatingButtonsView ()

@property (weak, nonatomic) IBOutlet UIStackView *topStackView;
@property (weak, nonatomic) IBOutlet UIStackView *leftStackView;
@property (weak, nonatomic) IBOutlet UIStackView *rightStackView;

@property (nonatomic, strong) NSArray <UGredEnvelopeView *>*tops;
@property (nonatomic, strong) NSArray <UGredEnvelopeView *>*lefts;
@property (nonatomic, strong) NSArray <UGredEnvelopeView *>*rights;

//悬浮窗
@property (nonatomic, strong)  UGredEnvelopeView *uUpperLeftView;   /**<   手机端浮窗1  左上 */
@property (nonatomic, strong)  UGredEnvelopeView *ulowerLefttView;  /**<   手机端浮窗2  左下 */
@property (nonatomic, strong)  UGredEnvelopeView *uUpperRightView;  /**<   手机端浮窗3  右上 */
@property (nonatomic, strong)  UGredEnvelopeView *uLowerRightView;  /**<   手机端浮窗4  右下 */
@property (nonatomic, strong)  UGredEnvelopeView *bigWheelView;     /**<   大转盘 */
@property (nonatomic, strong)  UGredEnvelopeView *goldEggView;      /**<   砸金蛋 */
@property (nonatomic, strong)  UGredEnvelopeView *scratchView;      /**<   刮刮乐 */
@property (nonatomic, strong)  UGredEnvelopeView *uGredEnvelopeView;/**<   红包浮动按钮 */

@property (nonatomic, strong)  UGredActivityView *uGredActivityView;/**<   红包弹框 */

@property (nonatomic, strong)  UGredEnvelopeView *taskView;/**<   任务浮动按钮 */

@end



@implementation HomeFloatingButtonsView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // c206,左上角135，刮刮乐、砸金蛋、大转盘、
    // 右上角135，红包
    // 右上角255，大转盘
    // 左上角360，刮刮乐、砸金蛋
    // 左上角255或大转盘底下，左上、右上、左下、右下
    
    SANotificationEventSubscribe(UGNotificationLoginComplete, self, ^(typeof (self) self, id obj) {
      
//        [self getactivityCratchList];   // 刮刮乐
//        [self getactivityGoldenEggList];// 砸金蛋
//        [self getactivityTurntableList];// 大转盘
//        [self getCheckinListData];      // 红包数据
        [self getactivityTurntableList];    // 大转盘
        [self getactivityGoldenEggList];    // 砸金蛋
        [self getactivityCratchList];       // 刮刮乐
        [self getCheckinListData];  // 红包数据
        [self getfloatAdsList];     // 首页左右浮窗
        [self getActivitySettings]; // 红包转盘刮刮乐砸金蛋图片
        [self getSystemConfig];
    });
    
    SANotificationEventSubscribe(UGNotificationRedPageComplete, self, ^(typeof (self) self, id obj) {

        [self showRedpage];      // show红包
    });
    
    BOOL (^checkLogin)(void) = ^BOOL {
        if (!UGLoginIsAuthorized()) {
            UIAlertController *ac = [AlertHelper showAlertView:@"温馨提示" msg:@"您还未登录" btnTitles:@[@"取消", @"马上登录"]];
            [ac setActionAtTitle:@"马上登录" handler:^(UIAlertAction *aa) {
                UGLoginAuthorize(^(BOOL isFinish) {
                    if (!isFinish)
                        return ;
                });
            }];
            return false;
        }
        if ([UGUserModel currentUser].isTest) {
            UIAlertController *ac = [AlertHelper showAlertView:@"温馨提示" msg:@"请先登录您的正式账号" btnTitles:@[@"取消", @"马上登录"]];
            [ac setActionAtTitle:@"马上登录" handler:^(UIAlertAction *aa) {
                SANotificationEventPost(UGNotificationShowLoginView, nil);
            }];
            return false;
        }
        return true;
    };
    void (^cancelClickBlock)(UGredEnvelopeView *) = ^(UGredEnvelopeView *rev) {
        rev.hidden = true;
    };
    
    // 红包事件
    __weakSelf_(__self);
    {
        self.uGredEnvelopeView = [[UGredEnvelopeView alloc] initWithFrame:CGRectMake(UGScreenW-80, 135, 70, 70)];
        self.uGredEnvelopeView.cancelClickBlock = cancelClickBlock;
        self.uGredEnvelopeView.redClickBlock = ^(void) {
            if (!checkLogin()) return;
            
            NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid};
            [SVProgressHUD showWithStatus:nil];
            [CMNetwork activityRedBagDetailWithParams:params completion:^(CMResult<id> *model, NSError *err) {
                [CMResult processWithResult:model success:^{
                    [SVProgressHUD dismiss];
                    [__self.uGredEnvelopeView setitem:(UGRedEnvelopeModel*)model.data showImg:NO];
                    
                    CGFloat h = UGScreenW-50+150;
                    __self.uGredActivityView = [[UGredActivityView alloc] initWithFrame:CGRectMake(20, (APP.Height-h-10)/2, UGScreenW-50, h) ];
                    __self.uGredActivityView.item = (UGRedEnvelopeModel*)model.data;
                    if ((UGRedEnvelopeModel*)model.data) {
                        [__self.uGredActivityView show];
                    }
                } failure:^(id msg) {
                    [SVProgressHUD showErrorWithStatus:msg];
                }];
            }];
        };
        
     
    }
    
    
#pragma mark 砸金蛋
    {//砸金蛋
        self.goldEggView = [[UGredEnvelopeView alloc] initWithFrame:CGRectMake(UGScreenW-80, 150, 70, 70) ];
        self.goldEggView.cancelClickBlock = cancelClickBlock;
        self.goldEggView.redClickBlock = ^(void) {
            if (!checkLogin()) return;
            
            EggFrenzyViewController *vc = [[EggFrenzyViewController alloc] init];
            vc.item = (DZPModel*)__self.goldEggView.itemData;
            vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [[UINavigationController current] presentViewController:vc animated:true completion:nil];
            
        };
    }
    
    
#pragma mark 大转盘
    {   //大转盘
        self.bigWheelView = [[UGredEnvelopeView alloc] initWithFrame:CGRectMake(UGScreenW-80, 150, 95, 95) ];
        self.bigWheelView.cancelClickBlock = cancelClickBlock;
        self.bigWheelView.redClickBlock = ^(void) {
            if (!checkLogin()) return;
            
            DZPModel *banner = (DZPModel*)__self.bigWheelView.itemData;
            DZPMainView *recordVC = [[DZPMainView alloc] initWithFrame:CGRectMake(0, 0, APP.Width-60, APP.Height-60)];
            
            CGPoint showCenter = CGPointMake(APP.Width/2,APP.Height/2);
            [SGBrowserView showMoveView:recordVC moveToCenter:showCenter];
            recordVC.item = banner;
        };
    }
    
#pragma mark 刮刮乐+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
    {
        self.scratchView = [[UGredEnvelopeView alloc] initWithFrame:CGRectZero];
        self.scratchView.cancelClickBlock = cancelClickBlock;
        self.scratchView.redClickBlock = ^(void) {
            if (!checkLogin()) return;

            ScratchController * vc = [[ScratchController alloc] init];
            vc.item = __self.scratchView.scratchDataModel;
            vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [[UINavigationController current] presentViewController:vc animated:true completion:nil];

        };
  
    
       
    }
    
#pragma mark 任务
    {//任务
        self.taskView = [[UGredEnvelopeView alloc] initWithFrame:CGRectMake(UGScreenW-80, 150, 70, 70) ];
        self.taskView.cancelClickBlock = cancelClickBlock;
        self.taskView.redClickBlock = ^(void) {
            if (!checkLogin()) return;
            CGFloat h = UGScerrnH - APP.StatusBarHeight - APP.BottomSafeHeight - 150;
            UGTaskNoticeView *notiveView = [[UGTaskNoticeView alloc] initWithFrame:CGRectMake(25, (UGScerrnH-h)/2, UGScreenW - 50, h)];
            [notiveView show];
        };
    }
    
#pragma 悬浮按钮
    // 手机悬浮按钮
    {
        //左上
        self.uUpperLeftView = [[UGredEnvelopeView alloc] initWithFrame:CGRectMake(UGScreenW-100, 150, 95, 95) ];
        self.uUpperLeftView.cancelClickBlock = cancelClickBlock;
        self.uUpperLeftView.redClickBlock = ^(void) {
            UGhomeAdsModel *banner = __self.uUpperLeftView.itemSuspension;
            BOOL ret = [NavController1 pushViewControllerWithLinkCategory:[banner.linkCategory integerValue] linkPosition:[banner.linkPosition integerValue]];
        };
        
        //左下
        self.ulowerLefttView = [[UGredEnvelopeView alloc] initWithFrame:CGRectMake(UGScreenW-100, 150, 95, 95) ];
        self.ulowerLefttView.cancelClickBlock = cancelClickBlock;
        self.ulowerLefttView.redClickBlock = ^(void) {
            UGhomeAdsModel *banner = __self.ulowerLefttView.itemSuspension;
            BOOL ret = [NavController1 pushViewControllerWithLinkCategory:[banner.linkCategory integerValue] linkPosition:[banner.linkPosition integerValue]];
        };
        
        
        //右上
        self.uUpperRightView = [[UGredEnvelopeView alloc] initWithFrame:CGRectMake(UGScreenW-100, 150, 95, 95) ];
        self.uUpperRightView.cancelClickBlock = cancelClickBlock;
        self.uUpperRightView.redClickBlock = ^(void) {
            UGhomeAdsModel *banner = __self.uUpperRightView.itemSuspension;
            BOOL ret = [NavController1 pushViewControllerWithLinkCategory:[banner.linkCategory integerValue] linkPosition:[banner.linkPosition integerValue]];
        };
        
        //右下
        self.uLowerRightView = [[UGredEnvelopeView alloc] initWithFrame:CGRectMake(UGScreenW-100, 150, 95, 95) ];
        self.uLowerRightView.cancelClickBlock = cancelClickBlock;
        self.uLowerRightView.redClickBlock = ^(void) {
            UGhomeAdsModel *banner = __self.uLowerRightView.itemSuspension;
            BOOL ret = [NavController1 pushViewControllerWithLinkCategory:[banner.linkCategory integerValue] linkPosition:[banner.linkPosition integerValue]];
        };
    }

}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    if (!self.superview) return;
    
    self.alpha = 0;
    self.userInteractionEnabled = false;
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        CGFloat top = APP.isNewLocation ? 135 : MIN(MAX(APP.Height-475, 0), 135);
        if ([APP.SiteId isEqualToString:@"c085"]) {
            top = 160;
        } else if ([APP.SiteId isEqualToString:@"c117"]) {
            top = 125;
        }
//#ifdef APP_TEST
//        top = 160;
//#endif
        make.left.right.equalTo(self.superview);
        make.top.equalTo(self.superview).offset(top);
        make.height.mas_equalTo(500);
    }];
    
    
    if (OBJOnceToken(self)) {
        if (APP.isNewLocation) {
            
            _tops = @[_scratchView, _goldEggView, _bigWheelView, _uGredEnvelopeView];
            _lefts = @[_uUpperLeftView, _ulowerLefttView];
            _rights = @[_uUpperRightView, _uLowerRightView];
        } else {
            _topStackView.superview.hidden = true;
            BOOL isLogin = UGLoginIsAuthorized();
            if (isLogin) {
                _lefts = @[_scratchView, _uUpperLeftView, _ulowerLefttView];

            } else {
                _lefts = @[ _uUpperLeftView, _ulowerLefttView];
            }
           
            
            _rights = @[_uGredEnvelopeView,_taskView, _bigWheelView, _goldEggView, _uUpperRightView, _uLowerRightView];
            
            if ([APP.SiteId isEqualToString:@"c150"]) {
                _rights = @[_uGredEnvelopeView,_taskView, _goldEggView, _uUpperRightView, _uLowerRightView, (id)[UIView new], _bigWheelView];
            }

        }
        
        __weakSelf_(__self);
        void (^addBtns)(NSArray *, UIStackView *) = ^(NSArray *btns, UIStackView *sv) {
            [sv removeAllSubviews];
            for (UGredEnvelopeView *btn in btns) {
                UIView *v = [UIView new];
                [sv addArrangedSubview:v];
                [v mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.height.mas_equalTo(85);
                }];
                
                [__self.superview addSubview:btn];
                btn.hidden = true;

                if ([APP.SiteId isEqualToString:@"c085"] && btn == __self.uGredEnvelopeView) {
                    [v mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.width.height.mas_equalTo(120);
                    }];
                } else if ([APP.SiteId isEqualToString:@"c117"] && btn == __self.uGredEnvelopeView) {
                    [v mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.width.height.mas_equalTo(100);
                    }];
                }
//#ifdef APP_TEST
//                if (btn == __self.uGredEnvelopeView) {
//                    [v mas_remakeConstraints:^(MASConstraintMaker *make) {
//                        make.width.height.mas_equalTo(120);
//                    }];
//                }
//#endif
                [btn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.center.equalTo(v);
                    make.width.height.equalTo(v);
                }];
            }
        };
        addBtns(_tops, _topStackView);
        addBtns(_lefts, _leftStackView);
        addBtns(_rights, _rightStackView);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            for (UGredEnvelopeView *rev in [[__self.tops arrayByAddingObjectsFromArray:__self.lefts] arrayByAddingObjectsFromArray:__self.rights]) {
                [__self.superview bringSubviewToFront:rev];
            }
        });
    }
}

- (void)setFloatingButtonView:(UGredEnvelopeView *)btn hidden:(BOOL)hidden {
    btn.hidden = hidden;
    
    if ([@[_uUpperLeftView, _ulowerLefttView, _uUpperRightView, _uLowerRightView] containsObject:btn]) {
        return;
    }
    void (^setHidden)(NSArray *, UIStackView *) = ^(NSArray *btns, UIStackView *sv) {
        if ([btns containsObject:btn]) {
            sv.arrangedSubviews[[btns indexOfObject:btn]].hidden = hidden;
        }
    };
    setHidden(_tops, _topStackView);
    setHidden(_lefts, _leftStackView);
    setHidden(_rights, _rightStackView);
}

- (void)reloadData:(void (^)(BOOL succ))completion {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self getactivityTurntableList];    // 大转盘
        [self getactivityGoldenEggList];    // 砸金蛋
        [self getactivityCratchList];       // 刮刮乐
        [self getCheckinListData];  // 红包数据
        [self getfloatAdsList];     // 首页左右浮窗
        [self getActivitySettings]; // 红包转盘刮刮乐砸金蛋图片
        [self getSystemConfig];

    });
}


#pragma mark - load Data
//show红包
-(void)showRedpage {
    if (self.uGredEnvelopeView.redClickBlock) {
        self.uGredEnvelopeView.redClickBlock();
    }
}

//得到红包详情数据
- (void)getCheckinListData {
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid};
    [SVProgressHUD showWithStatus:nil];
    WeakSelf;
    [CMNetwork activityRedBagDetailWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [SVProgressHUD dismiss];
        [CMResult processWithResult:model success:^{
            UGRedEnvelopeModel *rem = model.data;
            [weakSelf.uGredEnvelopeView setitem:rem showImg:NO];
            if ([rem.show_time intValue]) {
                NSString *time1 = [CMTimeCommon timestampSwitchTime:[rem.show_time intValue] andFormatter:@"yyyy-MM-dd HH:mm"];
                NSString *time2 = [CMTimeCommon currentDateStringWithFormat:@"yyyy-MM-dd HH:mm"];
                NSDate *date1 = [CMTimeCommon dateForStr:time1 format:@"yyyy-MM-dd HH:mm"];
                NSDate *date2 = [CMTimeCommon dateForStr:time2 format:@"yyyy-MM-dd HH:mm"];
                
                int k =  [CMTimeCommon compareOneDay:date2 withAnotherDay:date1 formatter:@"yyyy-MM-dd HH:mm"];
                [weakSelf setFloatingButtonView:weakSelf.uGredEnvelopeView hidden:k < 0];
            } else {
                [weakSelf setFloatingButtonView:weakSelf.uGredEnvelopeView hidden:true];
            }
        } failure:^(id msg) {
            [weakSelf setFloatingButtonView:weakSelf.uGredEnvelopeView hidden:true];
            [SVProgressHUD dismiss];
        }];
    }];
}

//手机浮窗
- (void)getfloatAdsList {
    WeakSelf;
    [CMNetwork systemfloatAdsWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 需要在主线程执行的代码
                [SVProgressHUD dismiss];
                NSLog(@"数据=%@",model.data);
                NSMutableArray *mutArr = model.data;
                if (mutArr.count) {
                    
                    NSMutableArray *posArr  = [NSMutableArray new];
                    for (UGhomeAdsModel *banner in mutArr) {
                        [posArr addObject:[NSString stringWithFormat:@"%d",banner.position]];
                    }
                    weakSelf.uUpperLeftView.hidden = ![posArr containsObject: @"1"];
                    weakSelf.ulowerLefttView.hidden = ![posArr containsObject: @"2"];
                    weakSelf.uUpperRightView.hidden = ![posArr containsObject: @"3"];
                    weakSelf.uLowerRightView.hidden = ![posArr containsObject: @"4"];
                    weakSelf.uUpperLeftView.itemSuspension = [mutArr objectWithValue:@"1" keyPath:@"position"];
                    weakSelf.ulowerLefttView.itemSuspension = [mutArr objectWithValue:@"2" keyPath:@"position"];
                    weakSelf.uUpperRightView.itemSuspension = [mutArr objectWithValue:@"3" keyPath:@"position"];
                    weakSelf.uLowerRightView.itemSuspension = [mutArr objectWithValue:@"4" keyPath:@"position"];
                }
                else {
                    weakSelf.uUpperLeftView.hidden = YES;
                    weakSelf.ulowerLefttView.hidden = YES;
                    weakSelf.uUpperRightView.hidden = YES;
                    weakSelf.uLowerRightView.hidden = YES;
                }
            });
            
        } failure:^(id msg) {
            
        }];
    }];
}

//大转盘
- (void)getactivityTurntableList {
    WeakSelf;
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
    };
    [CMNetwork activityTurntableListWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        
        [CMResult processWithResult:model success:^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSLog(@"model = %@",model);
                NSArray <DZPModel *> *dzpArray = [NSArray new];
                // 需要在主线程执行的代码
                dzpArray = model.data;
                
                NSLog(@"dzpArray = %@",dzpArray);
                
                [weakSelf setFloatingButtonView:weakSelf.bigWheelView hidden:!dzpArray.count];
                if (dzpArray.count) {
                    
                    NSMutableArray *data =  [DZPModel mj_objectArrayWithKeyValuesArray:dzpArray];
                    DZPModel *obj = [data objectAtIndex:0];
                    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        // 需要在主线程执行的代码
                        weakSelf.bigWheelView.itemData = obj;
                    });
                }
            });
            
        } failure:^(id msg) {
            //            [SVProgressHUD showErrorWithStatus:msg];
            [weakSelf setFloatingButtonView:weakSelf.bigWheelView hidden:true];
        }];
    }];
}

#pragma mark +++++++++++++++++砸金蛋数据

-(void)getactivityGoldenEggList {
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid};
    WeakSelf
    [CMNetwork activityGoldenEggListWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSArray <DZPModel *> *dzpArray = [NSArray new];
                dzpArray = model.data;
                if (!dzpArray.count) {
                    return;
                }
                NSMutableArray *data =  [DZPModel mj_objectArrayWithKeyValuesArray:dzpArray];
                DZPModel *obj = [data objectAtIndex:0];
                weakSelf.goldEggView.itemData = obj;
                [weakSelf setFloatingButtonView:weakSelf.goldEggView hidden:false];
            });
        } failure:^(id msg) {
            [weakSelf setFloatingButtonView:weakSelf.goldEggView hidden:true];
            
        }];
    }];
    
}
#pragma mark +++++++++++++++++刮刮乐数据

-(void)getactivityCratchList {
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid};
    WeakSelf
    [CMNetwork activityScratchListWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                ScratchDataModel * scratchData = [[ScratchDataModel alloc] initWithDictionary:model.data error:nil];
                if (!scratchData.scratchList.count) {
                    return;
                }
                weakSelf.scratchView.scratchDataModel = scratchData;
                [weakSelf setFloatingButtonView:weakSelf.scratchView hidden:false];
            });
        } failure:^(id msg) {
            [weakSelf setFloatingButtonView:weakSelf.scratchView hidden:true];
        }];
    }];
    
}

//全部图片
- (void)getActivitySettings {
    WeakSelf;
    [CMNetwork activitySetWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 需要在主线程执行的代码
                [SVProgressHUD dismiss];
                NSLog(@"数据=%@",model.data);
                NSDictionary *dicData = model.data;
                // 红包
                if (![CMCommon stringIsNull:[dicData objectForKey:@"redBagLogo"]]) {// 红包
                    [weakSelf.uGredEnvelopeView.imgView sd_setImageWithURL:[NSURL URLWithString:[dicData objectForKey:@"redBagLogo"]] placeholderImage:[UIImage imageNamed:@"redpageImg"]];
                }
                else{
                    [weakSelf.uGredEnvelopeView.imgView setImage:[UIImage imageNamed:@"redpageImg"]];
                }
                
                // 转盘
                if (![CMCommon stringIsNull:[dicData objectForKey:@"turntableLogo"]]) {// 转盘
                    [weakSelf.bigWheelView.imgView sd_setImageWithURL:[NSURL URLWithString:[dicData objectForKey:@"turntableLogo"]] placeholderImage:[UIImage imageNamed:@"dzp_btn"]];
                }
                else{
                    [weakSelf.bigWheelView.imgView sd_setImageWithURL:[NSURL URLWithString:@"https://cdn01.mlqman.cn/views/home/images/c018dzp.gif"] placeholderImage:[UIImage imageNamed:@"dzp_btn"]];
                }
                // 刮刮乐
                if (![CMCommon stringIsNull:[dicData objectForKey:@"scratchOffLogo"]]) {
                    [weakSelf.scratchView.imgView sd_setImageWithURL:[NSURL URLWithString:[dicData objectForKey:@"scratchOffLogo"]] placeholderImage:[UIImage imageNamed:@"刮刮乐_悬浮按钮"]];
                }
                else{
                    [weakSelf.scratchView.imgView setImage:[UIImage imageNamed:@"刮刮乐_悬浮按钮"]];
                }
                // 砸金蛋
                if (![CMCommon stringIsNull:[dicData objectForKey:@"goldenEggLogo"]]) {
                    [weakSelf.goldEggView.imgView sd_setImageWithURL:[NSURL URLWithString:[dicData objectForKey:@"goldenEggLogo"]] placeholderImage:[UIImage imageNamed:@"砸金蛋_悬浮按钮"]];
                }
                else{
                    [weakSelf.goldEggView.imgView setImage:[UIImage imageNamed:@"砸金蛋_悬浮按钮"]];
                }

                
            });
            
        } failure:^(id msg) {
            
        }];
    }];
}


// 获取系统配置
- (void)getSystemConfig {
    WeakSelf;
    [CMNetwork getSystemConfigWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
       
        [CMResult processWithResult:model success:^{
            UGSystemConfigModel *config = model.data;
            UGSystemConfigModel.currentConfig = config;
            // UI更新代码
            // 任务
            if ([SysConf.missionPopUpSwitch isEqualToString:@"1"]) {
                [weakSelf  setFloatingButtonView:self.taskView hidden:NO];
                if (![CMCommon stringIsNull:SysConf.mission_logo]) {
                    [weakSelf.taskView.imgView sd_setImageWithURL:[NSURL URLWithString:SysConf.mission_logo] placeholderImage:[UIImage imageNamed:@"task_home"]];
                }
                else{
                    [weakSelf.taskView.imgView setImage:[UIImage imageNamed:@"task_home"]];
                }
            } else {
                [weakSelf  setFloatingButtonView:self.taskView hidden:YES];
            }
        } failure:^(id msg) {
            [weakSelf  setFloatingButtonView:self.taskView hidden:YES];
        }];
    }];
}
@end
