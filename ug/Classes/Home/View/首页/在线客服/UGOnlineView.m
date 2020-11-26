//
//  UGOnlineView.m
//  UGBWApp
//
//  Created by fish on 2020/10/22.
//  Copyright © 2020 ug. All rights reserved.
//

#import "UGOnlineView.h"
@interface UGOnlineView ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *oneBtn;
@property (weak, nonatomic) IBOutlet UIButton *twoBtn;

@end
@implementation UGOnlineView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"UGOnlineView" owner:self options:nil].firstObject;
        self.frame = frame;
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
     
        _oneBtn.layer.cornerRadius = 5;
        _oneBtn.layer.masksToBounds = YES;
        _oneBtn.layer.borderWidth = 1;
        _oneBtn.layer.borderColor = [[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1] CGColor];
        
        _twoBtn.layer.cornerRadius = 5;
        _twoBtn.layer.masksToBounds = YES;
        _twoBtn.layer.borderWidth = 1;
        _twoBtn.layer.borderColor = [[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1] CGColor];
        
        if (Skin1.isBlack||Skin1.is23||Skin1.isGPK) {
             self.backgroundColor = Skin1.bgColor;
            _titleLabel.textColor = Skin1.textColor4;
        } else {
             self.backgroundColor = [UIColor whiteColor];
            _titleLabel.textColor = Skin1.textColor1;
        }
       
    }
    return self;
}

- (IBAction)oneAction:(id)sender {

    [CMCommon goSLWebViewControllerUrl:SysConf.zxkfUrl] ;
    [self close:self];
}

- (IBAction)twoAction:(id)sender {
    [CMCommon goSLWebViewControllerUrl:SysConf.zxkfUrl2] ;
    [self close:self];
}


- (IBAction)close:(id)sender {
    
    [self hiddenSelf];
}

- (void)show {
    
    UIWindow* window = UIApplication.sharedApplication.keyWindow;
    UIView* maskView = [[UIView alloc] initWithFrame:window.bounds];
    UIView* view = self;
    view.hidden = NO;
    
    maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    maskView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    [maskView addSubview:view];
    [window addSubview:maskView];
    
}

- (void)hiddenSelf {
    
    UIView* view = self;
    self.superview.backgroundColor = [UIColor clearColor];
    [view.superview removeFromSuperview];
    [view removeFromSuperview];
    
}


@end
