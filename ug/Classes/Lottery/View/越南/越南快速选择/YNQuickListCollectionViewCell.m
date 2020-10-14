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
    
    if (APP.betBgIsWhite && !Skin1.isGPK && !Skin1.isBlack) {
        self.titleLabel.backgroundColor = item.select ? UGBlueColor : Skin1.bgColor;
    } else {
        self.titleLabel.backgroundColor = item.select ? UGBlueColor : Skin1.homeContentColor;
    }
    
    self.titleLabel.textColor =  item.select ? [UIColor whiteColor] : Skin1.textColor3;
    

}

@end
