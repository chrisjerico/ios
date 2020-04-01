//
//  UGDepositDetailsCollectionViewCell.m
//  ug
//
//  Created by ug on 2019/9/10.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGDepositDetailsCollectionViewCell.h"

@interface UGDepositDetailsCollectionViewCell()

@end

@implementation UGDepositDetailsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    CALayer *layer= _myLabel.layer;
    //是否设置边框以及是否可见
    [layer setMasksToBounds:YES];
    //设置边框圆角的弧度
    [layer setCornerRadius:5];
    //设置边框线的宽
    [layer setBorderWidth:0];
    //设置边框线的颜色
    [layer setBorderColor:[UIColor whiteColor].CGColor];
    
    [_myLabel setBackgroundColor:Skin1.navBarBgColor];
    
    [self.myLabel setTextColor:[UIColor whiteColor]];
}

- (void)setMyStr:(NSString *)myStr {
    _myStr = myStr;
    self.myLabel.text = myStr;
    
}

-(void)setSelected:(BOOL)selected{
    if (APP.isHideText) {
        if (selected) {
             CALayer *layer= _myLabel.layer;
               //是否设置边框以及是否可见
               [layer setMasksToBounds:YES];
               //设置边框圆角的弧度
               [layer setCornerRadius:5];
               //设置边框线的宽
               [layer setBorderWidth:1];
               //设置边框线的颜色
        
               [layer setBorderColor:Skin1.navBarBgColor.CGColor];
               
               [_myLabel setBackgroundColor:[UIColor whiteColor]];
               
               [self.myLabel setTextColor:Skin1.navBarBgColor];
        } else {
             CALayer *layer= _myLabel.layer;
               //是否设置边框以及是否可见
               [layer setMasksToBounds:YES];
               //设置边框圆角的弧度
               [layer setCornerRadius:5];
               //设置边框线的宽
               [layer setBorderWidth:1];
               //设置边框线的颜色
               [layer setBorderColor:[UIColor whiteColor].CGColor];
               
               [_myLabel setBackgroundColor:Skin1.navBarBgColor];
               
               [self.myLabel setTextColor:[UIColor whiteColor]];
        }
    }
}
@end
