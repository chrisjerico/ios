//
//  UGlevelsModel.h
//  ug
//
//  Created by ug on 2019/9/7.
//  Copyright © 2019 ug. All rights reserved.
//
//"id":"2",
//            "levelName":"VIP2",
//            "levelTitle":"青铜",
//            "levelDesc":"",
//            "integral":"100",
//            "checkinCards":"0",
//            "params":""

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UGlevelsModel <NSObject>

@end

@interface UGlevelsModel : UGModel
@property (nonatomic, strong) NSString *levelsId;//
@property (nonatomic, strong) NSString *levelName;//
@property (nonatomic, strong) NSString *levelTitle;//
@property (nonatomic, strong) NSString *integral;//

@end

NS_ASSUME_NONNULL_END
