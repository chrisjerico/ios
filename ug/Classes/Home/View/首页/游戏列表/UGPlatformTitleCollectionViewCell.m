//
//  UGPlatformTitleCollectionViewCell.m
//  ug
//
//  Created by ug on 2019/5/2.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGPlatformTitleCollectionViewCell.h"
#import "UGPlatformGameModel.h"
#import "FLAnimatedImageView.h"
@interface UGPlatformTitleCollectionViewCell ()
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *imageView;  /**<   图片ImageView */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *title2Label;
@end
@implementation UGPlatformTitleCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setBackgroundColor:Skin1.homeContentColor];
    _titleLabel.textColor = Skin1.textColor1;
    _title2Label.textColor = Skin1.textColor1;
    [_title2Label setHidden:!APP.isShowLogo];
    [_imageView setHidden:!APP.isShowLogo];
    [_titleLabel setHidden:APP.isShowLogo];
	if ([Skin1.skitType isEqualToString:@"金沙主题"]) {
		[_titleLabel setHidden:false];
		[_title2Label setHidden:true];
		[_imageView setHidden:true];
		_titleLabel.textColor = [UIColor colorWithHex:0x111111];
		[self setBackgroundColor: [UIColor redColor]];

	}
    if (Skin1.isJY) {
        _title2Label.textColor = RGBA(117, 117, 117, 1);
        [self setBackgroundColor: [UIColor whiteColor]];
        [_title2Label setFont:[UIFont systemFontOfSize:13]];

    }
    if (Skin1.is23) {
         _titleLabel.textColor = [UIColor blackColor];
    }
}

- (void)setItem:(GameCategoryModel *)item {
    _item = item;
    self.titleLabel.text = item.name;
    self.title2Label.text = item.name;
    NSLog(@"item.logo = %@",item.logo);
    
//    - (void)sd_setImageWithURL:(nullable NSURL *)url placeholderImage:(nullable UIImage *)placeholder completed:(nullable SDExternalCompletionBlock)completedBlock {
//        [self sd_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:completedBlock];
//    }
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:item.logo] placeholderImage:[UIImage imageNamed:@"loading"]  completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (Skin1.isJY) {
            self.imageView.image  = [image qmui_imageWithTintColor:RGBA(117, 117, 117, 1)] ;

        }
      
    }] ;

}

- (void)setSelected:(BOOL)selected {
    if (selected) {
        self.titleLabel.textColor = [UIColor redColor];
        self.title2Label.textColor = [UIColor redColor];
    } else {
        self.titleLabel.textColor = Skin1.textColor1;
        self.title2Label.textColor = Skin1.textColor1;
    }
	
	if ([Skin1.skitType isEqualToString:@"金沙主题"]) {
		_titleLabel.textColor = selected ?  UIColor.redColor : [UIColor colorWithHex:0x111111];
	}
    if (Skin1.isJY) {
        _title2Label.textColor = selected ? RGBA(217, 157, 63, 1) : RGBA(117, 117, 117, 1);
        self.imageView.image = selected ? [self.imageView.image qmui_imageWithTintColor:RGBA(217, 157, 63, 1)] :  [self.imageView.image qmui_imageWithTintColor:RGBA(117, 117, 117, 1)] ;
        if (selected) {
             [CMCommon setBorderWithView:self top:NO left:NO bottom:YES right:NO borderColor:RGBA(217, 157, 63, 1)  borderWidth:1];
        }
        else{
             [CMCommon setBorderWithView:self top:NO left:NO bottom:YES right:NO borderColor:UIColor.whiteColor  borderWidth:1];
        }
       
    }
    if (Skin1.is23) {
        _titleLabel.textColor = selected ?  UIColor.redColor : [UIColor blackColor];

    }
}

@end
