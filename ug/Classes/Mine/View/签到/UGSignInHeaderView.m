//
//  UGSignInHeaderView.m
//  ug
//
//  Created by ug on 2019/9/5.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGSignInHeaderView.h"
@interface UGSignInHeaderView ()
@property (weak, nonatomic) IBOutlet UIImageView *signInImageView;

@end
@implementation UGSignInHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"UGSignInHeaderView" owner:self options:0].firstObject;
        self.frame = frame;
        [self setBackgroundColor: Skin1.bgColor];

    }
    return self;
}


-(instancetype) UGSignInHeaderView{
    
    
    NSBundle *bundle=[NSBundle mainBundle];
    NSArray *objs=[bundle loadNibNamed:@"UGSignInHeaderView" owner:nil options:nil];
    return [objs lastObject];
    
    
    
}

-(instancetype)initView{
    
    if (self = [super init]) {
        self = [self UGSignInHeaderView];
    }
    [self setBackgroundColor: Skin1.bgColor];

    return self;
    
    
}

- (IBAction)signInClick:(id)sender {
    if (self.signInHeaderViewnBlock) {
        self.signInHeaderViewnBlock();
    }
}

@end
