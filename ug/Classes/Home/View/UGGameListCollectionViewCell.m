//
//  UGGameListCollectionViewCell.m
//  ug
//
//  Created by ug on 2019/6/15.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGGameListCollectionViewCell.h"
#import "UGPlatformGameModel.h"
#import "FLAnimatedImageView.h"

@interface UGGameListCollectionViewCell ()
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *playLabel;

@end
@implementation UGGameListCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.playLabel.layer.cornerRadius = self.playLabel.height / 2;
    self.playLabel.layer.masksToBounds = YES;
    
}

- (void)setItem:(UGSubGameModel *)item {
    _item = item;
    self.nameLabel.text = item.name;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:item.pic] placeholderImage:[UIImage imageNamed:@"loading"]];
    
}

@end
