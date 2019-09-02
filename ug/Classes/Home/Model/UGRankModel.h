//
//  UGRankModel.h
//  ug
//
//  Created by ug on 2019/6/23.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UGRankModel <NSObject>

@end
@interface UGRankModel : UGModel<UGRankModel>
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *coin;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *actionTime;

@end

@interface UGRankListModel : UGModel
@property (nonatomic, strong) NSArray<UGRankModel> *list;
@property (nonatomic, assign) BOOL show;

@end

NS_ASSUME_NONNULL_END
