//
//  UGBetRecordViewController.h
//  ug
//
//  Created by ug on 2019/5/6.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYYSegmentControl.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGBetRecordViewController : UIViewController
@property (nonatomic, strong) XYYSegmentControl *slideSwitchView;
@end

@interface SModel : NSObject

@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
