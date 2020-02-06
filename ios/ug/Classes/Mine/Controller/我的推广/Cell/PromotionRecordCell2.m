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

- (void)celBgColor:(int)row {
    if (row%2) {
        [((UILabel *)self.itemLabels[0]) setBackgroundColor:RGBA(235, 235, 235, 0.7)];
        [((UILabel *)self.itemLabels[1]) setBackgroundColor:RGBA(235, 235, 235, 0.7)];
        [((UILabel *)self.itemLabels[2]) setBackgroundColor:RGBA(235, 235, 235, 0.7)];
        [((UILabel *)self.itemLabels[3]) setBackgroundColor:RGBA(235, 235, 235, 0.7)];
        [((UILabel *)self.itemLabels[4]) setBackgroundColor:RGBA(235, 235, 235, 0.7)];
    } else {
        if (Skin1.isBlack) {
            [((UILabel *)self.itemLabels[0]) setBackgroundColor:Skin1.CLBgColor];
            [((UILabel *)self.itemLabels[1]) setBackgroundColor:Skin1.CLBgColor];
            [((UILabel *)self.itemLabels[2]) setBackgroundColor:Skin1.CLBgColor];
            [((UILabel *)self.itemLabels[3]) setBackgroundColor:Skin1.CLBgColor];
            [((UILabel *)self.itemLabels[4]) setBackgroundColor:Skin1.CLBgColor];
        } else {
            [((UILabel *)self.itemLabels[0]) setBackgroundColor:[UIColor whiteColor]];
            [((UILabel *)self.itemLabels[1]) setBackgroundColor:[UIColor whiteColor]];
            [((UILabel *)self.itemLabels[2]) setBackgroundColor:[UIColor whiteColor]];
            [((UILabel *)self.itemLabels[3]) setBackgroundColor:[UIColor whiteColor]];
            [((UILabel *)self.itemLabels[4]) setBackgroundColor:[UIColor whiteColor]];
        }
    }
}

- (void)bindOtherRecord:(UGrealBetListModel *)model row:(int )row{

    [self celBgColor:row];

	((UILabel *)self.itemLabels[0]).text = [model.level stringValue];
	((UILabel *)self.itemLabels[1]).text = model.username;
	((UILabel *)self.itemLabels[2]).text = model.date;
	((UILabel *)self.itemLabels[3]).text = model.bet_sum;
	((UILabel *)self.itemLabels[4]).text = model.netAmount;

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:false animated:animated];

    // Configure the view for the selected state
}

@end
