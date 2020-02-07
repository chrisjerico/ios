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
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *itemViews;
@end
@implementation PromotionRecordCell2

- (void)celBgColor:(int)row {
    if (row%2) {
        [((UIView *)self.itemViews[0]) setBackgroundColor:RGBA(244, 245, 245, 0.7)];
        [((UIView *)self.itemViews[1]) setBackgroundColor:RGBA(244, 245, 245, 0.7)];
        [((UIView *)self.itemViews[2]) setBackgroundColor:RGBA(244, 245, 245, 0.7)];
        [((UIView *)self.itemViews[3]) setBackgroundColor:RGBA(244, 245, 245, 0.7)];
        [((UIView *)self.itemViews[4]) setBackgroundColor:RGBA(244, 245, 245, 0.7)];
    } else {
        if (Skin1.isBlack) {
            [((UIView *)self.itemViews[0]) setBackgroundColor:Skin1.CLBgColor];
            [((UIView *)self.itemViews[1]) setBackgroundColor:Skin1.CLBgColor];
            [((UIView *)self.itemViews[2]) setBackgroundColor:Skin1.CLBgColor];
            [((UIView *)self.itemViews[3]) setBackgroundColor:Skin1.CLBgColor];
            [((UIView *)self.itemViews[4]) setBackgroundColor:Skin1.CLBgColor];
         
        } else {
            [((UIView *)self.itemViews[0]) setBackgroundColor:[UIColor whiteColor]];
            [((UIView *)self.itemViews[1]) setBackgroundColor:[UIColor whiteColor]];
            [((UIView *)self.itemViews[2]) setBackgroundColor:[UIColor whiteColor]];
            [((UIView *)self.itemViews[3]) setBackgroundColor:[UIColor whiteColor]];
            [((UIView *)self.itemViews[4]) setBackgroundColor:[UIColor whiteColor]];
         
        }
    }
}

- (void)bindOtherRecord:(UGrealBetListModel *)model row:(int )row{

    [self celBgColor:row];
    
    int intLevel = [model.level intValue];
    if (intLevel == 0) {
        ((UILabel *)self.itemLabels[0]).text = @"全部下线";
    }
    else{
        ((UILabel *)self.itemLabels[0]).text = [NSString stringWithFormat:@"%@级下线",[CMCommon switchNumber:intLevel]];
    }
	((UILabel *)self.itemLabels[1]).text = model.platform;
	((UILabel *)self.itemLabels[2]).text = model.date;
	((UILabel *)self.itemLabels[3]).text = model.betAmount;
	((UILabel *)self.itemLabels[4]).text = model.netAmount;
    if (model.netAmount.intValue) {
        [((UILabel *)self.itemLabels[4]) setTextColor:[UIColor redColor]];
    }
    else{
         [((UILabel *)self.itemLabels[4]) setTextColor:[UIColor blackColor]];
    }

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:false animated:animated];

    // Configure the view for the selected state
}

@end
