//
//  YNQuickSelectView.h
//  UGBWApp
//
//  Created by andrew on 2020/7/27.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGGameplayModel.h"
#import "HMSegmentedControl.h"
NS_ASSUME_NONNULL_BEGIN

@interface YNQuickSelectView : UIView
@property (nonatomic, strong )UGGameBetModel *bet;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@end

NS_ASSUME_NONNULL_END
