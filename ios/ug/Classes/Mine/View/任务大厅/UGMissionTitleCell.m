//
//  UGMissionTitleCell.m
//  ug
//
//  Created by ug on 2019/5/28.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGMissionTitleCell.h"

@interface UGMissionTitleCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
@implementation UGMissionTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    if (Skin1.isBlack) {
        [self.contentView setBackgroundColor:Skin1.bgColor];
        [self.titleLabel setTextColor:Skin1.textColor1];
    } else {
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        [self.titleLabel setTextColor:[UIColor blackColor]];
    }
    
}

- (void)setImgName:(NSString *)imgName {
    _imgName = imgName;
    self.imgView.image = [UIImage imageNamed:imgName];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
    
}

- (void)setSelected:(BOOL)selected {
    if (Skin1.isBlack) {
        if (selected) {
            self.layer.borderColor = [UIColor whiteColor].CGColor;
            self.layer.borderWidth = 1;
        }else {
            self.layer.borderColor = Skin1.navBarBgColor.CGColor;
        
        }
    } else {
        if (selected) {
            self.layer.borderColor = Skin1.navBarBgColor.CGColor;
            self.layer.borderWidth = 1;
        }else {
            self.layer.borderColor = [UIColor whiteColor].CGColor;
        
        }
    }

}

@end
