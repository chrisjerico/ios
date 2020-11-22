//
//  LotterySliderView.h
//  UGBWApp
//
//  Created by andrew on 2020/11/22.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSlider.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^LotterySliderViewBlcok)(void);//
@interface LotterySliderView : UIView
@property (nonatomic, strong) MGSlider *slider;
@property (nonatomic, copy) LotterySliderViewBlcok reloadlock;
@end

NS_ASSUME_NONNULL_END
