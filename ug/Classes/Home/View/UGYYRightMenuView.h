//
//  UGYYRightMenuView.h
//  ug
//
//  Created by ug on 2019/9/27.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^YYRightMenuBlock)();
@interface UGYYRightMenuView : UIView


@property (nonatomic,copy)YYRightMenuBlock gotoSeeBlock;
@property (nonatomic, strong) NSArray *lotteryGamesArray;
- (void)show;

@end

NS_ASSUME_NONNULL_END
