//
//  PromotionRecordCell2.m
//  ug
//
//  Created by xionghx on 2020/1/13.
//  Copyright © 2020 ug. All rights reserved.
//

#import "PromotionRecordCell2.h"
@interface PromotionRecordCell2()
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *itemLabels;

@end
@implementation PromotionRecordCell2
- (void)bindOtherRecord:(UGrealBetListModel *)model {
	((UILabel *)self.itemLabels[0]).text = [model.level stringValue];
	((UILabel *)self.itemLabels[1]).text = model.username;
	((UILabel *)self.itemLabels[2]).text = model.date;
	((UILabel *)self.itemLabels[3]).text = model.betAmount;
	((UILabel *)self.itemLabels[4]).text = model.validBetAmount;

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:false animated:animated];

    // Configure the view for the selected state
}

@end
