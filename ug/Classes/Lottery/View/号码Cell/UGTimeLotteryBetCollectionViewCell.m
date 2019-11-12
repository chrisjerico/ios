//
//  UGTimeLotteryBetCollectionViewCell.m
//  ug
//
//  Created by ug on 2019/5/11.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGTimeLotteryBetCollectionViewCell.h"
#import "UGGameplayModel.h"

@interface UGTimeLotteryBetCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
@implementation UGTimeLotteryBetCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    if ([Skin1.skitType isEqualToString:@"黑色模板"]) {
        [self.contentView setBackgroundColor:Skin1.bgColor];
        [self.titleLabel setTextColor:[UIColor whiteColor]];
    } else {
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        [self.titleLabel setTextColor:[UIColor blackColor]];
    }
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setItem:(UGGameBetModel *)item {
    _item = item;
   
    self.titleLabel.text = [NSString stringWithFormat:@"%@  %@",item.name,[item.odds removeFloatAllZero]];
     if ([Skin1.skitType isEqualToString:@"黑色模板"]) {
            if (item.select) {
                   self.titleLabel.textColor = [UIColor whiteColor];
                   self.layer.borderColor = [UIColor whiteColor].CGColor;
                   self.layer.borderWidth = 1;
               }else {
                   self.titleLabel.textColor = RGBA(159, 166, 173, 1);
                   self.layer.borderWidth = 0.7;
                   self.layer.borderColor =  Skin1.navBarBgColor.CGColor;
               }
        } else {
            if (item.select) {
                   self.titleLabel.textColor = Skin1.navBarBgColor;
                   self.layer.borderColor = Skin1.navBarBgColor.CGColor;
                   self.layer.borderWidth = 1;
               }else {
                   self.titleLabel.textColor = [UIColor blackColor];
                   self.layer.borderWidth = 0.7;
                   self.layer.borderColor =  UGRGBColor(239, 239, 244).CGColor;
               }
        }
    
}

- (void)setSelected:(BOOL)selected {

}

@end
