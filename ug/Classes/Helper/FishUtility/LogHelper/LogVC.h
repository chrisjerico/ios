//
//  LogVC.h
//  C
//
//  Created by fish on 2018/5/17.
//  Copyright © 2018年 fish. All rights reserved.
//

#import <UIKit/UIKit.h>

// 当 DEBUG 或 APP_TEST 时，启用LogVC
#if defined(DEBUG) || defined(APP_TEST)
//#define NSLog(s, ...) {NSString *log = [NSString stringWithFormat:(s), ##__VA_ARGS__];[LogVC addLog:log];NSLog( @"%@", log);}

@interface LogVC : UIViewController

+ (void)enableLogVC;

+ (void)addRequestModel:(CCSessionModel *)sm;
+ (void)addLog:(NSString *)log;
@end



#else
#define NSLog(s, ...) {}
#endif
