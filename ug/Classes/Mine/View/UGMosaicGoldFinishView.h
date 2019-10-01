//
//  UGMosaicGoldFinishView.h
//  ug
//
//  Created by ug on 2019/9/18.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UGMosaicGoldParamModel;

NS_ASSUME_NONNULL_BEGIN

@interface UGMosaicGoldFinishView : UGView


@property (nonatomic, strong) UGMosaicGoldParamModel *item;
/**
 *  关闭Block
 */
@property (nonatomic , copy ) void (^closeBlock)(void);

@end

NS_ASSUME_NONNULL_END
