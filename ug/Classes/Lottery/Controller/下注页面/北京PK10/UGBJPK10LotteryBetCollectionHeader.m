//
//  UGBJPK10LotteryBetCollectionHeader.m
//  UGBWApp
//
//  Created by xionghx on 2020/9/27.
//  Copyright © 2020 ug. All rights reserved.
//

#import "UGBJPK10LotteryBetCollectionHeader.h"

@implementation UGBJPK10LotteryBetCollectionHeader
- (IBAction)ezdeSegmentValueChanged:(UISegmentedControl *)sender {
	if (self.segmentValueChangedBlock) {
		self.segmentValueChangedBlock(sender.selectedSegmentIndex);
	}
	[self.sectionLabel setHidden:sender.selectedSegmentIndex == 0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
