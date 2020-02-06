//
//  PromotionRecordCell2.h
//  ug
//
//  Created by xionghx on 2020/1/13.
//  Copyright © 2020 ug. All rights reserved.
//

#import "UGTableViewCell.h"
#import "UGrealBetListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PromotionRecordCell2 : UGTableViewCell
-(void)bindOtherRecord: (UGrealBetListModel*)model row:(int )row;

@end

NS_ASSUME_NONNULL_END
