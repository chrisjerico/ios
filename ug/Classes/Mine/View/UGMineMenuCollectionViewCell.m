//
//  UGMineMenuCollectionViewCell.m
//  ug
//
//  Created by ug on 2019/4/30.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGMineMenuCollectionViewCell.h"

@interface UGMineMenuCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
@implementation UGMineMenuCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setImageName:(NSString *)imageName {
    _imageName = imageName;
    self.imageView.image = [UIImage imageNamed:imageName];
    
}

- (void)setMenuName:(NSString *)menuName {
    _menuName = menuName;
    self.nameLabel.text = menuName;
}

- (void)setBadgeNum:(NSInteger)badgeNum {
    _badgeNum = badgeNum;
    if (badgeNum) {
        [self showBadgeWithStyle:WBadgeStyleNumber value:badgeNum animationType:WBadgeAnimTypeNone];
        self.badgeCenterOffset = CGPointMake(-40, 30);
    }else {
        [self clearBadge];
    }
}
@end
