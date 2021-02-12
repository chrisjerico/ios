//
//  GoldEggLogModel.h
//  UGBWApp
//
//  Created by xionghx on 2020/8/27.
//  Copyright © 2020 ug. All rights reserved.
//

#import "UGModel.h"


NS_ASSUME_NONNULL_BEGIN

@protocol Prizeparam <NSObject>

@end

@interface Prizeparam : UGModel
@property (nonatomic, strong) NSString *prizeProbability;
@property (nonatomic, strong) NSNumber *update_time;
@property (nonatomic, strong) NSString *prizeAmount;
@property (nonatomic, strong) NSNumber *integralOld;
@property (nonatomic, strong) NSString *prizeType;
@property (nonatomic, strong) NSString *prizeIcon;
@property (nonatomic, strong) NSNumber *prizeId;
@property (nonatomic, strong) NSNumber *integral;
@property (nonatomic, strong) NSString *prizeMsg;
@property (nonatomic, strong) NSString *prizeName;
@property (nonatomic, strong) NSString *prizeflag;
@property (nonatomic, strong) NSString *prizeIconName;
@property (nonatomic, strong) NSString * logID;
@end

@protocol GoldEggLogModel <NSObject>

@end

@interface GoldEggLogModel : UGModel<GoldEggLogModel>
@property (nonatomic, strong) NSString * logID;

@property (nonatomic, strong) NSString *uid;
//@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSArray<Prizeparam *> *prize_param;
@property (nonatomic, strong) NSString *times;
@property (nonatomic, strong) NSString *aid;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *update_date;

@end


NS_ASSUME_NONNULL_END
