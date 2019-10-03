//
//  UGMineSkinFirstCollectionHeadView.m
//  ug
//
//  Created by ug on 2019/10/2.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGMineSkinFirstCollectionHeadView.h"

@interface UGMineSkinFirstCollectionHeadView ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
@implementation UGMineSkinFirstCollectionHeadView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setMenuName:(NSString *)menuName {
    _menuName = menuName;
    self.nameLabel.text = menuName;
}
@end
