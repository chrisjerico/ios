//
//  EggGrenzyRecordTableCell.m
//  UGBWApp
//
//  Created by xionghx on 2020/8/27.
//  Copyright © 2020 ug. All rights reserved.
//

#import "EggGrenzyRecordTableCell.h"
@interface EggGrenzyRecordTableCell()
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *describLabel;
@end

@implementation EggGrenzyRecordTableCell


- (void)bind: (GoldEggLogModel*)model {
//	self.numberLabel.text = [NSString stringWithFormat:@"%@", model.prize_param[0][@"prizeId"]];
	self.numberLabel.text = [NSString stringWithFormat:@"%@-%@", model.logID, model.prize_param[0][@"update_time"]];

	self.describLabel.text = model.prize_param[0][@"prizeName"];
}

- (void)bindScratchLog: (ScratchLogModel*)model type: (NSString *)logType {
	if ([logType isEqualToString:@"1"]) {
		self.numberLabel.text = model.username;
	} else {
		self.numberLabel.text = [NSString stringWithFormat:@"%@-%@", model.update_date, model.logID];
	}
	self.describLabel.text = [NSString stringWithFormat:@"%@彩金",  model.amount];
	
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
