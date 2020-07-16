//
//  BetDetailTableViewCell.h
//  UGBWApp
//
//  Created by ug on 2020/6/30.
//  Copyright © 2020 ug. All rights reserved.
//

#import "UGTableViewCell.h"
#import "UGBetsRecordListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BetDetailTableViewCell : UGTableViewCell
-(void)bindBetDetail: (UGBetsRecordModel *)model row:(int )row;
@end

NS_ASSUME_NONNULL_END
