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
//-(void)skin{
//     [self setBackgroundColor: [[UGSkinManagers shareInstance] sethomeContentColor]];
//}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [[[UGSkinManagers shareInstance] sethomeContentColor] CGColor];
    [self setBackgroundColor: [[UGSkinManagers shareInstance] sethomeContentColor]];
    
//    SANotificationEventSubscribe(UGNotificationWithSkinSuccess, self, ^(typeof (self) self, id obj) {
//        
//        [self skin];
//    });
}

- (void)setItem:(UGYYPlatformGames *)item {
    _item = item;
    self.nameLabel.text = [NSString stringWithFormat:@"%@系列",item.categoryName];
   
    if ([item.category isEqualToString:@"lottery"]) {
         [self.imgView setImage:[UIImage imageNamed:@"cp"]];
    }
    else  if([item.category isEqualToString:@"game"]) {
         [self.imgView setImage:[UIImage imageNamed:@"dz"]];
    }
    else  if([item.category isEqualToString:@"fish"]) {
         [self.imgView setImage:[UIImage imageNamed:@"by"]];
    }
    else  if([item.category isEqualToString:@"card"]) {
         [self.imgView setImage:[UIImage imageNamed:@"qp"]];
    }
    else  if([item.category isEqualToString:@"sport"]) {
         [self.imgView setImage:[UIImage imageNamed:@"ty"]];
    }
    else  if([item.category isEqualToString:@"real"]) {
         [self.imgView setImage:[UIImage imageNamed:@"zr"]];
    }
   
   
}

- (void)setItemGame:(UGYYGames *)itemGame {
    _itemGame = itemGame;
    self.nameLabel.text = [NSString stringWithFormat:@"%@",itemGame.title];
    
    NSLog(@"itemGame = %@",itemGame);
    
    NSLog(@"itemGame.pic = %@",itemGame.pic);
   
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:[CMCommon imgformat:itemGame.pic]] placeholderImage:[UIImage imageNamed:@"loading"]];
    
}


@end
