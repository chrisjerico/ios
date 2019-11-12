//
//  UGLotteryResultCollectionViewCell.m
//  ug
//
//  Created by ug on 2019/5/11.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGLotteryResultCollectionViewCell.h"

@interface UGLotteryResultCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
@implementation UGLotteryResultCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.cornerRadius = self.width / 2;
    self.layer.masksToBounds = YES;

}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (CALayer *)layer {
    return _titleLabel.layer;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    _titleLabel.backgroundColor = backgroundColor;
}

- (void)setColor:(NSString *)color {
    _color = color;
    if ([@"blue" isEqualToString:color]) {
        self.backgroundColor = UGRGBColor(86, 170, 236);
    } else if ([@"red" isEqualToString:color]) {
        self.backgroundColor = UGRGBColor(197, 52, 60);
    } else {
        self.backgroundColor = UGRGBColor(96, 174, 108);
    }
}

- (void)setShowBorder:(BOOL)showBorder {
    _showBorder = showBorder;
    if (showBorder) {
        self.layer.borderColor = [UIColor redColor].CGColor;
        self.layer.borderWidth = 1;
        self.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [UIColor blackColor];
    } else {
        self.layer.borderColor = [UIColor clearColor].CGColor;
        self.backgroundColor = Skin1.navBarBgColor;
        self.titleLabel.textColor = [UIColor whiteColor];
    }
}

- (void)setShowAdd:(BOOL)showAdd {
    _showAdd = showAdd;
    self.layer.cornerRadius = self.width / 2;
    self.layer.masksToBounds = YES;
    if (showAdd) {
        self.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [UIColor blackColor];
        if (self.showIsequal) {
            self.titleLabel.text = @"=";
        }else {
            
            self.titleLabel.text = @"+";
        }
    }else {
        self.backgroundColor = Skin1.navBarBgColor;
        self.titleLabel.textColor = [UIColor whiteColor];
        
    }
}



@end
