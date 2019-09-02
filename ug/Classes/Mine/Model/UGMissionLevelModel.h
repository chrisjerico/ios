//
//  UGMissionLevelModel.h
//  ug
//
//  Created by ug on 2019/5/22.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGMissionLevelModel : UGModel

@property (nonatomic, strong) NSString *checkinCards;
@property (nonatomic, strong) NSString *integral;
@property (nonatomic, strong) NSString *levelDesc;
@property (nonatomic, strong) NSString *levelName;
@property (nonatomic, strong) NSString *levelTitle;
@property (nonatomic, strong) NSString *amount;

@property (nonatomic, assign) NSInteger level;

@end

NS_ASSUME_NONNULL_END
