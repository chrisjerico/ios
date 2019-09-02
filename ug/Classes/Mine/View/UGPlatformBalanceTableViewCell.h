//
//  UGPlatformBalanceTableViewCell.h
//  ug
//
//  Created by ug on 2019/5/8.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^BalanceRefreshBlock)(void);
@class UGPlatformGameModel;
@interface UGPlatformBalanceTableViewCell : UITableViewCell
@property (nonatomic, strong) UGPlatformGameModel *item;
@property (nonatomic, copy) BalanceRefreshBlock refreshBlock;
@end

NS_ASSUME_NONNULL_END
