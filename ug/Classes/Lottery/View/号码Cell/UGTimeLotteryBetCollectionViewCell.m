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
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setItem:(UGGameBetModel *)item {
    _item = item;
    
    if ([APP.SiteId isEqualToString:@"c194"]) {
        self.titleLabel.attributedText = ({
            NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] initWithString:_NSString(@"%@ %@",item.name, [item.odds removeFloatAllZero]) attributes:@{NSForegroundColorAttributeName:Skin1.textColor1}];
            [mas addAttributes:@{NSForegroundColorAttributeName:APP.AuxiliaryColor2} withString:[item.odds removeFloatAllZero]];
            mas;
        });
    } else {
        self.titleLabel.text = _NSString(@"%@ %@",item.name, [item.odds removeFloatAllZero]);
    }
    
    self.layer.borderWidth = item.select ? 1 : 0.5;
    
    if ([Skin1.skitType isEqualToString:@"黑色模板"]) {
        self.backgroundColor = item.select ? Skin1.homeContentSubColor : UIColorHex(101010);
        self.layer.borderColor = (item.select ? [UIColor whiteColor] : Skin1.textColor3).CGColor;
        
        if (![APP.SiteId isEqualToString:@"c194"]) {
            self.titleLabel.textColor = Skin1.textColor2;
            self.titleLabel.highlightedTextColor = [UIColor whiteColor];
            self.titleLabel.highlighted = item.select;
        }
    } else {
        self.backgroundColor = item.select ? [Skin1.homeContentSubColor colorWithAlphaComponent:0.2] : [UIColor clearColor];
        self.layer.borderColor = (item.select ? Skin1.navBarBgColor : APP.LineColor).CGColor;
        
        if (![APP.SiteId isEqualToString:@"c194"]) {
            self.titleLabel.textColor = Skin1.textColor1;
        }
    }
}

- (void)setSelected:(BOOL)selected {

}

@end
