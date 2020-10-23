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
   
}

- (void)setItem:(UGGameBetModel *)item {
    _item = item;
    self.titleLabel.text = item.name;

   
    
    if (self.hasSelected) {
        if (APP.betBgIsWhite && !Skin1.isGPK && !Skin1.isBlack && !Skin1.is23) {
            if (item.select) {
                self.titleLabel.backgroundColor = UGBlueColor;
            } else {
                if ([Global getInstanse].hasBgColor) {
                    self.titleLabel.backgroundColor = RGBA(97, 108, 118, 1);
                } else {
                    self.titleLabel.backgroundColor =  Skin1.CLBgColor;
                }
            }
        } else {
            if (item.select) {
                self.titleLabel.backgroundColor = UGBlueColor;
            } else {
                if ([Global getInstanse].hasBgColor) {
                    self.titleLabel.backgroundColor = RGBA(97, 108, 118, 1);
                } else {
                    self.titleLabel.backgroundColor =  Skin1.homeContentColor;
                }
            }
        }
    }
    else{
        if (APP.betBgIsWhite && !Skin1.isGPK && !Skin1.isBlack && !Skin1.is23) {
            self.titleLabel.backgroundColor = item.select ? UGBlueColor : Skin1.CLBgColor;
        } else {
            self.titleLabel.backgroundColor = item.select ? UGBlueColor : Skin1.homeContentColor;
        }
    }
    
    self.titleLabel.textColor =  item.select ? [UIColor whiteColor] : Skin1.textColor3;
    

}

@end
