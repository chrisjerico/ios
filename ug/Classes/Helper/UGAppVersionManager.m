
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

+ (UGAppVersionManager *)shareInstance
{
    
    static UGAppVersionManager *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[[super class] alloc] init];
        
    });

    return shareInstance;
}

- (void)updateVersionNow:(BOOL)isNow {
    if (isNow) {
        [self updateVersionApi:NO];
    } else {
        //超过24小时再提示升级
        if ([[NSUserDefaults standardUserDefaults] boolForKey:IS_UPGRADE]) {
            if ([self isVersionUptateTimeMore24h]) {
                [self updateVersionApi:NO];
            }
        }
    }
}

//请求版本信息
- (void)updateVersionApi:(BOOL)flag {
    [CMNetwork checkVersionWithParams:@{@"device":@"ios"} completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            self.versionModle = model.data;
            [self upgradeHandel:flag];
            
        } failure:^(id msg) {
            
        }];
    }];
}

//处理升级
- (void)upgradeHandel:(BOOL)flag {
    BOOL isForce = NO;
    NSString *versionCode = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    if (![self.versionModle.versionName isEqualToString:versionCode]) {
        if (self.versionModle.switchUpdate)
            isForce = YES;
		
		NSString * updateContent;
		if (self.versionModle.updateContent.length > 0) {
			updateContent = self.versionModle.updateContent;
		} else {
			updateContent = @"检测到新版本，更新体验全新活动！";
		}
        
        if (!isForce)
        [self rememberVersionNowTime];
        
        UIAlertController *ac = [AlertHelper showAlertView:@"新版本上线" msg:updateContent btnTitles:isForce ? @[@"去升级"] : @[@"取消", @"去升级"]];
        [ac setActionAtTitle:@"去升级" handler:^(UIAlertAction *aa) {
            [self updateFromAppStore];
        }];
    } else if (flag) {
        [AlertHelper showAlertView:@"新版本上线" msg:@"您已经是最新版本！" btnTitles:@[@"确定"]];
    }
}

//判断是否需要升级
- (BOOL)isUpgrade:(NSString *)versionCode{
    
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
    } else if([[serverCodeArr objectAtIndex:0] intValue] < [[localCodeArr objectAtIndex:0] intValue]){
        return NO;
    }
    
    
    if ([[serverCodeArr objectAtIndex:1] intValue] > [[localCodeArr objectAtIndex:1] intValue]) {
        return YES;
    } else if ([[serverCodeArr objectAtIndex:1] intValue] < [[localCodeArr objectAtIndex:1] intValue]) {
        return NO;
    }
    
    if ([[serverCodeArr objectAtIndex:2] intValue] > [[localCodeArr objectAtIndex:2] intValue]) {
        return YES;
    } else if ([[serverCodeArr objectAtIndex:2] intValue] < [[localCodeArr objectAtIndex:2] intValue]) {
        return NO;
    }
    
    if ([[serverCodeArr objectAtIndex:3] intValue] > [[localCodeArr objectAtIndex:3] intValue]) {
        return YES;
    } else if ([[serverCodeArr objectAtIndex:3] intValue] < [[localCodeArr objectAtIndex:3] intValue]) {
        return NO;
    }
    
    return NO;
}

//根据网络环境判断升级提示
-(void)updateFromAppStore {
    [self  goToAppStore];
    //    if ([[self getNetWorkStates] isEqualToString:@"WIFI"]) {
    //        [self  goToAppStore];
    //    } else {
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

-(void)goToAppStore {

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
-(void)rememberVersionNowTime{
    
    NSDate *nowDate = [NSDate date];
    
    [[NSUserDefaults standardUserDefaults]setObject:nowDate forKey:kNowTimeKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    //NSString *date2 = [NSString stringWithFormat:@"%ld", (long)[nowDate timeIntervalSince1970]];
    //NSLog(@"now Time == %@",date2);
}
//判断是否超过24小时
-(BOOL)isVersionUptateTimeMore24h{
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
