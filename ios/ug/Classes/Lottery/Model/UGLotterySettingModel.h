//
//  UGLotterySettingModel.h
//  ug
//
//  Created by ug on 2019/7/29.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN

//六合彩生肖
@protocol UGZodiacModel <NSObject>

@end
@interface UGZodiacModel : UGModel<UGZodiacModel>
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *nums;

@end

//六合彩设置
@interface UGLotterySettingModel : UGModel

@property (nonatomic, strong) NSArray<UGZodiacModel> *zodiacNums;

@property (nonatomic, strong) NSArray<UGZodiacModel> *tails;//0尾、1尾

@end

NS_ASSUME_NONNULL_END
