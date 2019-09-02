//
//  UGLotteryAdPopView.h
//  ug
//
//  Created by ug on 2019/8/2.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^LotteryAdGoBlock)(void);
@interface UGLotteryAdPopView : UIView
- (void)show;
@property (nonatomic, copy) LotteryAdGoBlock adGoBlcok;
@property (nonatomic, strong) NSString *picUrl;

@end

NS_ASSUME_NONNULL_END
