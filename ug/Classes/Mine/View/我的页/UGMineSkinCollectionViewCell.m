//
//  UGMineSkinCollectionViewCell.m
//  ug
//
//  Created by ug on 2019/10/2.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGMineSkinCollectionViewCell.h"
@interface UGMineSkinCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
@implementation UGMineSkinCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    [self setBackgroundColor: [[UGSkinManagers shareInstance] setCellbgColor]];

    self.layer.borderWidth = 1;
    
//    self.layer.borderColor = [UGRGBColor(203, 202, 202) CGColor];
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
