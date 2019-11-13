//
//  UGSkinManagers+Lottery.m
//  ug
//
//  Created by ug on 2019/11/12.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGSkinManagers+Lottery.h"
#import "NSObject+Utils.h"
#import "JRSwizzle.h"
#import "Aspects.h"
#import <objc/runtime.h>
#import "UGSSCLotteryController.h"           // 时时彩
#import "UGGD11X5LotteryController.h"        // 广东11选5
#import "UGBJKL8LotteryController.h"         // 北京快乐8
#import "UGGDKL10LotteryController.h"        //广东快乐10
#import "UGJSK3LotteryController.h"          //江苏快3
#import "UGHKLHCLotteryController.h"         //香港六合彩
#import "UGBJPK10LotteryController.h"        //北京PK10
#import "UGQXCLotteryController.h"           //七星彩
#import "UGPCDDLotteryController.h"          //PC蛋蛋
#import "UGFC3DLotteryController.h"          //福彩3D
#import "UGPK10NNLotteryController.h"        //PK10牛牛
@implementation UGSkinManagers (Lottery)


- (void)skinLottery  {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *clsArray = @[UGSSCLotteryController.class,
                              UGGD11X5LotteryController.class,
                              UGBJKL8LotteryController.class,
                              UGGDKL10LotteryController.class,
                              UGJSK3LotteryController.class,
                              UGHKLHCLotteryController.class,
                              UGBJPK10LotteryController.class,
                              UGQXCLotteryController.class,
                              UGPCDDLotteryController.class,
                              UGFC3DLotteryController.class,
                              UGPK10NNLotteryController.class,
        ];
        [UIViewController aspect_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionAfter usingBlock:^(id <AspectInfo> aspectInfo, BOOL animated ) {
//                   NSLog(@"%@", aspectInfo);
//                   NSLog(@"%d", animated);

            if ([clsArray containsObject:[aspectInfo.instance class]]) {
                 NSLog(@"%@-->:%@", @"Appear 下注界面:😜😜😜", NSStringFromClass([aspectInfo.instance class]));
                UIViewController *vc = (UIViewController *)aspectInfo.instance;
                FastSubViewCode(vc.view);
                if ([Skin1.skitType isEqualToString:@"黑色模板"]) {
                    vc.view.backgroundColor =  Skin1.bgColor;
                    [subView(@"上背景View") setBackgroundColor:Skin1.bgColor];
                    [subLabel(@"期数label") setTextColor:Skin1.textColor1];
                    [subLabel(@"聊天室label") setTextColor:Skin1.textColor1];
                    [subLabel(@"线label") setBackgroundColor:Skin1.textColor1];
                    [subView(@"中间view") setBackgroundColor:Skin1.bgColor];
                    [[vc valueForKey:@"nextIssueLabel"] setTextColor:Skin1.textColor1];
                    [[vc valueForKey:@"closeTimeLabel"] setTextColor:Skin1.textColor1];
                    [[vc valueForKey:@"openTimeLabel"] setTextColor:Skin1.textColor1];
                    [subLabel(@"中间线label") setBackgroundColor:Skin1.textColor1];
                    [[vc valueForKey:@"tableView"] setBackgroundColor:[UIColor clearColor]];
                    
                } else {
                    vc.view.backgroundColor =  [UIColor whiteColor];
                    [subView(@"上背景View") setBackgroundColor: [UIColor whiteColor]];
                    [subLabel(@"期数label") setTextColor: [UIColor blackColor]];
                    [subLabel(@"聊天室label") setTextColor:[UIColor blackColor]];
                    [subLabel(@"线label") setBackgroundColor:[UIColor lightGrayColor]];
                    [[vc valueForKey:@"nextIssueLabel"] setTextColor:[UIColor blackColor]];
                    [[vc valueForKey:@"closeTimeLabel"] setTextColor:[UIColor blackColor]];
                    [[vc valueForKey:@"openTimeLabel"] setTextColor:[UIColor blackColor]];
                    [subLabel(@"中间线label") setBackgroundColor:[UIColor lightGrayColor]];
                    [[vc valueForKey:@"tableView"] setBackgroundColor:[UIColor whiteColor]];
                }
                // 处理OpenLabel
               void (^block1)(id<AspectInfo>) = ^(id<AspectInfo> aspectInfo) {
                   if ([clsArray containsObject:[aspectInfo.instance class]]) {
                       UIViewController *vc = (UIViewController *)aspectInfo.instance;
                       UILabel *openTimeLabel = [vc valueForKey:@"openTimeLabel"];
                       if ([Skin1.skitType isEqualToString:@"黑色模板"]) {
                              if (openTimeLabel.text.length) {
                                  NSMutableAttributedString *abStr = [[NSMutableAttributedString alloc] initWithString:openTimeLabel.text];
                                  [abStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(3, openTimeLabel.text.length - 3)];
                                  openTimeLabel.attributedText = abStr;
                              }
                       } else {
                              if (openTimeLabel.text.length) {
                                  NSMutableAttributedString *abStr = [[NSMutableAttributedString alloc] initWithString:openTimeLabel.text];
                                  [abStr addAttribute:NSForegroundColorAttributeName value:Skin1.navBarBgColor range:NSMakeRange(3, openTimeLabel.text.length - 3)];
                                  openTimeLabel.attributedText = abStr;
                              }
                       }
                   }
               };
              [[aspectInfo.instance class] aspect_hookSelector:@selector(updateOpenLabel ) withOptions:AspectPositionAfter usingBlock:block1 error:nil];
            }
        }
        error:NULL];
    });
}




@end
