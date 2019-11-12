//
//  UGLinkNumCollectionViewCell.m
//  ug
//
//  Created by ug on 2019/7/25.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGLinkNumCollectionViewCell.h"
#import "UGGameplayModel.h"
@interface UGLinkNumCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
@implementation UGLinkNumCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.nameLabel.layer.cornerRadius= self.nameLabel.height / 2;
    self.nameLabel.layer.masksToBounds = YES;
    self.nameLabel.backgroundColor = UGBlueColor;
    
    if ([Skin1.skitType isEqualToString:@"黑色模板"]) {
        [self.contentView setBackgroundColor:Skin1.bgColor];
         self.layer.borderWidth = 1;
         self.layer.borderColor = Skin1.navBarBgColor.CGColor;
    } else {
        self.layer.borderWidth = 1;
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        self.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    
}

- (void)setItem:(UGGameBetModel *)item {
    _item = item;
    self.nameLabel.text = item.name;
    if ([Skin1.skitType isEqualToString:@"黑色模板"]) {
        if (item.select) {
            self.layer.borderColor = [UIColor whiteColor].CGColor;
            self.layer.borderWidth = 1;
        }else {
            self.layer.borderColor = Skin1.navBarBgColor.CGColor;
        }
    } else {
        if (item.select) {
            self.layer.borderColor = Skin1.navBarBgColor.CGColor;
            self.layer.borderWidth = 1;
        }else {
            self.layer.borderColor = [UIColor whiteColor].CGColor;
        }
    }
}


@end
