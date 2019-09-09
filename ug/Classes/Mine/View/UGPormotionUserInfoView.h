//
//  UGPormotionUserInfoView.h
//  ug
//
//  Created by ug on 2019/9/9.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGinviteLisModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UGPormotionUserInfoView : UIView

@property (nonatomic, strong) UGinviteLisModel *item;

- (void)show;

@end

NS_ASSUME_NONNULL_END
