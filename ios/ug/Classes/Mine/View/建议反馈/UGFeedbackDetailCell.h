//
//  UGFeedbackDetailCell.h
//  ug
//
//  Created by ug on 2019/7/12.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UGMessageModel;
NS_ASSUME_NONNULL_BEGIN

@interface UGFeedbackDetailCell : UITableViewCell

@property (nonatomic, strong) UGMessageModel *item;

@end

NS_ASSUME_NONNULL_END
