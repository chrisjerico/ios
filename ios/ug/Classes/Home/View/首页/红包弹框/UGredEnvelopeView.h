//
//  UGredEnvelopeView.h
//  ug
//
//  Created by ug on 2019/9/17.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGRedEnvelopeModel.h"
#import "UGhomeAdsModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^RedEnvelopeCancelBlock)(void);
typedef void(^RedEnvelopeRedBlock)(void);
@interface UGredEnvelopeView : UIView
@property (nonatomic, copy) RedEnvelopeCancelBlock cancelClickBlock;
@property (nonatomic, copy) RedEnvelopeRedBlock redClickBlock;

@property (nonatomic, strong) UGRedEnvelopeModel *item;

@property (nonatomic, strong) UGhomeAdsModel *itemSuspension;
@end

NS_ASSUME_NONNULL_END
