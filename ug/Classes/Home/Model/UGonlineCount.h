//
//  UGonlineCount.h
//  ug
//
//  Created by ug on 2019/9/27.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN

// APP在线人数Model
// {{LOCAL_HOST}}?c=system&a=onlineCount
@interface UGonlineCount : UGModel
@property (nonatomic, strong) NSNumber *onlineSwitch;       /**<      手机端在线人数显示开关。1=开启；0=关闭 */
@property (nonatomic, strong) NSNumber *onlineUserCount;    /**<      在线人数 */

@end

NS_ASSUME_NONNULL_END
