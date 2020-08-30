//
//  ScratchLogModel.h
//  UGBWApp
//
//  Created by xionghx on 2020/8/30.
//  Copyright © 2020 ug. All rights reserved.
//

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN
/**
"id" : "324",
"dml" : "1",
"uid" : "46",
"update_date" : "2020-08-30",
"amount" : "95.6740",
"open_time" : "1598740046",
"username" : "gf505",
"prize_name" : "手动赠送",
"pid" : "-2",
"add_time" : "1598739988",
"aid" : "14",
"status" : "1"
 */
@protocol ScratchLogModel <NSObject>



@end

@interface ScratchLogModel : UGModel<ScratchLogModel>
@property(nonatomic, strong)NSString * logID;
@property(nonatomic, strong)NSString * dml;
@property(nonatomic, strong)NSString * uid;
@property(nonatomic, strong)NSString * update_date;
@property(nonatomic, strong)NSString * amount;
@property(nonatomic, strong)NSString * open_time;
@property(nonatomic, strong)NSString * username;
@property(nonatomic, strong)NSString * prize_name;
@property(nonatomic, strong)NSString * pid;
@property(nonatomic, strong)NSString * aid;
@property(nonatomic, strong)NSString * add_time;
@property(nonatomic, strong)NSString * status;



@end

NS_ASSUME_NONNULL_END
