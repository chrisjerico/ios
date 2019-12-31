//
//  UGMosaicGoldModel.h
//  ug
//
//  Created by ug on 2019/9/18.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UGMosaicGoldParamModel <NSObject>

@end
@interface UGMosaicGoldParamModel : UGModel<UGMosaicGoldParamModel>
@property (nonatomic, strong) NSString *win_apply_image;    /**<   展示图片 */
@property (nonatomic, strong) NSString *win_apply_content;  /**<   活动详情 */
@property (nonatomic, assign) BOOL showWinAmount;           /**<   是否显申请金额 1显示 0不显示 */
@property (nonatomic, strong) NSString *quickAmount1;       /**<   快捷按钮金额1 */
@property (nonatomic, strong) NSString *quickAmount2;       /**<   快捷按钮金额2 */
@property (nonatomic, strong) NSString *quickAmount3;       /**<   快捷按钮金额3 */
@property (nonatomic, strong) NSString *quickAmount4;       /**<   快捷按钮金额4 */
@property (nonatomic, strong) NSString *quickAmount5;       /**<   快捷按钮金额5 */
@property (nonatomic, strong) NSString *quickAmount6;       /**<   快捷按钮金额6 */
@property (nonatomic, strong) NSString *quickAmount7;       /**<   快捷按钮金额7 */
@property (nonatomic, strong) NSString *quickAmount8;       /**<   快捷按钮金额8 */
@property (nonatomic, strong) NSString *quickAmount9;       /**<   快捷按钮金额9 */
@property (nonatomic, strong) NSString *quickAmount10;      /**<   快捷按钮金额10 */
@property (nonatomic, strong) NSString *quickAmount11;      /**<   快捷按钮金额11 */
@property (nonatomic, strong) NSString *quickAmount12;      /**<   快捷按钮金额12 */
@property (nonatomic, strong) NSString *mid;//
@end


@protocol UGMosaicGoldModel <NSObject>

@end
@interface UGMosaicGoldModel : UGModel<UGMosaicGoldModel>
@property (nonatomic, strong) NSString *mid;    /**<   id */
@property (nonatomic, strong) NSString *name;   /**<   标题 */
@property (nonatomic, strong) UGMosaicGoldParamModel *param;//
@end

NS_ASSUME_NONNULL_END
