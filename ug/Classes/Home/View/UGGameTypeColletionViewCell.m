//
//  UGGameTypeColletionViewCell.m
//  ug
//
//  Created by ug on 2019/5/2.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGGameTypeColletionViewCell.h"
#import "UGPlatformGameModel.h"

@interface UGGameTypeColletionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *hotImageView;

@end
@implementation UGGameTypeColletionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = UGBackgroundColor.CGColor;
    self.layer.borderWidth = 0.7;
    self.hotImageView.hidden = YES;
    
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.nameLabel.text = title;
    
}

- (void)setImgName:(NSString *)imgName {
    _imgName = imgName;
    self.imgView.image = [UIImage imageNamed:imgName];
    
}

- (void)setItem:(GameModel *)item {
    _item = item;
    self.nameLabel.text = item.title;
//    self.hotImageView.hidden = !item.isHot;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:item.icon] placeholderImage:[UIImage imageNamed:@"zwt"]];
	
}

@end
