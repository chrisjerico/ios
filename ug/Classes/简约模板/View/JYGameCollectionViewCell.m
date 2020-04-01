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
    UIImage *image = [[SDImageCache sharedImageCache] imageFromCacheForKey:[[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:item.icon]]];
    if (image) {
          
               CGFloat w = APP.Width - 16;
               CGFloat h = 214.0/724.0 * w;
//                CGFloat h = (image.height/image.width) * w;
               self.imgView.cc_constraints.height.constant = h;
           
           [self.imgView  sd_setImageWithURL:[NSURL URLWithString:item.icon]];   // 由于要支持gif动图，还是用sd加载
       } else {

           self.imgView.cc_constraints.height.constant = 120;
           [self.imgView sd_setImageWithURL:[NSURL URLWithString:item.icon] placeholderImage:[UIImage imageNamed:@"loading"]];
       }
  
}

@end
