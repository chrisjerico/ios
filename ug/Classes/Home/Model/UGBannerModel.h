//
//  UGBannerModel.h
//  ug
//
//  Created by ug on 2019/6/22.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UGBannerCellModel <NSObject>

@end

@interface UGBannerCellModel : UGModel<UGBannerCellModel>
@property (nonatomic, strong) NSString *pic;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *sort;
@end

@protocol UGBannerModel <NSObject>

@end
@interface UGBannerModel : UGModel<UGBannerModel>
@property (nonatomic, strong) NSArray<UGBannerCellModel> * list;

@end

NS_ASSUME_NONNULL_END
