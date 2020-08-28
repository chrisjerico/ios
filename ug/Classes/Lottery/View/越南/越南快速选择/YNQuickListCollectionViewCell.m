//
//  YNQuickListCollectionViewCell.m
//  UGBWApp
//
//  Created by andrew on 2020/7/31.
//  Copyright © 2020 ug. All rights reserved.
//

#import "YNQuickListCollectionViewCell.h"
#import "UGGameplayModel.h"
@interface YNQuickListCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end



@implementation YNQuickListCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLabel.layer.cornerRadius= 3;
    self.titleLabel.layer.masksToBounds = YES;
    self.titleLabel.backgroundColor = UGBlueColor;
}

- (void)setItem:(UGGameBetModel *)item {
    _item = item;
    self.titleLabel.text = item.name;
    
    if (Skin1.isBlack||Skin1.is23) {
        if ([Skin1.skitString isEqualToString:@"GPK版香槟金"]) {
            self.backgroundColor = item.select ? RGBA(72, 146, 209, 1):  Skin1.homeContentSubColor;
        } else {
            self.backgroundColor = item.select ? Skin1.homeContentSubColor : UIColorHex(101010);
        }

    } else {
        self.backgroundColor = item.select ? [Skin1.homeContentSubColor colorWithAlphaComponent:0.2] : [UIColor clearColor];
        if (APP.isBorderNavBarBgColor) {
            self.backgroundColor = item.select ?Skin1.navBarBgColor:[UIColor clearColor];
        }
    }
}

@end
