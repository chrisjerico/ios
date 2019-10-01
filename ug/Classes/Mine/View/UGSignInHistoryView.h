//
//  UGSignInHistoryView.h
//  ug
//
//  Created by ug on 2019/9/6.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UGSignInHistoryView : UGView

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) NSString *checkinTimes;

@property (nonatomic, strong) NSString *checkinMoney;

- (void)show;

@end

NS_ASSUME_NONNULL_END
