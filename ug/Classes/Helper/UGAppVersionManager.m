
//
//  UGAppVersionManager.m

#import "UGAppVersionManager.h"
#import "NSString+ST.h"
#import "UGAPPVersionModel.h"
#import "QDAlertView.h"

static NSString *kLastPromptDate = @"kNowTimeKey";
static NSString *kVersionModel = @"VersionModel";

@implementation UGAppVersionManager
+ (UGAppVersionManager *)shareInstance {
    static UGAppVersionManager *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[[super class] alloc] init];
    });
    return shareInstance;
}

//请求版本信息
- (void)updateVersionApi:(BOOL)promptAlreadyLatest completion:(nullable void (^)(BOOL, BOOL))completion {
#ifdef APP_TEST
    if (!promptAlreadyLatest) {
        if (completion) 
            completion(false, false);
        return;
    }
#endif
        
    UGAPPVersionModel *vm = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:kVersionModel]];
    // 若本地有强更新数据，则直接弹窗再拉请求
    BOOL showBuffer = vm.needForce;
    if (showBuffer) {
        [self showAlert:vm promptAlreadyLatest:promptAlreadyLatest completion:completion];
    }
    
    promptAlreadyLatest ? [SVProgressHUD show] : nil;
    WeakSelf;
    [CMNetwork checkVersionWithParams:@{@"device":@"ios"} completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            promptAlreadyLatest ? [SVProgressHUD dismiss] : nil;
            UGAPPVersionModel *vm = model.data;
            [[NSUserDefaults standardUserDefaults] setValue:[NSKeyedArchiver archivedDataWithRootObject:vm] forKey:kVersionModel];
            [[NSUserDefaults standardUserDefaults] synchronize];
            if (!showBuffer) {
                [weakSelf showAlert:vm promptAlreadyLatest:promptAlreadyLatest completion:completion];
            }
        } failure:^(id msg) {
            promptAlreadyLatest ? [SVProgressHUD showErrorWithStatus:msg] : nil;
        }];
    }];
}

// 弹框提示更新
- (void)showAlert:(UGAPPVersionModel *)vm promptAlreadyLatest:(BOOL)promptAlreadyLatest completion:(nullable void (^)(BOOL, BOOL))completion {
    __block BOOL __showUpdated = false;
    BOOL isForce = vm.needForce;
    if (vm.hasUpdate) {
        NSString *updateContent = vm.updateContent.length ? vm.updateContent : @"检测到新版本，更新体验全新活动！";
        NSArray *btnTitles = isForce ? @[@"去升级"] : @[@"取消", @"去升级"];
        
        void (^updateApp)(void) = ^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:vm.downloadUrl]];
        };
        void (^showAlert)(void) = ^{
            __showUpdated = true;
            
            if (promptAlreadyLatest && Skin1.isBlack) {
                UIColor *blueColor = [UIColor colorWithRed:90/255.0f green:154/255.0f blue:239/255.0f alpha:1.0f];
                LEEBaseConfigModel *alert =  [LEEAlert alert].config
                .LeeAddTitle(^(UILabel *label) {
                    label.text = @"新版本上线";
                    label.textColor = [UIColor whiteColor];
                })
                .LeeAddContent(^(UILabel *label) {
                    label.text = updateContent;
                    label.textColor = [UIColor whiteColor];
                })
                .LeeHeaderColor(Skin1.bgColor)
                .LeeAddAction(^(LEEAction *action) {
                    action.type = LEEActionTypeDefault;
                    action.title = @"去升级";
                    action.titleColor = blueColor;
                    action.backgroundColor = Skin1.bgColor;
                    action.clickBlock = ^{
                        updateApp();
                    };
                });
                if (isForce) {
                    alert = alert.LeeAddAction(^(LEEAction *action) {
                        action.type = LEEActionTypeCancel;
                        action.title = @"取消";
                        action.titleColor = blueColor;
                        action.backgroundColor = Skin1.bgColor;
                        action.clickBlock = ^{
                        };
                    });
                }
                alert.LeeShow();
            }
            else{
                UIAlertController *ac = [AlertHelper showAlertView:@"新版本上线" msg:updateContent btnTitles:btnTitles];
                [ac setActionAtTitle:@"去升级" handler:^(UIAlertAction *aa) {
                    updateApp();
                }];
            }
        };
        
        if (isForce) {
            // 强制更新
            showAlert();
            if (OBJOnceToken(self)) {
                [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillEnterForegroundNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
                    showAlert();
                }];
            }
        }
        else if (promptAlreadyLatest) {
            // 用户点击了版本更新按钮
            showAlert();
        } else {
            NSString *verKey = [NSString stringWithFormat:@"ver-%@", vm.versionCode];
            BOOL isPrompted = [[NSUserDefaults standardUserDefaults] boolForKey:verKey];//此版本是否有提示过
            
            // 若是客户手动配置的则直接提示
            BOOL isManual = !isPrompted && [vm.versionCode isEqualToString:vm.versionName];
            // 距离上次弹框已经过了半个月会再次提示
            BOOL isTimeout = ({
                CGFloat interval = (isPrompted ? 25 : 15) * 24 * 3600;
                fabs([[NSDate date] timeIntervalSinceDate:[[NSUserDefaults standardUserDefaults] objectForKey:kLastPromptDate]]) > interval;
            });
            
            if (isManual || isTimeout) {
                [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kLastPromptDate];
                [[NSUserDefaults standardUserDefaults] setBool:true forKey:verKey];
                showAlert();
            }
        }
    }
    // 已是最新版本
    else if (promptAlreadyLatest) {
        if (Skin1.isBlack) {
          UIColor *blueColor = [UIColor colorWithRed:90/255.0f green:154/255.0f blue:239/255.0f alpha:1.0f];
          [LEEAlert alert].config
           .LeeAddTitle(^(UILabel *label) {
              label.text = @"新版本上线";
              label.textColor = [UIColor whiteColor];
           })
          .LeeAddContent(^(UILabel *label) {
              label.text = @"您已经是最新版本！";
              label.textColor = [UIColor whiteColor];
           })
          .LeeHeaderColor(Skin1.bgColor)
          .LeeAddAction(^(LEEAction *action) {
              action.type = LEEActionTypeCancel;
              action.title = @"确定";
              action.titleColor = blueColor;
              action.backgroundColor = Skin1.bgColor;
              action.clickBlock = ^{
              };
          })
          .LeeShow(); // 设置完成后 别忘记调用Show来显示
      }
      else{
          [AlertHelper showAlertView:@"新版本上线" msg:@"您已经是最新版本！" btnTitles:@[@"确定"]];
      }
    }
    if (completion)
        completion(__showUpdated, isForce);
}

@end

