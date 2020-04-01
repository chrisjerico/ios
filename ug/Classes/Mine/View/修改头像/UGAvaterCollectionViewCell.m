//
//  UGAvaterCollectionViewCell.m
//  ug
//
//  Created by ug on 2019/5/16.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGAvaterCollectionViewCell.h"
#import "UGAvatarModel.h"
//#import "UIImageView+WebCache.h"
//#import "FLAnimatedImageView+WebCache.h"
@interface UGAvaterCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end


@implementation UGAvaterCollectionViewCell

- (void)setItem:(UGAvatarModel *)item {
    _item = item;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:item.url] placeholderImage:[UIImage imageNamed:@"txp"] options:SDWebImageAllowInvalidSSLCertificates];
}

@end
