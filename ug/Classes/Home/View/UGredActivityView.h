//
//  UGredActivityView.h
//  ug
//
//  Created by ug on 2019/9/17.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UGRedEnvelopeModel;

NS_ASSUME_NONNULL_BEGIN
typedef void(^RedActivityRedBlock)(void);

@interface UGredActivityView : UGView

@property (nonatomic, copy) RedActivityRedBlock redClickBlock;

@property (nonatomic, strong) UGRedEnvelopeModel *item;
- (void)show;

@end

NS_ASSUME_NONNULL_END
