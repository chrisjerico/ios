//
//  PromotionRecordCell1.h
//  ug
//
//  Created by xionghx on 2020/1/11.
//  Copyright © 2020 ug. All rights reserved.
//

#import "UGTableViewCell.h"
#import "UGbetStatModel.h"
#import "UGrealBetStatModel.h"
#import "UGBetListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface PromotionRecordCell1 : UGTableViewCell
-(void)bindBetReport: (UGbetStatModel *)model;
-(void)bindOtherReport: (UGrealBetStatModel *)model;
-(void)bindBetRecord: (UGBetListModel*)model;
@end

NS_ASSUME_NONNULL_END
