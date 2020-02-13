//
//  JYGameCollectionViewCell.m
//  ug
//
//  Created by ug on 2020/2/13.
//  Copyright © 2020 ug. All rights reserved.
//

#import "JYGameCollectionViewCell.h"
#import "FLAnimatedImageView.h"
@interface JYGameCollectionViewCell ()
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *imgView;      /**<   图片ImageView */


@end
@implementation JYGameCollectionViewCell
- (void)setItem:(GameModel *)item {
    _item = item;
    NSLog(@"icon = %@",item.icon);
    
    
//   [self.imgView sd_setImageWithURL:[NSURL URLWithString:item.icon] placeholderImage:[UIImage imageNamed:@"loading"]];
}

@end
