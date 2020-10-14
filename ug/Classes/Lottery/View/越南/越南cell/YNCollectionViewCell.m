//
//  YNCollectionViewCell.m
//  UGBWApp
//
//  Created by ug on 2020/8/16.
//  Copyright © 2020 ug. All rights reserved.
//

#import "YNCollectionViewCell.h"
#import "UGGameplayModel.h"
@interface YNCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
@implementation YNCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
     self.nameLabel.layer.cornerRadius= self.nameLabel.height / 2;
     self.nameLabel.layer.masksToBounds = YES;
     
}

- (void)setItem:(UGGameBetModel *)item {
    _item = item;
    self.nameLabel.text = item.name;
    
    if (APP.betBgIsWhite && !Skin1.isGPK && !Skin1.isBlack) {
        self.nameLabel.backgroundColor = item.select ? UGBlueColor : Skin1.bgColor;
        
    } else {
        self.nameLabel.backgroundColor = item.select ? UGBlueColor : Skin1.homeContentColor;
    }
    self.nameLabel.textColor =  item.select ? [UIColor whiteColor] : Skin1.textColor3;
    
   
}


@end
