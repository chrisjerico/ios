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
    self.bottomLine.backgroundColor = Skin1.isBlack||Skin1.is23 ? Skin1.textColor2 : (APP.betBgIsWhite ? Skin1.navBarBgColor : [UIColor whiteColor]);
    if (APP.isRedWhite) {
        self.bottomLine.backgroundColor = RGBA(231, 213, 231, 1.0);
    }

}

- (void)setItem:(UGGameplayModel *)item {
    _item = item;
    self.titleLabel.text = item.name;
    
    BOOL selected = item.selectedCount;
    if (Skin1.isBlack||Skin1.is23||Skin1.isGPK) {
        self.leftPoint.backgroundColor = selected ? [UIColor whiteColor] : Skin1.navBarBgColor;
    } else {
        if (APP.betBgIsWhite) {
            self.leftPoint.backgroundColor = selected ? Skin1.navBarBgColor : UGRGBColor(195, 195, 196);
        } else {
            self.leftPoint.backgroundColor = selected ? [UIColor whiteColor] : UGRGBColor(195, 195, 196);
        }
    }
    
    if (APP.isRedWhite) {
        self.leftPoint.backgroundColor = selected ? [UIColor whiteColor] : UGRGBColor(195, 195, 196);
    }

    if (APP.isRed) {
        self.leftPoint.backgroundColor = selected ? [UIColor redColor] : UGRGBColor(195, 195, 196);
    }
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    self.bottomLine.hidden = !selected;
    self.titleLabel.font = [_titleLabel.text fontWithFrameSize:CGSizeOffset(self.size, CGSizeMake(-20, -5)) maxFont:selected ? [UIFont boldSystemFontOfSize:16] : [UIFont systemFontOfSize:16]];
    self.layer.borderWidth = selected * APP.borderWidthTimes;
    
    if (Skin1.isBlack||Skin1.is23||Skin1.isGPK) {
        self.titleLabel.textColor = selected ? [UIColor whiteColor] : RGBA(159, 166, 173, 1);
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        if ([Skin1.skitString isEqualToString:@"GPK版香槟金"]) {
            self.backgroundColor = selected ? RGBA(72, 146, 209, 1):  RGBA(102, 88, 78, 0.8);
        }
    } else {
        if (APP.betBgIsWhite) {
            self.titleLabel.textColor = selected ? Skin1.navBarBgColor : Skin1.textColor1;
            self.layer.borderColor = Skin1.navBarBgColor.CGColor;
        } else {
            self.titleLabel.textColor = selected ? [UIColor whiteColor] : Skin1.textColor1;
            self.layer.borderColor = [UIColor whiteColor].CGColor;
            self.layer.borderWidth = selected ? 0.5 : 0;
            if (APP.isBorderNavBarBgColor) {
                self.backgroundColor = selected ?[Skin1.navBarBgColor colorWithAlphaComponent:0.35]:[UIColor clearColor];
            }

        }
    }
    
    if (APP.isRedWhite) {
        self.titleLabel.textColor = selected ? [UIColor whiteColor] : Skin1.textColor1;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = selected ? 0.5 : 0;
        self.backgroundColor = selected ?Skin1.navBarBgColor :[UIColor clearColor];
    }
    
    if (APP.isC126CellStyle) {
        self.layer.borderWidth = 0;
        self.bottomLine.hidden = YES;
        if (selected) {
            self.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"c126CellBg"]];
            self.textLabel.backgroundColor = [UIColor clearColor];
            self.detailTextLabel.backgroundColor = [UIColor clearColor];
        } else {
            self.backgroundColor = [UIColor clearColor];
            self.backgroundView = nil;
            self.textLabel.backgroundColor = [UIColor clearColor];
            self.detailTextLabel.backgroundColor = [UIColor clearColor];
        }
    }
}

@end
