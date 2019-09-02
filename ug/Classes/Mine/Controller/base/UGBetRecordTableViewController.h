//
//  UGBetRecordTableViewController.h
//  ug
//
//  Created by ug on 2019/5/17.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UGBetRecordTableViewController : UIViewController

@property (nonatomic, assign) BOOL showFooterView;

@property (nonatomic, strong) NSString *gameType;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *startDate;
@property (nonatomic, assign) BOOL loadData;

@end

NS_ASSUME_NONNULL_END
