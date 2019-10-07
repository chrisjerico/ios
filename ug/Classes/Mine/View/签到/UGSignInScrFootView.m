//
//  UGSignInScrFootView.m
//  ug
//
//  Created by ug on 2019/9/5.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGSignInScrFootView.h"

@interface UGSignInScrFootView ()
@property (weak, nonatomic) IBOutlet UILabel *fiveLable;//5天连续签到的文字
@property (weak, nonatomic) IBOutlet UILabel *sevenLable;//7天连续签到的文字

@end


@implementation UGSignInScrFootView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"UGSignInScrFootView" owner:self options:0].firstObject;
        self.frame = frame;
    }
    
    _fiveButton.layer.cornerRadius = 17;
    _fiveButton.layer.masksToBounds = YES;
    
    _sevenButtton.layer.cornerRadius = 17;
    _sevenButtton.layer.masksToBounds = YES;
    [self setBackgroundColor: [[UGSkinManagers shareInstance] setbgColor]];

    return self;
}

- (instancetype)UGSignInScrFootView {
    NSBundle *bundle=[NSBundle mainBundle];
    NSArray *objs=[bundle loadNibNamed:@"UGSignInScrFootView" owner:nil options:nil];
    return [objs lastObject];
}

- (instancetype)initView {
    if (self = [super init]) {
        self = [self UGSignInScrFootView];
    }
    
    _fiveButton.layer.cornerRadius = 17;
    _fiveButton.layer.masksToBounds = YES;
    
    _sevenButtton.layer.cornerRadius = 17;
    _sevenButtton.layer.masksToBounds = YES;
    return self;
}

- (IBAction)signInFiveClick:(id)sender {
    if (self.signInScrFootFiveBlock) {
        self.signInScrFootFiveBlock();
    }
}

- (IBAction)signInSevenClick:(id)sender {
    if (self.signInScrFootSevenBlock) {
        self.signInScrFootSevenBlock();
    }
}

- (void)setFiveStr:(NSString *)fiveStr {
    _fiveStr = fiveStr;
    self.fiveLable.text = fiveStr;
    
}

- (void)setSevenStr:(NSString *)sevenStr {
    _sevenStr = sevenStr;
    self.sevenLable.text = sevenStr;
    
}

@end
