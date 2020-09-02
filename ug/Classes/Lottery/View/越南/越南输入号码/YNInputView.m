//
//  YNInputView.m
//  UGBWApp
//
//  Created by andrew on 2020/7/27.
//  Copyright © 2020 ug. All rights reserved.
//

#import "YNInputView.h"

@interface YNInputView()



@property (strong, nonatomic) IBOutlet UIView *contentView;
@end
@implementation YNInputView

- (instancetype)YNInputView {
 return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];//(owner:self ，firstObject必要)
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (!self.subviews.count) {
        self.contentView = [[YNInputView alloc] initWithFrame:CGRectZero];
        self.contentView.frame = self.bounds;
        [self addSubview:self.contentView];
        
        [self inputViewInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.contentView = [self YNInputView];
        self.contentView.frame = self.bounds;
        [self addSubview:self.contentView];
    }
    [self inputViewInit];
    return self;
}


- (void)inputViewInit{
   
//    msg = [NSString stringWithFormat:@"%@",
//    [s stringByReplacingOccurrencesOfString:@"\\n" withString:@" \r\n" ]];
    _inputTextView.backgroundColor = Skin1.homeContentColor;
    self.contentView.backgroundColor = Skin1.bgColor;
    _inputTextView.textColor = Skin1.textColor1;
}

-(void)setCode:(TipsType)code{
    NSString *str = @"";
    if (code == Tip_千) {
        str = @" 怎么玩：\n 在每个下注之间用英文分号“;”分隔\n 例如：0001;0015;0099";
    }
    else  if(code == Tip_百) {
        str = @" 怎么玩：\n 在每个下注之间用英文分号“;”分隔\n 例如：001;015;099";
    }
    else  if(code == Tip_十) {
        str = @" 怎么玩：\n 在每个下注之间用英文分号“;”分隔\n 例如：01;15;99";
    }
    
    [self.inputTextView setPlaceholderWithText:str Color:Skin1.textColor1];
}

@end
