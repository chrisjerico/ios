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
    self.bottomLine.backgroundColor = [Skin1.skitType isEqualToString:@"黑色模板"] ? Skin1.textColor2 : Skin1.navBarBgColor;
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
    
    self.bottomLine.hidden = !selected;
    self.titleLabel.font = selected ? [UIFont boldSystemFontOfSize:15] : [UIFont systemFontOfSize:14];
    self.layer.borderWidth = selected;
    
    if ([Skin1.skitType isEqualToString:@"黑色模板"]) {
        self.titleLabel.textColor = selected ? [UIColor whiteColor] : RGBA(159, 166, 173, 1);
        self.leftPoint.backgroundColor = selected ? [UIColor whiteColor] : Skin1.navBarBgColor;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
    } else {
        self.titleLabel.textColor = selected ? Skin1.navBarBgColor : Skin1.textColor1;
        self.leftPoint.backgroundColor = selected ? Skin1.navBarBgColor : UGRGBColor(195, 195, 196);
        self.layer.borderColor = Skin1.navBarBgColor.CGColor;
    }
}

@end
