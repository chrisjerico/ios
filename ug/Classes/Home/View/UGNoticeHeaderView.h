//
//  UGNoticeHeaderView.h
//  ug
//
//  Created by ug on 2019/5/31.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UGNoticeModel;
NS_ASSUME_NONNULL_BEGIN
typedef void(^NoticeHeaderViewClickBlcok)(void);
@interface UGNoticeHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) UGNoticeModel *item;
@property (nonatomic, copy) NoticeHeaderViewClickBlcok clickBllock;
@end

NS_ASSUME_NONNULL_END
