//
//  UGCellHeaderView.h
//  ug
//
//  Created by ug on 2020/2/25.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UGPromoteModel;
NS_ASSUME_NONNULL_BEGIN
typedef void(^UGCellHeaderViewClickBlcok)(void);
typedef void(^UGCellHeaderViewBlcok)(void);
@interface UGCellHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) UGPromoteModel *item;
@property (nonatomic, copy) UGCellHeaderViewClickBlcok clickBllock;
@property (nonatomic, copy) UGCellHeaderViewBlcok hBllock;

+ (CGFloat)heightWithModel:(UGPromoteModel *)item;
@end

NS_ASSUME_NONNULL_END
