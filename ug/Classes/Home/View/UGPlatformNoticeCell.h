//
//  UGPlatformNoticeCell.h
//  ug
//
//  Created by ug on 2019/5/31.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UGNoticeModel;
NS_ASSUME_NONNULL_BEGIN

@interface UGPlatformNoticeCell : UITableViewCell
@property (nonatomic, strong) UGNoticeModel *item;

@end

NS_ASSUME_NONNULL_END
