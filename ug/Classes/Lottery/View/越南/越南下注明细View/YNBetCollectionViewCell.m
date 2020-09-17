//
//  YNBetCollectionViewCell.m
//  UGBWApp
//
//  Created by ug on 2020/8/30.
//  Copyright © 2020 ug. All rights reserved.
//

#import "YNBetCollectionViewCell.h"


#import "UGGameplayModel.h"
@interface YNBetCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation YNBetCollectionViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.layer.cornerRadius= 3;
//    self.layer.masksToBounds = YES;
//    self.backgroundColor = UGBlueColor;
}

- (void)setItem:(UGGameBetModel *)item {
    _item = item;
    self.titleLabel.text = item.name;
    
}
@end
