//
//  UGLinkNumCollectionViewCell.m
//  ug
//
//  Created by ug on 2019/7/25.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGLinkNumCollectionViewCell.h"
#import "UGGameplayModel.h"
@interface UGLinkNumCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
@implementation UGLinkNumCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.nameLabel.layer.cornerRadius= self.nameLabel.height / 2;
    self.nameLabel.layer.masksToBounds = YES;
    self.nameLabel.backgroundColor = UGBlueColor;
}

- (void)setItem:(UGGameBetModel *)item {
    _item = item;
    self.nameLabel.text = item.name;
    
    self.layer.borderWidth = item.select ? 1 : 0.5;
    
    if (Skin1.isBlack) {
        self.backgroundColor = item.select ? Skin1.homeContentSubColor : UIColorHex(101010);
        self.layer.borderColor = (item.select ? [UIColor whiteColor] : Skin1.textColor3).CGColor;
    } else {
        self.backgroundColor = item.select ? [Skin1.homeContentSubColor colorWithAlphaComponent:0.2] : [UIColor clearColor];
        if (APP.isBorderNavBarBgColor) {
            self.backgroundColor = item.select ?Skin1.navBarBgColor:[UIColor clearColor];
        }
        self.layer.borderColor = (item.select ? Skin1.navBarBgColor : APP.LineColor).CGColor;
    }
}


@end
