//
//  UGTimeLotteryLeftTitleCell.m
//  ug
//
//  Created by ug on 2019/5/11.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGTimeLotteryLeftTitleCell.h"
#import "UGGameplayModel.h"

@interface UGTimeLotteryLeftTitleCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *leftPoint;
@property (weak, nonatomic) IBOutlet UILabel *bottomLine;

@end
@implementation UGTimeLotteryLeftTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bottomLine.hidden = YES;
    self.leftPoint.layer.cornerRadius = self.leftPoint.width / 2;
    self.leftPoint.layer.masksToBounds = YES;
    self.bottomLine.backgroundColor =  UGRGBColor(223, 222, 227);
}

- (void)setItem:(UGGameplayModel *)item {
    _item = item;
    self.titleLabel.text = item.name;
    if (item.select) {
        self.leftPoint.backgroundColor = Skin1.navBarBgColor;
    } else {
        self.leftPoint.backgroundColor = UGRGBColor(195, 195, 196);
    }
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.titleLabel.textColor = Skin1.navBarBgColor;
        self.bottomLine.hidden = NO;
        self.layer.borderColor = Skin1.navBarBgColor.CGColor;
        self.layer.borderWidth = 1;
        self.leftPoint.backgroundColor = Skin1.navBarBgColor;
    } else {
        self.titleLabel.textColor = [UIColor blackColor];
        self.bottomLine.hidden = YES;
        self.layer.borderWidth = 0.7;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.leftPoint.backgroundColor = UGRGBColor(195, 195, 196);
    }
}

@end
