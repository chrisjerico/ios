//
//  JYMineCollectionViewCell.m
//  ug
//
//  Created by ug on 2020/2/14.
//  Copyright © 2020 ug. All rights reserved.
//

#import "JYMineCollectionViewCell.h"

@interface JYMineCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
@implementation JYMineCollectionViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = UIColor.whiteColor;
    self.nameLabel.textColor = UIColor.blackColor;
}
- (void)setMenuName:(NSString *)menuName {
    _menuName = menuName;
    self.nameLabel.text = menuName;
}



@end
