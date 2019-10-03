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

// 首页轮播图
// {{LOCAL_HOST}}?c=system&a=banners
@interface UGBannerCellModel : UGModel<UGBannerCellModel>
@property (nonatomic, strong) NSString *pic;    /**<   图片 */
@property (nonatomic, strong) NSString *url;    /**<   链接地址 */
@property (nonatomic, strong) NSString *sort;   /**<   排序 */
@end

@protocol UGBannerModel <NSObject>

@end
@interface UGBannerModel : UGModel<UGBannerModel>
@property (nonatomic, strong) NSArray<UGBannerCellModel> * list;

@end

NS_ASSUME_NONNULL_END
