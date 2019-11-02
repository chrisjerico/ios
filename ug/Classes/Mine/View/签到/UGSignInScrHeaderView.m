//
//  UGSignInScrHeaderView.m
//  ug
//
//  Created by ug on 2019/9/5.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGSignInScrHeaderView.h"

@interface UGSignInScrHeaderView ()
@property (weak, nonatomic) IBOutlet UIImageView *signIn1ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *signIn2ImageView;
@property (weak, nonatomic) IBOutlet UILabel *signInNumberLable;

@end

@implementation UGSignInScrHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"UGSignInScrHeaderView" owner:self options:0].firstObject;
        self.frame = frame;
        [self setBackgroundColor: Skin1.bgColor];
       
    }
    return self;
}


-(instancetype) UGSignInScrHeaderView{
    
    
    NSBundle *bundle=[NSBundle mainBundle];
    NSArray *objs=[bundle loadNibNamed:@"UGSignInScrHeaderView" owner:nil options:nil];
    return [objs lastObject];
    
}

-(instancetype)initView{
    
    if (self = [super init]) {
        self = [self UGSignInScrHeaderView];
    }
    
    return self;
    
    
}

- (void)setSignInNumberStr:(NSString *)signInNumberStr {
    _signInNumberStr = signInNumberStr;
    self.signInNumberLable.text = signInNumberStr;
    
}

@end
