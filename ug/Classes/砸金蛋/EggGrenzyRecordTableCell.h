//
//  EggGrenzyRecordTableCell.h
//  UGBWApp
//
//  Created by xionghx on 2020/8/27.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZPModel.h"
#import "GoldEggLogModel.h"
#import "ScratchLogModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface EggGrenzyRecordTableCell : UITableViewCell
- (void)bind: (GoldEggLogModel*)model;
- (void)bindScratchLog: (ScratchLogModel*)model;
@end

NS_ASSUME_NONNULL_END
