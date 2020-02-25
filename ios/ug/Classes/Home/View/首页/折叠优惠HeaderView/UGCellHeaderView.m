//
//  UGCellHeaderView.m
//  ug
//
//  Created by ug on 2020/2/25.
//  Copyright © 2020 ug. All rights reserved.
//

#import "UGCellHeaderView.h"
#import "UGPromoteModel.h"

@interface UGCellHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIStackView *stackView;

@end
@implementation UGCellHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];

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
    
    subView(@"cell背景View").backgroundColor = Skin1.isBlack ? Skin1.bgColor : Skin1.homeContentColor;
    _titleLabel.textColor = Skin1.textColor1;
    _titleLabel.text = _item.title;
    _titleLabel.hidden = !_item.title.length;
    
    UIImageView *imgView = _imageView;
    //    imgView.frame = cell.bounds;
    NSURL *url = [NSURL URLWithString:_item.pic];
    UIImage *image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:[[SDWebImageManager sharedManager] cacheKeyForURL:url]];
    if (image) {
        if ([@"c190" containsString:APP.SiteId]) {
            CGFloat w = APP.Width;
            CGFloat h = image.height/image.width * w;
            imgView.cc_constraints.height.constant = h;
        } else {
            CGFloat w = APP.Width - 48;
            CGFloat h = image.height/image.width * w;
            imgView.cc_constraints.height.constant = h;
            
            
        }
        [imgView sd_setImageWithURL:url];   // 由于要支持gif动图，还是用sd加载
         self.cc_constraints.height.constant = subView(@"cell背景View").size.height + 20;
        _item.headHeight = subView(@"cell背景View").size.height + 20;
    } else {

        imgView.cc_constraints.height.constant = 60;
        [imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (image) {

            }
        }];
         self.cc_constraints.height.constant = subView(@"cell背景View").size.height + 20;
        _item.headHeight = subView(@"cell背景View").size.height + 20;
    }

}


- (IBAction)showDetail:(id)sender {
    
    if (self.clickBllock) {
        self.clickBllock();
    }
    
}

@end
