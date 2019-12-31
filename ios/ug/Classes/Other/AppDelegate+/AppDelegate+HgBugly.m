//
//  AppDelegate+HgBugly.m
//  HgProjectFramework
//
//  Created by 予清沐 on 2019/8/2.
//  Copyright © 2019 予清沐. All rights reserved.
//

#import "AppDelegate+HgBugly.h"
#import <AvoidCrash/AvoidCrash.h>
static NSString *Bugly_ErrorName_AvoidCrash = @"AvoidCrash拦截的异常";
@implementation AppDelegate (HgBugly)

- (void)initBugly
{
    
    [self initAvoidCrash];
}

#pragma mark - AvoidCrash

- (void)initAvoidCrash
{
    [AvoidCrash makeAllEffective];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealwithCrashMessage:) name:AvoidCrashNotification object:nil];
}

- (void)dealwithCrashMessage:(NSNotification *)note {
     NSLog(@"%@",note.userInfo);

}
@end
