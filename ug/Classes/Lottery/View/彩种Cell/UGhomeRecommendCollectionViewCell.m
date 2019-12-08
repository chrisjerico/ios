//
//  UGhomeRecommendCollectionViewCell.m
//  ug
//
//  Created by ug on 2019/9/30.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGhomeRecommendCollectionViewCell.h"
#import "UGYYPlatformGames.h"

@interface UGhomeRecommendCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end
@implementation UGhomeRecommendCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = Skin1.homeContentColor;
    self.nameLabel.textColor = Skin1.textColor1;
    self.clipsToBounds = false;
    self.layer.cornerRadius = 10;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 1);
    self.layer.shadowRadius = 2;
    self.layer.shadowOpacity = 0.1;
}

- (void)setItem:(UGYYPlatformGames *)item {
    _item = item;
    self.nameLabel.text = [NSString stringWithFormat:@"%@系列", item.categoryName];
   
    NSDictionary *dict = @{
        @"lottery":@"cp",   // 彩票系列
        @"game":@"dz",      // 电子系列
        @"fish":@"by",      // 捕鱼系列
        @"card":@"qp",      // 棋牌系列
        @"sport":@"ty",     // 体育系列
        @"real":@"zr",      // 真人系列
        @"esport":@"dj",    // 电竞系列
    };
    [self.imgView setImage:[UIImage imageNamed:dict[item.category]]];
}

- (void)setItemGame:(UGYYGames *)itemGame {
    _itemGame = itemGame;
    self.nameLabel.text = [NSString stringWithFormat:@"%@",itemGame.title];
    
    NSLog(@"itemGame = %@",itemGame);
    
    NSLog(@"itemGame.pic = %@",itemGame.pic);
   
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:[CMCommon imgformat:itemGame.pic]] placeholderImage:[UIImage imageNamed:@"loading"]];
    
}


@end
