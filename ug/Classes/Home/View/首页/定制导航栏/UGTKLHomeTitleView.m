//
//  UGTKLHomeTitleView.m
//  UGBWApp
//
//  Created by ug on 2020/9/5.
//  Copyright © 2020 ug. All rights reserved.
//

#import "UGTKLHomeTitleView.h"
@interface UGTKLHomeTitleView ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIView *moreView;
@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet UILabel *playNameLabel;

@end
@implementation UGTKLHomeTitleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"UGTKLHomeTitleView" owner:self options:0].firstObject;
        self.frame = frame;
        [self.userNameLabel addGestureRecognizer:[UITapGestureRecognizer gestureRecognizer:^(__kindof UIGestureRecognizer *gr) {
            if (self.userNameTouchedBlock) {
                self.userNameTouchedBlock();
            }
        }]];
        [self.userNameLabel setUserInteractionEnabled:true];
        self.playNameLabel.layer.cornerRadius = 10;
        self.playNameLabel.layer.masksToBounds = YES;
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    if (frame.size.width > APP.Width || frame.size.height > 50) {
        frame = NavController1.navigationBar.bounds;
    }
    [super setFrame:frame];
    
    if (@available(iOS 11.0, *)) {} else {
        [self.imgView.superview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_offset(APP.Width);
        }];
    }
}

- (void)setUserName:(NSString *)userName {
    _userName = userName;
    self.userNameLabel.text = userName;
}

- (void)setImgName:(NSString *)imgName {
    _imgName = imgName;
    NSString *url = [CMCommon imgformat:imgName];
    [_imgView sd_setImageWithURL:[NSURL URLWithString:url]];
}

- (void)setShowLoginView:(BOOL)showLoginView {
    _showLoginView = showLoginView;
    self.loginView.hidden = !showLoginView;
    self.moreView.hidden = showLoginView;
}


#pragma mark - IBAction

- (IBAction)moreButtonClick:(id)sender {
    if (self.moreClickBlock) {
        self.moreClickBlock();
    }
}

- (IBAction)tryPlayClick:(id)sender {
    if (self.tryPlayClickBlock) {
        self.tryPlayClickBlock();
    }
}

- (IBAction)loginClick:(id)sender {
    if (self.loginClickBlock) {
        self.loginClickBlock();
    }
}

- (IBAction)registerClick:(id)sender {
    if (self.registerClickBlock) {
        self.registerClickBlock();
    }
}


#pragma mark - intrinsicContentSize

- (CGSize)intrinsicContentSize {
    return UILayoutFittingExpandedSize;
}

@end
