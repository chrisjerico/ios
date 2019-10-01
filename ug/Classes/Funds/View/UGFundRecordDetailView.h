//
//  UGFundRecordDetailView.h
//  ug
//
//  Created by ug on 2019/8/29.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UGRechargeLogsModel;
NS_ASSUME_NONNULL_BEGIN

@interface UGFundRecordDetailView : UGView
@property (nonatomic, strong) UGRechargeLogsModel *item;

- (void)show;
@end

NS_ASSUME_NONNULL_END
