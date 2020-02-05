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
    
    if (self.ballImg.isHidden) {

        [self.titleLabel  mas_remakeConstraints:^(MASConstraintMaker *make)
         {
            make.centerX.equalTo(self.mas_centerX).with.offset(-2);
        }];
    

    }
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
    
    if (self.showBall6) {
        [self.ballImg setHidden:NO];
        
        if ([@"blue" isEqualToString:color]) {
            [self.ballImg setImage:[UIImage imageNamed:@"icon_blue"]];
        } else if ([@"red" isEqualToString:color]) {
            [self.ballImg setImage:[UIImage imageNamed:@"icon_red"]];
        } else {
            [self.ballImg setImage:[UIImage imageNamed:@"icon_green"]];
        }
    } else {
        if ([@"blue" isEqualToString:color]) {
            self.backgroundColor = UGRGBColor(86, 170, 236);
        } else if ([@"red" isEqualToString:color]) {
            self.backgroundColor = UGRGBColor(197, 52, 60);
        } else {
            self.backgroundColor = UGRGBColor(96, 174, 108);
        }
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
        if (self.showBall6) {
            self.backgroundColor = [UIColor clearColor];
        } else {
            self.backgroundColor = Skin1.navBarBgColor;
        }
        self.layer.borderColor = [UIColor clearColor].CGColor;
        
        self.titleLabel.textColor = [UIColor whiteColor];
    }
}

- (void)setShowAdd:(BOOL)showAdd {
    _showAdd = showAdd;
    self.layer.cornerRadius = self.width / 2;
    self.layer.masksToBounds = YES;
    if (showAdd) {
        [self.ballImg setHidden:YES];
        self.backgroundColor = [UIColor clearColor];
        if (Skin1.isBlack) {
            self.titleLabel.textColor = [UIColor whiteColor];
            
        } else {
            self.titleLabel.textColor = [UIColor blackColor];
        }
        if (self.showIsequal) {
            self.titleLabel.text = @"=";
        }else {
            
            self.titleLabel.text = @"+";
        }
    }else {
        
        if (self.showBall6) {
            self.titleLabel.textColor = [UIColor blackColor];
            self.backgroundColor = [UIColor clearColor];
        }
        else{
            self.backgroundColor = Skin1.navBarBgColor;
            self.titleLabel.textColor = [UIColor whiteColor];
        }
        
        
    }
}



@end
