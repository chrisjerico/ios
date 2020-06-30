//
//  BetDetailTableViewCell.m
//  UGBWApp
//
//  Created by ug on 2020/6/30.
//  Copyright © 2020 ug. All rights reserved.
//

#import "BetDetailTableViewCell.h"
#import "CMTimeCommon.h"
#import "UIColor+RGBValues.h"


@interface BetDetailTableViewCell()
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *itemLabels;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *itemViews;
@end

@implementation BetDetailTableViewCell

- (void)celBgColor:(int)row {
    if (row%2) {
        [((UIView *)self.itemViews[0]) setBackgroundColor:RGBA(244, 245, 245, 0.7)];
        [((UIView *)self.itemViews[1]) setBackgroundColor:RGBA(244, 245, 245, 0.7)];
        [((UIView *)self.itemViews[2]) setBackgroundColor:RGBA(244, 245, 245, 0.7)];
        [((UIView *)self.itemViews[3]) setBackgroundColor:RGBA(244, 245, 245, 0.7)];
    } else {
        if (Skin1.isBlack) {
            [((UIView *)self.itemViews[0]) setBackgroundColor:Skin1.CLBgColor];
            [((UIView *)self.itemViews[1]) setBackgroundColor:Skin1.CLBgColor];
            [((UIView *)self.itemViews[2]) setBackgroundColor:Skin1.CLBgColor];
            [((UIView *)self.itemViews[3]) setBackgroundColor:Skin1.CLBgColor];
            
        } else {
            [((UIView *)self.itemViews[0]) setBackgroundColor:[UIColor whiteColor]];
            [((UIView *)self.itemViews[1]) setBackgroundColor:[UIColor whiteColor]];
            [((UIView *)self.itemViews[2]) setBackgroundColor:[UIColor whiteColor]];
            [((UIView *)self.itemViews[3]) setBackgroundColor:[UIColor whiteColor]];
            
        }
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    if (Skin1.isBlack) {
           [((UILabel *)self.itemLabels[0]) setTextColor:Skin1.textColor1];
           [((UILabel *)self.itemLabels[1]) setTextColor:Skin1.textColor1];
           [((UILabel *)self.itemLabels[2]) setTextColor:Skin1.textColor1];
           [((UILabel *)self.itemLabels[3]) setTextColor:Skin1.textColor1];
           
           [((UIView *)self.itemViews[0]) setBackgroundColor:Skin1.textColor4];
           [((UIView *)self.itemViews[1]) setBackgroundColor:Skin1.textColor4];
           [((UIView *)self.itemViews[2]) setBackgroundColor:Skin1.textColor4];
           [((UIView *)self.itemViews[3]) setBackgroundColor:Skin1.textColor4];
        
           [self setBackgroundColor:Skin1.CLBgColor];
       }
       
       for (UIView * v in self.itemViews) {
           v.layer.borderWidth = 0.5;
           v.layer.borderColor = RGBA(228, 231, 235, 1).CGColor;
       }
       
       self.layer.borderWidth = 0.5;
       self.layer.borderColor = RGBA(228, 231, 235, 1).CGColor;
       
}

-(void)bindBetDetail: (UGBetsRecordModel *)model row:(int )row{
    
    [self celBgColor:row];
    ((UILabel *)self.itemLabels[0]).text = model.title;//
    ((UILabel *)self.itemLabels[1]).text = model.betCount;
    ((UILabel *)self.itemLabels[2]).text = model.betMoney;
    ((UILabel *)self.itemLabels[3]).text = model.rewardRebate;

    if (Skin1.isBlack) {
        [((UILabel *)self.itemLabels[0]) setTextColor:Skin1.textColor1];
        [((UILabel *)self.itemLabels[1]) setTextColor:Skin1.textColor1];
        [((UILabel *)self.itemLabels[2]) setTextColor:Skin1.textColor1];
        [((UILabel *)self.itemLabels[3]) setTextColor:Skin1.textColor1];
    }
    else{
        [((UILabel *)self.itemLabels[0]) setTextColor:[UIColor blackColor]];
        [((UILabel *)self.itemLabels[1]) setTextColor:[UIColor blackColor]];
        [((UILabel *)self.itemLabels[2]) setTextColor:[UIColor blackColor]];
        [((UILabel *)self.itemLabels[3]) setTextColor:[UIColor blackColor]];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
