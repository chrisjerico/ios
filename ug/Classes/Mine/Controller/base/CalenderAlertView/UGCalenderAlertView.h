//
//  UGCalenderAlertView.h
//  ug
//
//  Created by fish on 2019/10/6.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UGCalenderAlertView : UIView

@property (nonatomic) NSDate *selectedDate;
@property (nonatomic) void (^didSelectedDate)(NSDate *date);
- (void)show;
@end

NS_ASSUME_NONNULL_END
