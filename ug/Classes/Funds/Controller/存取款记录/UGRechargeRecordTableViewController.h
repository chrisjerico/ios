//
//  UGRechargeRecordTableViewController.h
//  ug
//
//  Created by ug on 2019/5/3.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_OPTIONS(NSInteger, RecordType) {
    RecordTypeRecharge,//充值记录
    RecordTypeWithdraw //取款记录
};
@interface UGRechargeRecordTableViewController : UITableViewController
@property (nonatomic, assign) RecordType recordType;
@end

NS_ASSUME_NONNULL_END
