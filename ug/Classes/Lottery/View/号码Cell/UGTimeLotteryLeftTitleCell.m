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
        if ([Skin1.skitType isEqualToString:@"黑色模板"]) {
            self.titleLabel.textColor = [UIColor whiteColor];
            [self.contentView setBackgroundColor:Skin1.bgColor];
            self.leftPoint.backgroundColor = UGRGBColor(195, 195, 196);
        } else {
            self.titleLabel.textColor = Skin1.navBarBgColor;
            self.leftPoint.backgroundColor = Skin1.navBarBgColor;
        }
        self.bottomLine.hidden = NO;
        self.layer.borderWidth = 1;
        self.layer.borderColor = Skin1.navBarBgColor.CGColor;

    } else {
        if ([Skin1.skitType isEqualToString:@"黑色模板"]) {
            self.titleLabel.textColor = RGBA(159, 166, 173, 1);
            self.layer.borderColor = [UIColor lightGrayColor].CGColor;
            [self.contentView setBackgroundColor:Skin1.navBarBgColor];
             self.leftPoint.backgroundColor = Skin1.bgColor;
        } else {
            self.titleLabel.textColor = [UIColor blackColor];
            self.layer.borderColor = [UIColor whiteColor].CGColor;
            self.leftPoint.backgroundColor = UGRGBColor(195, 195, 196);
        }
        self.bottomLine.hidden = YES;
        self.layer.borderWidth = 0.7;
      
    }
}

@end
