//
//  UGLotteryRightMenuView.h
//  UGBWApp
//
//  Created by fish on 2020/9/25.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^LotteryRightMenuBlock)(void);
@interface UGLotteryRightMenuView : UIView
@property (nonatomic, copy) LotteryRightMenuBlock backToHomeBlock;
- (void)show ;
@end

NS_ASSUME_NONNULL_END
