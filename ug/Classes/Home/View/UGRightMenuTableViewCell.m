//
//  UGRightMenuTableViewCell.m
//  ug
//
//  Created by ug on 2019/5/9.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGRightMenuTableViewCell.h"

@interface UGRightMenuTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end
@implementation UGRightMenuTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setImageName:(NSString *)imageName {
    _imageName = imageName;
    self.imgView.image = [UIImage imageNamed:imageName];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
