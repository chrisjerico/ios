//
//  UGBargainingCollectionViewCell.m
//  UGBWApp
//
//  Created by fish on 2020/11/6.
//  Copyright © 2020 ug. All rights reserved.
//

#import "UGBargainingCollectionViewCell.h"
#import "HelpDocModel.h"
@interface UGBargainingCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *mImgView;
@end
@implementation UGBargainingCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setItem:(HelpDocModel *)item {
    _item = item;
    [self.mImgView setImage:[UIImage imageNamed:item.webName]];
}
@end
