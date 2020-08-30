//
//  ScratchDataModel.h
//  UGBWApp
//
//  Created by xionghx on 2020/8/30.
//  Copyright © 2020 ug. All rights reserved.
//

#import "UGModel.h"
#import "ScratchParamModel.h"

NS_ASSUME_NONNULL_BEGIN


@protocol ScratchWinModel <NSObject>

@end

@interface ScratchWinModel : UGModel<ScratchWinModel>

@property(nonatomic, strong)NSString * amount;
@property(nonatomic, strong)NSString * scratchId;
@property(nonatomic, strong)NSString * add_time;
@property(nonatomic, strong)NSString * prize_name;
@property(nonatomic, strong)NSString * aid;
@end

@protocol ScratchModel <NSObject>

@end

@interface ScratchModel : UGModel<ScratchModel>
@property(nonatomic, strong)NSString * gameID;
@property(nonatomic, strong)NSString * start;
@property(nonatomic, strong)NSString * end;
@property(nonatomic, assign)NSInteger showType;
@property(nonatomic, strong)NSString * type;
@property(nonatomic, strong)NSDictionary * param;
@property(nonatomic, assign)NSInteger aviliableCount;
@end


@protocol ScratchDataModel <NSObject>

@end

@interface ScratchDataModel : UGModel<ScratchDataModel>
@property(nonatomic, strong)NSArray<ScratchWinModel*><ScratchWinModel> * scratchWinList;
@property(nonatomic, strong)NSArray<ScratchModel*><ScratchModel> * scratchList;

@end

NS_ASSUME_NONNULL_END
