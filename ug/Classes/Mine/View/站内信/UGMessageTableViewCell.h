//
//  UGMessageTableViewCell.h
//  ug
//
//  Created by ug on 2019/5/7.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UGMessageModel;
NS_ASSUME_NONNULL_BEGIN

@interface UGMessageTableViewCell : UITableViewCell
@property (nonatomic, strong) UGMessageModel *item;


@end

NS_ASSUME_NONNULL_END
