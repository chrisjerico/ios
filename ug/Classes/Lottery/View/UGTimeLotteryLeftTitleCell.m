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
    self.bottomLine.backgroundColor = [[UGSkinManagers shareInstance] setNavbgColor];
}

- (void)setItem:(UGGameplayModel *)item {
    _item = item;
    self.titleLabel.text = item.name;
    if (item.select) {
        self.leftPoint.backgroundColor = UGRGBColor(237, 183, 99);
        
    }else {
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
        self.titleLabel.textColor = [[UGSkinManagers shareInstance] setNavbgColor];
        self.bottomLine.hidden = NO;
//        self.layer.borderColor = UGNavColor.CGColor;
//        self.layer.borderWidth = 1;
        
    }else {
        self.titleLabel.textColor = [UIColor blackColor];
        self.bottomLine.hidden = YES;
//        self.layer.borderWidth = 0.7;
//        self.layer.borderColor = [UIColor whiteColor].CGColor;
    }
}

@end
