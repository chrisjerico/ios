//
//  UGRealBetRecordViewController.h
//  ug
//
//  Created by ug on 2019/7/23.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UGRealBetRecordViewController : UIViewController
@property (nonatomic, strong) NSString *gameType;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *startDate;
@end

@interface Model : NSObject

@property (nonatomic, strong) NSString *gameType;
@property (nonatomic, copy) NSString *gameName;

@end

NS_ASSUME_NONNULL_END
