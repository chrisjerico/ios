//
//  UGActivityGoldView.h
//  ug
//
//  Created by ug on 2019/9/19.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UGMosaicGoldParamModel;
NS_ASSUME_NONNULL_BEGIN

@interface UGActivityGoldView : UIView

@property (nonatomic, strong) UGMosaicGoldParamModel *item;

- (void)show;

-(void)setDateUI;

@end

NS_ASSUME_NONNULL_END