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

+(Global *)getInstanse;

@end

NS_ASSUME_NONNULL_END
