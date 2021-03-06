//
//  UGContentMoneyCollectionViewCell.m
//  ug
//
//  Created by ug on 2019/9/19.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGContentMoneyCollectionViewCell.h"

@interface UGContentMoneyCollectionViewCell()
@property (weak, nonatomic) IBOutlet UILabel *myLabel;

@end

@implementation UGContentMoneyCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    // Initialization code
    CALayer *layer= _myLabel.layer;
    //是否设置边框以及是否可见
    [layer setMasksToBounds:YES];
    //设置边框圆角的弧度
    [layer setCornerRadius:3];
//    //设置边框线的宽
//    [layer setBorderWidth:1];
//    //设置边框线的颜色
//    [layer setBorderColor:UGRGBColor(96, 149, 229).CGColor];
    
    if ([APP.SiteId isEqualToString:@"c245"]) {
        [self setBackgroundColor: [UIColor whiteColor]];
    } else {
        [self setBackgroundColor: Skin1.cellBgColor];
    }
      
    
}

- (void)setMyStr:(NSString *)myStr {
    _myStr = myStr;
    self.myLabel.text = myStr;
    
}
@end
