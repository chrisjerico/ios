//
//  PromotionCodeCell.h
//  UGBWApp
//
//  Created by xionghx on 2020/11/2.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InviteCodeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PromotionCodeCell : UITableViewCell
- (void)bind: (InviteCodeModel *)item;
@end

NS_ASSUME_NONNULL_END
