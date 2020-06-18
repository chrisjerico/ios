//
//  UGBetItemModel.h
//  ug
//
//  Created by ug on 2019/5/20.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UGBetItemModel <NSObject>

@end
@interface UGBetItemModel : UGModel<UGBetItemModel>

@property (nonatomic, strong) NSString *playName;
@property (nonatomic, strong) NSString *playId;
@property (nonatomic, strong) NSString *odds;
@property (nonatomic, assign) BOOL select;



@end

NS_ASSUME_NONNULL_END
