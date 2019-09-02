//
//  UGLotteryHistoryModel.h
//  ug
//
//  Created by ug on 2019/7/22.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGLotteryHistoryModel : UGModel
@property (nonatomic, strong) NSString *issue;
@property (nonatomic, strong) NSString *openTime;
@property (nonatomic, strong) NSString *num;
@property (nonatomic, strong) NSString *result;
@property (nonatomic, strong) NSString *gameType;
@property (nonatomic, strong) NSArray *winningPlayers;


@end

NS_ASSUME_NONNULL_END
