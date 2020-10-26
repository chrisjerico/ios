//
//  TkLMoneyCollectionViewCell.m
//  UGBWApp
//
//  Created by fish on 2020/10/26.
//  Copyright © 2020 ug. All rights reserved.
//

#import "TkLMoneyCollectionViewCell.h"
@interface TkLMoneyCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
@implementation TkLMoneyCollectionViewCell

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
