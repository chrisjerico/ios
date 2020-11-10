//
//  TKLRechargeListViewController.h
//  UGBWApp
//
//  Created by fish on 2020/11/7.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, RechargeType) {
    RT_在线       = 1,
    RT_转账       = 2,
};
@interface TKLRechargeListViewController : UIViewController
@property (nonatomic,assign) RechargeType type;
-(void)selectItme:(int)row;
@end

NS_ASSUME_NONNULL_END
