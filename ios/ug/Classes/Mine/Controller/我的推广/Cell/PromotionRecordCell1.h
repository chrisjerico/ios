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
#import "UGdepositStatModel.h"
#import "UGwithdrawStatModel.h"
#import "UGdepositListModel.h"
#import "UGwithdrawListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface PromotionRecordCell1 : UGTableViewCell
-(void)bindBetReport: (UGbetStatModel *)model row:(int )row;
-(void)bindOtherReport: (UGrealBetStatModel *)model row:(int )row;
-(void)bindBetRecord: (UGBetListModel*)model row:(int )row;
//存款报表
- (void)bindDepositList:(UGdepositStatModel *)model row:(int )row;
//提款报表
- (void)bindWithdrawalsList:(UGwithdrawStatModel *)model row:(int )row;
//存款记录
- (void)bindDepositRecord:(UGdepositListModel *)model row:(int )row;

//提款记录
- (void)bindWithdrawalRecord:(UGwithdrawListModel *)model row:(int )row;
@end

NS_ASSUME_NONNULL_END
