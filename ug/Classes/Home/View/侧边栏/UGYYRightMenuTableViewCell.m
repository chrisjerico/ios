//
//  UGYYRightMenuTableViewCell.m
//  ug
//
//  Created by ug on 2019/9/28.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGYYRightMenuTableViewCell.h"
#import "FLAnimatedImageView.h"
@interface UGYYRightMenuTableViewCell ()


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak)IBOutlet UIImageView *imageIconView;
@property (weak, nonatomic) IBOutlet UIImageView *imageArrowView;
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *imgView;

@end

@implementation UGYYRightMenuTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_titleLabel setTextColor:Skin1.textColor1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setImageName:(NSString *)imageName {
//    _imageName = imageName;
//
//    UIImage *image = [UIImage imageNamed:imageName];
//    UIImage *afterImage;
//    if (Skin1.isBlack||Skin1.is23) {
//        afterImage = [image qmui_imageWithTintColor:Skin1.textColor1];
//    } else {
//        afterImage = [image qmui_imageWithTintColor:Skin1.navBarBgColor];
//    }
//
//    self.imageView.image = afterImage;
    _imageName = imageName;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:[UIImage imageNamed:@"loading"]  completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {

    }] ;
}

- (void)setImageIconName:(NSString *)imageIconName {
    _imageIconName = imageIconName;
    self.imageIconView.image = [UIImage imageNamed:imageIconName];
}

-(void)letArrowHidden{
    [self.imageIconView setHidden:NO];
    [self.imageArrowView setHidden:YES];
}

-(void)letIconHidden{
    [self.imageIconView setHidden:YES];
    [self.imageArrowView setHidden:NO];
}
@end
