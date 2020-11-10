//
//  HSC_HomeGameCollectionCell.m
//  ug
//
//  Created by tim swift on 2020/1/18.
//  Copyright © 2020 ug. All rights reserved.
//

#import "HSC_HomeGameCollectionCell.h"
@interface HSC_HomeGameCollectionCell()
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *itemLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;


@end
@implementation HSC_HomeGameCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)bind:(GameModel *)item {
    [self.itemImageView sd_setImageWithURL:[NSURL URLWithString:item.icon] placeholderImage: [UIImage imageNamed:@""]];
    self.itemLabel.text = item.title.length > 0 ? item.title : item.name;
    self.descriptionLabel.text = item.name.length > 0 ? item.name : item.title;
    
}
@end
