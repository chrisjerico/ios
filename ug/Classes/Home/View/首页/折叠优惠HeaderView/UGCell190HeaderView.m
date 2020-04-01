//
//  UGCell190HeaderView.m
//  ug
//
//  Created by ug on 2020/2/27.
//  Copyright © 2020 ug. All rights reserved.
//

#import "UGCell190HeaderView.h"
#import "UGPromoteModel.h"
@interface UGCell190HeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIStackView *stackView;
@property (weak, nonatomic) IBOutlet UIButton *myBtn;

@end
@implementation UGCell190HeaderView
static CGFloat _contentWidth = 0;

+ (CGFloat)heightWithModel:(UGPromoteModel *)item {
    CGFloat textH = item.title.length ? [item.title heightForFont:[UIFont boldSystemFontOfSize:16] width:_contentWidth] : 0;
    textH += 20;
    UIImage *image = [[SDImageCache sharedImageCache] imageFromCacheForKey:[[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:item.pic]]];
    CGFloat imageH = _contentWidth/image.width * image.height;
    CGFloat otherH = 16 + !!item.title.length * 8;
    if (!image) {
        return 150;
    }
    return textH + imageH + otherH;
}

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!_contentWidth && _hBllock) {
        _contentWidth = self.width - 20;
        _hBllock();
    }
}

-(void)setItem:(UGPromoteModel *)item{
    _item = item;
    FastSubViewCode(self);
    if ([@"c190" containsString:APP.SiteId]) {
        _stackView.cc_constraints.top.constant = _item.title.length ? 12 : 0;
        _stackView.cc_constraints.bottom.constant = 0;
    }
    if ([@"c199" containsString:APP.SiteId]) {
        _stackView.cc_constraints.top.constant = 0;
        _stackView.cc_constraints.left.constant = 0;
    }
    
    if (Skin1.isJY) {
         subView(@"cell背景View").backgroundColor = Skin1.isBlack ? Skin1.bgColor :  RGBA(242, 242, 242, 1);
    }
    else{
         subView(@"cell背景View").backgroundColor = Skin1.isBlack ? Skin1.bgColor : Skin1.homeContentColor;
    }
    _titleLabel.textColor = Skin1.textColor1;
    _titleLabel.text = _item.title;
    _titleLabel.hidden = !_item.title.length;
    
    UIImageView *imgView = _imageView;
    NSURL *url = [NSURL URLWithString:_item.pic];
    __weakSelf_(__self);
    [imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image && __self.hBllock) {
            __self.hBllock();
        }
    }];
}

- (IBAction)showDetail:(id)sender {
    
    if (self.clickBllock) {
        self.clickBllock();
    }
    
}

@end
