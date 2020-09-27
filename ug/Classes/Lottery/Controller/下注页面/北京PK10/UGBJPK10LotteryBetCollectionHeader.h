//
//  UGBJPK10LotteryBetCollectionHeader.h
//  UGBWApp
//
//  Created by xionghx on 2020/9/27.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN



@interface UGBJPK10LotteryBetCollectionHeader : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UILabel *sectionLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *ezdwSegment;
@property (copy, nonatomic) void(^segmentValueChangedBlock)(NSInteger);

@end

NS_ASSUME_NONNULL_END
