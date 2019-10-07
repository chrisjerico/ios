//
//  UGActivityGoldModel.h
//  ug
//
//  Created by ug on 2019/9/18.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol UGActivityGoldModel <NSObject>

@end

@interface UGActivityGoldModel : UGModel<UGActivityGoldModel>
@property (nonatomic, strong) NSString *mid;        /**<   id */
@property (nonatomic, strong) NSString *state;      
@property (nonatomic, strong) NSString *amount;     /**<   金额 */
@property (nonatomic, strong) NSString *updateTime; /**<   更新时间 */
@end

NS_ASSUME_NONNULL_END
