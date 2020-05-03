//
//  LYLuckyCardCellView.h
//  LYLuckyCardDemo
//
//  Created by leo on 17/2/9.
//  Copyright © 2017年 leo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLAnimatedImageView.h"
#import "DZPModel.h"

@interface LYLuckyCardCellView : UIView
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) FLAnimatedImageView *imageView;
@property (nonatomic, strong) DZPprizeModel *item;
-(void)configCell:(int )a;
@end
