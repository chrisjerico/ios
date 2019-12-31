
//
//  UGFastThreeOneCollectionViewCell.m
//  ug
//
//  Created by ug on 2019/5/17.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGFastThreeOneCollectionViewCell.h"

@interface UGFastThreeOneCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end


@implementation UGFastThreeOneCollectionViewCell

- (void)setNum:(NSString *)num {
    _num = num;
    self.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"shaizi%@",num]];
}


@end
