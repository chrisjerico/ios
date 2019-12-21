//
//  UGHomeTitleView.m
//  ug
//
//  Created by ug on 2019/7/8.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGHomeTitleView.h"

@interface UGHomeTitleView ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIView *moreView;
@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;

@end
@implementation UGHomeTitleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"UGHomeTitleView" owner:self options:0].firstObject;
        self.frame = frame;
		[self.userNameLabel addGestureRecognizer:[UITapGestureRecognizer gestureRecognizer:^(__kindof UIGestureRecognizer *gr) {
			if (self.userNameTouchedBlock) {
				self.userNameTouchedBlock();
			}
		}]];
		[self.userNameLabel setUserInteractionEnabled:true];
    }
    return self;
}

- (void)setUserName:(NSString *)userName {
    _userName = userName;
    self.userNameLabel.text = userName;
}
- (void)setShowLoginView:(BOOL)showLoginView {
    _showLoginView = showLoginView;
    self.loginView.hidden = !showLoginView;
    self.moreView.hidden = showLoginView;
}
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

- (CGSize)intrinsicContentSize{
    
    return UILayoutFittingExpandedSize;
    
}

- (void)setImgName:(NSString *)imgName {
    _imgName = imgName;
    NSString *url = [CMCommon imgformat:imgName];
    [_imgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
}

@end
