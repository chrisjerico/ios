//
//  NSDate+Millisecond.h
//  C
//
//  Created by fish on 2018/11/19.
//  Copyright © 2018 fish. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (Millisecond)

@property (readonly) NSTimeInterval millisecondIntervalSince1970;           /**<    获取毫秒时间戳 */

+ (instancetype)dateWithMillisecondIntervalSince1970:(NSTimeInterval)secs;  /**<    从毫秒时间戳中生成NSDate */

@end

NS_ASSUME_NONNULL_END
