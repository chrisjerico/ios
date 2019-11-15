
//
//  UGAppVersionManager.m

#import "UGAppVersionManager.h"
#import "NSString+ST.h"
#import "UGAPPVersionModel.h"
#import "QDAlertView.h"

@interface UGAppVersionManager ()
@property(nonatomic,strong) UGAPPVersionModel *versionModle;

@end

@implementation UGAppVersionManager
static NSInteger versionNumber = 102;
+(UGAppVersionManager *)shareInstance
{
    
    static UGAppVersionManager *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[[super class] alloc] init];
        
    });

    return shareInstance;
}

//请求版本信息
- (void)updateVersionApi:(BOOL)flag {
    [SVProgressHUD show];
    [CMNetwork checkVersionWithParams:@{@"device":@"ios"} completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            [SVProgressHUD dismiss];
            self.versionModle = model.data;
            [self upgradeHandel:flag];
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }];
}

//处理升级
- (void)upgradeHandel:(BOOL)flag {
    BOOL isForce = false;      // 是否强制升级
    BOOL hasUpdate = false; // 是否存在新版本
    
    NSArray *currentV = [APP.Version componentsSeparatedByString:@"."];
    NSArray *newestV = [self.versionModle.versionName componentsSeparatedByString:@"."];
    for (int i=0; i<4; i++) {
        NSString *v1 = currentV.count > i ? currentV[i] : nil;
        NSString *v2 = newestV.count > i ? newestV[i] : nil;
        if (v2.intValue > v1.intValue)
            hasUpdate = true;
        if (v2.intValue != v1.intValue)
            break;
    }
	
	if (hasUpdate){
        if (self.versionModle.switchUpdate) {
            isForce = YES;
        }
        
        NSString *updateContent = _versionModle.updateContent.length ? _versionModle.updateContent : @"检测到新版本，更新体验全新活动！";
        NSArray *btnTitles = isForce ? @[@"去升级"] : @[@"取消", @"去升级"];
        
        __weakSelf_(__self);
        if ([Skin1.skitType isEqualToString:@"黑色模板"]) {
            UIColor *blueColor = [UIColor colorWithRed:90/255.0f green:154/255.0f blue:239/255.0f alpha:1.0f];
            if (isForce) {
                 [LEEAlert alert].config
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
                        [__self updateFromAppStore];
                    };
                })
                .LeeShow(); // 设置完成后 别忘记调用Show来显示
            } else {
                [LEEAlert alert].config
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
                    action.type = LEEActionTypeCancel;
                    action.title = @"取消";
                    action.titleColor = blueColor;
                    action.backgroundColor = Skin1.bgColor;
                    action.clickBlock = ^{
                    };
                })
                .LeeAddAction(^(LEEAction *action) {
                    action.type = LEEActionTypeDefault;
                    action.title = @"去升级";
                    action.titleColor = blueColor;
                    action.backgroundColor = Skin1.bgColor;
                    action.clickBlock = ^{
                        [__self updateFromAppStore];
                    };
                })
                .LeeShow(); // 设置完成后 别忘记调用Show来显示
            }
        }
        else{
            UIAlertController *ac = [AlertHelper showAlertView:@"新版本上线" msg:updateContent btnTitles:btnTitles];
            [ac setActionAtTitle:@"去升级" handler:^(UIAlertAction *aa) {
                [__self updateFromAppStore];
            }];
        }
        

        
        if (!isForce) {
            [self rememberVersionNowTime];
        }
    } else if (flag) {
     
        if ([Skin1.skitType isEqualToString:@"黑色模板"]) {
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
}

//判断是否需要升级
-(BOOL)isUpgrade:(NSString *)versionCode{
    
    if([versionCode isBlank])
        return NO;
    NSString *appVersion = APP_VERSION;
    if ([APP_VERSION isEqualToString: versionCode]) {
        return NO;
    }
    
    NSArray *serverCodeArr = [versionCode componentsSeparatedByString:@"."];
    NSArray *localCodeArr = [ APP_VERSION componentsSeparatedByString:@"."];
    
    
    if ([serverCodeArr count] != [localCodeArr count]  ||  [serverCodeArr count] != 4  || [localCodeArr count] != 4 ) {
        return YES;
    }
    
    if ([[serverCodeArr objectAtIndex:0] intValue] > [[localCodeArr objectAtIndex:0] intValue]) {
        return YES;
    }else if([[serverCodeArr objectAtIndex:0] intValue] < [[localCodeArr objectAtIndex:0] intValue]){
        return NO;
    }
    
    
    if ([[serverCodeArr objectAtIndex:1] intValue] > [[localCodeArr objectAtIndex:1] intValue]) {
        return YES;
    }else if ([[serverCodeArr objectAtIndex:1] intValue] < [[localCodeArr objectAtIndex:1] intValue]) {
        return NO;
    }
    
    if ([[serverCodeArr objectAtIndex:2] intValue] > [[localCodeArr objectAtIndex:2] intValue]) {
        return YES;
    }else if ([[serverCodeArr objectAtIndex:2] intValue] < [[localCodeArr objectAtIndex:2] intValue]) {
        return NO;
    }
    
    if ([[serverCodeArr objectAtIndex:3] intValue] > [[localCodeArr objectAtIndex:3] intValue]) {
        return YES;
    }else if ([[serverCodeArr objectAtIndex:3] intValue] < [[localCodeArr objectAtIndex:3] intValue]) {
        return NO;
    }
    
    return NO;
}

//根据网络环境判断升级提示
-(void)updateFromAppStore{
    [self  goToAppStore];
    //    if ([[self getNetWorkStates] isEqualToString:@"WIFI"]) {
    //        [self  goToAppStore];
    //    }else{
    //        [QDAlertView showWithTitle:@"提示"
    //                           message:@"当前网络为非WIFI，是否继续下载？"
    //                 cancelButtonTitle:@"取消"
    //                  otherButtonTitle:@"继续"
    //                   completionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
    //                       if (buttonIndex != alertView.cancelButtonIndex) {
    //                           [self  goToAppStore];
    //                       }
    //                   }];
    //    }
    
}

-(void)goToAppStore{

    NSString *urlStr = self.versionModle.file;
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
    
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat: @"itms-services://?action=download-manifest&url=%@",@"https://dg.syni.com/yejin/manifest.plist"]]];
    
    
}

-(NSString *)getNetWorkStates{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
    NSString *state = [[NSString alloc]init];
    int netType = 0;
    //获取到网络返回码
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
            
            switch (netType) {
                case 0:
                    state = @"无网络";
                    //无网模式
                    break;
                case 1:
                    state = @"2G";
                    break;
                case 2:
                    state = @"3G";
                    break;
                case 3:
                    state = @"4G";
                    break;
                case 5:
                {
                    state = @"WIFI";
                }
                    break;
                default:
                    break;
            }
        }
    }
    //根据状态选择
    return state;
}


static NSString *kNowTimeKey = @"kNowTimeKey";
//保存最后一次提醒普通升级当前时间戳
- (void)rememberVersionNowTime {
    
    NSDate *nowDate = [NSDate date];
    
    [[NSUserDefaults standardUserDefaults]setObject:nowDate forKey:kNowTimeKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    //NSString *date2 = [NSString stringWithFormat:@"%ld", (long)[nowDate timeIntervalSince1970]];
    //NSLog(@"now Time == %@",date2);
}
//判断是否超过24小时
- (BOOL)isVersionUptateTimeMore24h{
    NSDate  *lastDate = [[NSUserDefaults standardUserDefaults] objectForKey:kNowTimeKey];
    if (lastDate == nil) {
        return NO;
    }
    NSTimeInterval time = [[NSDate date] timeIntervalSinceDate:lastDate];
    NSTimeInterval h24 = 24 *60 *60; //24小时
    //NSLog(@"since Time === %f",time);
    if (time > h24) {
        return YES;
    }
    return NO;
    
}

@end

