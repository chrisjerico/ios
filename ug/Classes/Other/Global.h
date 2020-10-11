//
//  Global.h
//  ug
//
//  Created by ug on 2019/11/29.
//  Copyright © 2019 ug. All rights reserved.
//  用于放全局的对象

#import <Foundation/Foundation.h>
#import "UGYYPlatformGames.h"
NS_ASSUME_NONNULL_BEGIN

@interface Global : NSObject

@property (nonatomic, strong) NSArray <UGYYPlatformGames *>*lotterydataArray;/**<   彩票大厅的数据   全局使用" */

@property (nonatomic) float rebate;/**<   退水的数据   全局使用" */

@property (nonatomic, strong) NSString *DZPid; /**<   大转盘id   全局使用" */

@property (strong, nonatomic) NSString *LHgid; /**<  解码器游戏id*/

@property (nonatomic) BOOL hideTabBar; /**<  l002 首页跳转彩种隐藏tabbar*/

@property (nonatomic) BOOL isAllLottery; /**<  新彩票分组第一次进入展示全部菜种*/

+(Global *)getInstanse;

@end

NS_ASSUME_NONNULL_END
