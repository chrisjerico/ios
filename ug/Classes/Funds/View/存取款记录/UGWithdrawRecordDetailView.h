//
//  UGWithdrawRecordDetailView.h
//  ug
//
//  Created by ug on 2019/9/1.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UGRechargeLogsModel;
NS_ASSUME_NONNULL_BEGIN

@interface UGWithdrawRecordDetailView : UIView
@property (nonatomic, strong) UGRechargeLogsModel *item;

- (void)show;
@end

NS_ASSUME_NONNULL_END
