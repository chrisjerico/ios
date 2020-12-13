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
#import "ScratchDataModel.h"
#import "FLAnimatedImageView.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^RedEnvelopeRedBlock)(void);
@interface UGredEnvelopeView : UIView

@property (weak, nonatomic) IBOutlet FLAnimatedImageView *imgView;

@property (nonatomic, copy) void (^cancelClickBlock)(UGredEnvelopeView *rev);
@property (nonatomic, copy) RedEnvelopeRedBlock redClickBlock;



@property (nonatomic, strong) UGhomeAdsModel *itemSuspension;

@property (nonatomic, strong) id itemData;

@property (nonatomic, strong) ScratchDataModel * scratchDataModel;

- (void)setitem:(UGRedEnvelopeModel *)item showImg :(BOOL)showImg ;
@end

NS_ASSUME_NONNULL_END
